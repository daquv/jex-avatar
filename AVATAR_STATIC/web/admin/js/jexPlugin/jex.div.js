jQuery.fn.extend({
	jexDiv: function(cmd, opt) {
		var $r = $(this);
		var jexDivFn={
				make:function(opt) {
					var dfltOpt = {
									closable		:true,
									draggalbe		:true,
									handle			:"#p-title",
									closebtn		:"#close",
									speed			:200,
									staticP			:true,
									show			:false,
									zindex			:1000,
									align			:"O",
									x				:0,
									y				:0,
									blur			:true,
									bgindex			:999,
									closeOthers		:true,
									closeOthers2	:false,
									toogle			:true,
									nohide			:false,
									blurpostionX	:0,
									blurpostionY	:0,
									onClose		:function(){},
									opacity			:30,
									doccontainer	:"container",
									popupBtn		:"#popup",
									width			:undefined,
									height			:undefined,
									title			:undefined,
									ifrcontents		:"",
									esckey			:true,
									reloadable		:false,
									url				:undefined};
					
					if (opt!=null&&opt!=undefined) $.each(opt, function(i,v) { dfltOpt[i] = v; });
					opt = dfltOpt;
					
					/*if ($r.data("isMakedDiv"))	return;
					else						*/$r.data("isMakedDiv", true);
					
					
					if ($r.length==0) {
						if (!$r.selector.startsWith("#")) throw Error("id attribute검색만 지원");
						var $div = $("<div id='"+$r.selector.substring(1,$r.selector.length)+"' style='width:"+opt.width+"px;height:"+opt.height+"px;'></div>");
						$div.appendTo(document.body);
						$div.html(opt.ifrcontents);
						$r = $div;
						if (opt.title!=undefined) $r.find("#title").html(opt.title);
						$r.find("iframe").css("height",opt.height+"px");
						$r.find("iframe").attr("src", opt.url);
					}
					$r.data("opt",dfltOpt);
					
					if (dfltOpt.draggalbe) {
						var ddopt = {};
						if (dfltOpt.handle!=null) {
							ddopt = {
										 handle:dfltOpt.handle
										,start:function() {
											$r.find("iframe").hide();
										},stop:function() {
											$r.find("iframe").show();
										}
									};
						    $r.find(dfltOpt.handle).css("cursor", "move");
						    if (dfltOpt.closable)  $r.find(dfltOpt.handle).dblclick(function() { jexDivFn['hide'](opt); });
						}
//						ddopt['containment']='parent';
						ddopt.cancel = ".ui-cancelDraggable,input,option";
						$r.draggable(ddopt);
					}
					
					$r.css("z-index",dfltOpt.zindex);
					$r.css("left",   dfltOpt.x+"px");
				    $r.css("top",	 dfltOpt.y+"px");
					$r.css("z-index",$r.data("opt").zindex);
					
			
					$r.find(dfltOpt.closebtn).click(function() { jexDivFn['hide'](opt); });
					$r.find(dfltOpt.popupBtn).click(function() { 
						$r.jexDiv('hide');
						var x = $r.offset().left;
						var y = $r.offset().top;
						win = window.open($r.find("iframe").attr("src"),$r.attr("id"),'top='+x+', left='+y+', width='+opt.width+', height='+opt.height+', toolbar=0, directories=0, status=0, menubar=0, scrollbars=0, resizable=1');
						win.moveTo(x,y);
					});
					
					if (dfltOpt.closeable) {
						$r.keypress(function(event){
							switch (event.keyCode) {
								case 27:
								case 32:
								case 13:
									jexDivFn['hide'](opt);
								break;
							};
							switch (event.charCode) {
								case 27:
								case 32:
								case 13:
									jexDivFn['hide'](opt);
								break;
							};
						});
					};
					
					if (dfltOpt.esckey) {
					jex.printDebug(" ESC KEY CODE :: " + dfltOpt.esckey);
						$r.keydown(function(evt){
							jex.printDebug(" KEY CODE :: "+charCode);
							var charCode = (evt.which) ? evt.which : window.event.keyCode;
							if (charCode==27) $r.jexDiv('hide');
						});
					}
					
					if (!opt.show) {
						jexDivFn['hide'](opt);
					} else {
						if (opt.init!=null) jexDivFn['show']($("#"+opt.init));
						else jexDivFn['show'](opt);
					}
        		},
				onClose:function(fn) {
					$r.data("opt")['onClose'] = fn;
				},
				changeIfrSrc:function(opt) {
					/**
					 * IFRAME이 존재하는경우에만 사용가능
					 */
					$r.find("iframe:first").attr("src",opt['src']);
				},
				show:function(opt) {
					if (!opt) opt = {};
					if ($r.data("opt").reloadable||opt.reloadable)  {
						var url = (opt.url)?opt.url:$r.data("opt").url;
        		    	$r.find("iframe").attr("src", url);
        		    }
					
					if ($r.data("opt").toogle) {
						if ($r.data("isShow"))	jexDivFn['hide'](opt);
						else 					showFn(opt);
					}
					else showFn(opt);
        		},
        		hide:function(opt) {
        			$r.hide();
        			$("#_jex_div_bg").hide();
        		    $r.data("isShow",false);
        		},
        		isOpen:function(opt) {
        			return $r.data("isShow");
        		}
		};
		function showFn(opt) {
			if ($r.data("opt").staticP) {
		    	var x;
	 		    var y;
	 		    if (opt==null&&opt==undefined) {
	 		    	var x = $r.data("opt").x;
		 		    var y = $r.data("opt").y;
	 		    } else if ((opt!=null||opt!=undefined)&&opt.offset!=undefined) {
	 		    	var al=0;
		 		    var at=0;
		 		    if($r.data("opt").align=="L") al=-opt.width();
		 		    if($r.data("opt").align=="R") al=opt.width();
		 		    if($r.data("opt").align=="T") at=-opt.width();
		 		    if($r.data("opt").align=="B") at=opt.width();
		 		    var x = opt.offset().left  + $r.data("opt").x + (al);
		 		    var y = opt.offset().top   + $r.data("opt").y + (at); 		    	
				} else 	if (opt.pageX!=undefined&&opt.pageY!=undefined) {
				   var x = opt.pageX;
		 		   var y = opt.pageY-10;
				} else {
	 		    	var x = $r.data("opt").x;
		 		    var y = $r.data("opt").y;
				}
				$r.css("position",	"absolute");
				$r.css("left",		x+"px");
				$r.css("top",		y+"px");
			}
			if ($r.data("opt").blur) {
				$r.css("z-index",$r.data("opt").bgindex);
				if ($("#_jex_div_bg").length==0) {
					var opacity = $r.data("opt").opacity;
					var opacity2= $r.data("opt").opacity/100;
					var height = $(document.body).height()-$r.data("opt").blurpostionY+"px";
					if (height==undefined || height=="0px") height="100%";
					height = Math.max(Math.max(document.body.scrollHeight,    document.documentElement.scrollHeight), Math.max(document.body.offsetHeight, document.documentElement.offsetHeight), Math.max(document.body.clientHeight, document.documentElement.clientHeight))+"px";
					var styleStr= "position:absolute;left:"+$r.data("opt").blurpostionX+"px;top:"+$r.data("opt").blurpostionY+"px;width:100%;height:"+height+";background-color:#000000;FILTER:filter: alpha(opacity="+opacity+"); -khtml-opacity: "+opacity2+"; -moz-opacity:"+opacity2+"; opacity: "+opacity2+";z-index:"+$r.data("opt").bgindex+"'";
					$bg = $("<div id='_jex_div_bg' style='"+styleStr+"'></div>");
					$bg.appendTo($(document.body));
					//$r.css("z-index",$r.data("opt").zindex);
					$r.css("z-index","2000000");
				} else {
					$("#_jex_div_bg").css("left",$r.data("opt").blurpostionX+"px");
					$("#_jex_div_bg").css("top",$r.data("opt").blurpostionY+"px");
					var height = $(document.body).height()-$r.data("opt").blurpostionY+"px";
					if (height==undefined || height=="0px") height="100%";
					height = Math.max(Math.max(document.body.scrollHeight,    document.documentElement.scrollHeight), Math.max(document.body.offsetHeight, document.documentElement.offsetHeight), Math.max(document.body.clientHeight, document.documentElement.clientHeight))+"px";
					$("#_jex_div_bg").css("height",height);
					$("#_jex_div_bg").show();
					$r.css("z-index",$r.data("opt").zindex);
				}
			}
			if ($r.data("opt").closeOthers) {
				try {
					$.each($("["+_jextype+"=div]"),function() {
						var sinit = {};
						eval("sinit = "+$(this).attr(_jexinit));
					});
				} catch (e) {
					;
				}
			}
			$r.fadeIn($r.data("opt").speed, function() {
				$r.data("isShow",true);
				if (!jex.isNull(opt)&&typeof(opt.fn)=="function") opt['fn']();
			});
		};
		return jexDivFn[cmd](opt);
    }
});


