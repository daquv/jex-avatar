/*
 * jQuery LiveUrl
 *
 * MIT License - You are free to use this commercial projects as long as the copyright header is left intact.
 * @author        Stephan Fischer
 * @copyright     (c) 2012 Stephan Fischer (www.ainetworks.de)
 * @version 1.2.2
 * 
 * UriParser is a function from my addon "Superswitch" for Mozilla FireFox.
 */

(function( $ )
{
    $.fn.extend(
    { 
        liveUrl : function( options) 
        {
            var defaults = 
            {
                meta: [
                    ['description','name',     'description'],
                    ['description','property', 'og:description'],
                    ['description','property', 'pinterestapp:about'],
                    ['image','property', 'og:image'],
                    ['image','itemprop', 'image'],
                    ['title','property', 'og:title'],
                    ['video','property', 'og:video'],
                    ['video_type','property', 'og:video:type'],
                    ['video_width','property', 'og:video:width'],
                    ['video_height','property', 'og:video:height']
               ],
               findLogo         : false,
               findDescription  : true,
               matchNoData      : true,
               multipleImages   : true,
               defaultProtocol  : 'http://',
               minWidth         : 100,
               minHeight        : 32,
               logoWord         : 'logo',
               success          : function() {},
               loadStart        : function() {},
               loadEnd          : function() {},
               imgLoadStart     : function() {},
               imgLoadEnd       : function() {},
               addImage         : function() {}
            }

            var options =  $.extend(defaults, options);
            
            this.each(function() 
            {
                
                var o       = options,
                    core    = {already : []},
                    url     = {},
                    preview = {};

                var that  = this;
                var self  = $(this);
                
                core.init = function () 
                {
                	//수정모드일때 미리 link 입력
        			var links = $.urlHelper.getLinks($(self).val());
                    if(links!=null){
                        $.each(links, function(key, val)
                        {
                            core.already.push(val); 
                        }); 
                    }
                    
                    core.preview = false;
                    core.processedImg = 0;
                    preview      = {
                        url : '',
                        images: [],
                        image : '',
                        type : '',
                        title: '' ,
                        description: '',
                        video_url: ''
                    };  
                };
                
                core.textUpdate = function(self) 
                {   
                    // read all links   
                    var links = $.urlHelper.getLinks($(self).val());
                    core.cleanDuplicates(links);
                    
                    if (links != null) {
                        if (!core.preview) {
                            core.current = $(self);
                            core.process(links);
                        }
                    }
                };
                
                core.process = function(urlArray) 
                {
                    for (var index in urlArray) {
        
                        var strUrl      = urlArray[index] ;
                        if (typeof strUrl == 'string') {
                            var pLink       = new $.urlHelper.UriParser(strUrl);

                            if (pLink.subdomain && pLink.subdomain.length > 0 || 
                                pLink.protocol  && pLink.protocol.length  > 0 ) {
                
                                if  (pLink.protocol.length == 0) {
                                    strUrl = o.defaultProtocol + strUrl;
                                }
                                
                                if (!core.isDuplicate(strUrl, core.already)) {
                                   
                                   if ($.urlHelper.isImage(strUrl)) {
                                       preview.image = strUrl;
                                       core.getPreview({}, strUrl);
                                       
                                   } else {
                                       core.getData(strUrl);  
                                   }
                                   
                                   return true;
                                }
                            }
                        }
                    } 
                };
                
                core.cleanDuplicates = function(urlArray) 
                {
                    var links = core.createLinks(urlArray);
                    
                    for(var index in core.already) {
                        var strUrl  = core.already[index];

                        if (typeof strUrl == 'string') {
	                        if (!core.isDuplicate(strUrl, links)){
	                            var index = $.inArray(strUrl, core.already);
	                            core.already.splice(index, 1);
	                        }
                        }
                    }
                };
                
                core.createLinks = function(urlArray) 
                {
                    var links = [];
                    
                    for(var index in urlArray) {
                        var strUrl  = urlArray[index];
                        if (typeof strUrl == 'string') {
                            var pLink   = new $.urlHelper.UriParser(strUrl);
                           
                            if (pLink.subdomain && pLink.subdomain.length > 0 || 
                                pLink.protocol  && pLink.protocol.length  > 0 ) {
                                    
                                if  (pLink.protocol.length == 0) {
                                    strUrl = o.defaultProtocol + strUrl;
                                }

                                links.push(strUrl);
                            }
                        }
                    }
                    
                    return links;
                }
                
                core.isDuplicate = function(url, array) 
                {
                    var duplicate = false;
                    $.each(array, function(key, val)
                    {
                    	if (val == url) {
                            duplicate = true;
                        } 
                    }); 
                    
                    return duplicate;
                };
                
                core.getData = function (url)
                {
                  
                    var xpath  =  '';
                    //var query  =  'select * from html where url="' + url + '" and compat="html5" and xpath="'+xpath+'"';
                    var query  =  url;
                    
                    var b_url = false;
                    var arr = query.split(".");
                    
                    if( !$.isNumeric(arr[arr.length -1]) ){
                    	b_url = true;
                    	for(var i=0; i < arr.length ; i++){
                         	if( 1 != arr[i].length){
                         		b_url = true;
                         	}else{
                         		b_url = false;
                         		break;
                         	}
                         }
                    }else{
                    	b_url = false;
                    }
                    
                    if(!b_url) return;
                    
                    $.yql(query, function() {
                            var data = {
                                query : {results: null}
                            }
                            console.log(JSON.stringify(data));
                            console.log(JSON.stringify(query));
                            
                            core.ajaxSuccess(data, url);
                            core.removeLoader();
                            return false;  
                        },
                        function(data) 
                        {
                            core.ajaxSuccess(data, url)
                        }
                    )
                }; //getData
                
                core.ajaxSuccess = function(data, url)
                {
                    // URL already loaded, or preview is already shown.
                    if (core.isDuplicate(url, core.already) || core.preview) {
                        core.removeLoader();
                        return false;  
                    }


                    //if ($(data).find("results").text().length == 0) {

                        if (o.matchNoData) {
                            core.getPreview(data, url);
                        }  else {
                            core.already.push(url);
                            core.removeLoader();
                        }
                        
                    //} else {
                    //    core.getPreview(data, url);
                    //}
                }
                
                
                core.hasValue     = function(section){
                	if(preview[section]==null){
                		return true;
                	}
                    return (preview[section].length == 0) ? false : true;  
                };
                
                core.getPreview = function(data, uri)
                {
                    core.preview = true; 
                    core.already.push(uri); 
                    /*
                    var title  = "" ;
                    
                    $(data, '<head>').find('title').each(function() 
                    {
                        title = $(this).text();
                    }); 
                    
                  
                    preview.title       = ( title || uri);
                    preview.url         = uri;
                    
                    $(data, '<head>').find('meta').each(function() 
                    {
                        core.setMetaData($(this));
                         
                    });
                    
                    if(o.findDescription && !core.hasValue('description')) {
                        
                        $(data, '<body>').find('p').each(function() 
                        {
                            var text = $.trim($(this).text());
                            if(text.length > 3) {
                                preview.description = text;
                                return false;
                            }
                             
                        });
                    }
                    
                    if (!core.hasValue('image')) {
                    // meta tag has no images:
                    
                        var images = $(data, '<body>').find('img');
                        
                        if (o.findLogo ) {
                           images.each(function() 
                            {
                                var self = $(this);
                                
                                if (self.attr('src') && self.attr('src').search(o.logoWord, 'i')  != -1 || 
                                    self.attr('id' ) && self.attr('id' ).search(o.logoWord, 'i')  != -1 ||
                                    this.className   &&   this.className.search(o.logoWord, 'i')  != -1  
                                                                ) {
                                    preview.image = $(this).attr('src');
                                    return false;
                                }

                            }); 
                        }

                        
                        if (!core.hasValue('image') && images.length > 0 ) {
                            images.each(function() 
                            {
                                preview.images.push($(this).attr('src'));
                            });
                        } 
                    }
                    */

                    if(data.title!=undefined){
                        preview.title = data.title;
                    } else {
                        preview.title = data.site_name;
                    }
                    preview.description = data.description;
                    preview.url = uri;
                    preview.image = data.image;
                    preview.type = data.type;
                    if(data.video_url!=undefined){
                        preview.video_url = data.video_url;
                    } else if(data.video!=undefined){
                        preview.video_url = data.video;
                    }

                    core.removeLoader();
                    
                    // prepare output
                    var not   = 'undefined';
                    var data  = {
                        //title       : preview.title,
                        //description : preview.description,
                        //url         : preview.url,
                        //video       : (typeof preview.video != not && preview.video.length > 0) ? {} : null
                        title       : preview.title,
                        description : preview.description,
                        url         : preview.url,
                        image       : preview.image,
                        type        : preview.type,
                        video       : (preview.type=='video') ? preview.video_url : null
                    };
                    
                    //if (data.video != null) {
                    //    data.video = {
                    //        file  :   preview.video_url
                            //type  : (typeof preview.video_type   != not) ? preview.video_type  : '',
                            //width : (typeof preview.video_width  != not) ? preview.video_width : '',
                            //height: (typeof preview.video_height != not) ? preview.video_height :''
                    //    }
                    //}
                    
                    o.success(data);
                    
                    if (core.hasValue('image')){
                    	preview.images.push(preview.image); 
                    	preview.image = '';
                    }
                    
                    
                    //core.addImages();
                    core.current.one('clear', function() 
                    {
                       core.init();
                    });     
                };
                
                core.addLoader = function()
                {  
                    o.loadStart();
                };
                
                core.removeLoader = function() 
                {
                    o.loadEnd();
                };
                
                core.setMetaData = function(val) 
                {
                    for (index in o.meta) {
                        var meta = o.meta[index];
                        preview[meta[0]] = (core.getValue(val,meta[1],meta[2])|| preview[meta[0]] );
                    }
                };
                
                core.getValue = function (val,key, tag) {
                    if (val.attr(key)) {
                        if (val.attr(key).toLowerCase() ==  tag.toLowerCase()) {
                            if (val.attr('content') && val.attr('content').length > 0) {
                                return val.attr('content');
                            }
                        } 
                        
                    }
                };
                
                core.addImages = function() 
                {
                    var images = [];
                    
                    for (var index in preview.images) {
                        var image = preview.images[index];
                        
                        if (!$.urlHelper.isAbsolute(image)) {
                            var pLink    = new $.urlHelper.UriParser(preview.url);
                            var host     = pLink.url + pLink.subdomain + pLink.domain;

                            if ($.urlHelper.isPathAbsolute(image)) 
                                 image = host + image; 
                            else image = host + $.urlHelper.stripFile(pLink.path) + '/' + image;
                        }
                        
                        core.getImage(image, function(img) 
                        {
                            if (img.width  >= o.minWidth  && 
                                img.height >= o.minHeight && core.preview) {

                                o.addImage(img);
                                
                                if(!o.multipleImages) {
                                    return;
                                }
                                
                            }
                        });
                    }

                };
                
                core.getImage = function(src, callback)
                {
                    var concat  =  $.urlHelper.hasParam(src) ? "&" : "?";
                    src        +=  concat + 'random=' + (new Date()).getTime();
                    
                    $('<img />').attr({'src': src}).load(function() 
                    {
                        var img = this;
                        var tmrLoaded = window.setInterval(function()
                        {   
                            core.processedImg++;
                            if (img.width) {
                                window.clearInterval(tmrLoaded);  
                                callback(img);
                            }
                            if(core.processedImg == preview.images.length){
                                o.imgLoadEnd();
                            }
                        }, 100);
                    });
                };

                core.init();
                
                self.on('keyup', function(e) 
                {
                    var links = $.urlHelper.getLinks($(self).val());                    
                    core.cleanDuplicates(links);
                    
                    window.clearInterval(core.textTimer); 
                    
                    var code = (e.keyCode ? e.keyCode : e.which);
                    
                    if(code == 13 || code == 32) { //Enter keycode
                        core.textUpdate(that);
                    } else {
                        core.textTimer = window.setInterval(function()
                        {   
                            core.textUpdate(that);
                            window.clearInterval(core.textTimer);  
                        }, 1000);
                    }
                }).on('paste', function() {core.textUpdate(that)});
    
            });
        }
    });

    jQuery.yql = function yql(query, error, success) 
    {
        var yql = {
            path: '/test/scrap.jsp?URL=',
            query: encodeURIComponent(query)
        };
        
        var isIE = /msie/.test(navigator.userAgent.toLowerCase());
        
        if (isIE && window.XDomainRequest) {
            var xdr = new XDomainRequest();
            xdr.open("get", yql['path'] + yql['query'], true);
            xdr.onload = function() 
            {
                success(jQuery.parseJSON(xdr.responseText));
            };
            
            xdr.send();
         
        } else {

            $.ajax({
                crossDomain : true,
                cache    : false,
                type     : 'GET',
                url      : yql['path'] + yql['query'], 
                timeout  : 20000, 
                dataType : 'json',
                error    : error,
                success  : success
            });   
        }
    };
    
    jQuery.urlHelper =
    {
        UriParser :  function (uri)
        { 
            this._regExp      = /^((\w+):\/\/\/?)?((\w+):?(\w+)?@)?([^\/\?:]+)?(:\d+)?(.*)?/;
            this._regExpHost  = /^(.+\.)?(.+\..+)$/;
   
            this._getVal = function(r, i) 
            {
                if(!r) return null;
                return (typeof(r[i]) == 'undefined' ? "" : r[i]);
            };
          
            this.parse = function(uri) 
            {
                var r          = this._regExp.exec(uri);
                this.results   = r;
                this.url       = this._getVal(r,1);
                this.protocol  = this._getVal(r,2);
                this.username  = this._getVal(r,4);
                this.password  = this._getVal(r,5);
                this.domain    = this._getVal(r,6);
                this.port      = this._getVal(r,7);
                this.path      = this._getVal(r,8);
                
                var rH         = this._regExpHost.exec( this.domain );
                this.subdomain = this._getVal(rH,1);
                this.domain    = this._getVal(rH,2); 
                return r;
            }
              
            if(uri) this.parse(uri);
        },
        getLinks : function(text) 
        {
            var expression = /((https?:\/\/)?[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?)/gi;
            return (text.match(expression));
        },
        isImage : function(img, allowed)
        {
            //Match jpg, gif or png image  
            if (allowed == null)  allowed = 'jpg|gif|png|jpeg';
            
            var expression = /([^\s]+(?=\.(jpg|gif|png|jpeg))\.\2)/gm; 
            return (img.match(expression));
        },
        isAbsolute : function(path)
        {
            var expression = /^(https?:)?\/\//i;
            var value =  (path.match(expression) != null) ? true: false;
            
                            
            return value;
        },
        isPathAbsolute : function(path)
        {
            if (path.substr(0,1) == '/') return true;
        },
        hasParam : function(path)
        {
             return (path.lastIndexOf('?') == -1 ) ? false : true;
        },
        stripFile : function(path) {
            return path.substr(0, path.lastIndexOf('/') + 1);
        } 
    }
})( jQuery );