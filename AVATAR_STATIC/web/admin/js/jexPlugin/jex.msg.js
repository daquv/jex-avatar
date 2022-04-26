(function() {
	/**
	 * Message 정의
	 */
	var _JexMessage = JexMsg.extend({
		init:function() {
			/**
			 * Page가 로드되기전에 init이 실행되므로 잘 고민하고 코딩해야 한다.
			 */
			this._super();
			this.obj 			= $("#"+jex.getMsgId());
			this.tblSize		= 5;
			this.view_data_min	= 1;
			this.view_data_max	= 19;
			this.bufferSize		= 50;
			this.head			= [ {'ID':'MSG',	'NAME':'메시지','width':'100%',	'style':'text-align:center;'} ];
			this.dat 			= [];
			this.table;
			this.thead;
			this.tbody;
			this.width			= "99%";
			this.height 		= 1000;
			this.msgTime		= 5000;
		
			this.root_css = {
				 "width"			: "80%"
				,"min-width"		: "360px"
				,"max-width"		: "800px"
				,"min-height"		: "50px"
				,"z-index"			: "32000"
				,"border"			: "1px solid #555555"
				,"background-color"	: "#FFFFFF"
			};
			this.header_css = {
				 "border"			: "1px solid #FFFFFF"
				,"height"			: "8px"
				,"background-image"	: " url(/img/00/greentype/bg_titbg.gif)"
			};
			this.body_css = {
				 "width"			: "85%"
				,"float"			: "left"
				,"padding"			: "10px 10px 10px 15px"
			};
			this.close_css = {
				 "width"			: "20px"
				,"float"			: "right"
				,"padding"			: "8px 0px 7px 0px"
			};
			
			try {
				this.left		= 0;
				this.top		= $(window).height() - this.height+2;
			} catch(e) {
				this.left		= 1000;
				this.top		= 700;
			}
			if (this.obj.length==0) {
				/**
				 * Debug DIV에 TABLE을 만든다.
				 */
				this.obj	= $("<div></div>");
				this.table	= $("<table></table>");
				this.thead	= $("<thead><tr></tr></thead>");
				this.tbody	= $("<tbody></tbody>");
				
				this.obj.attr("id",		jex.getMsgId()	);
				this.setDivStyle();
				this.obj.show();
			
				this.table.appendTo(this.obj);
				this.tbody.appendTo(this.table);
				var r = this;
				$(window).scroll(function() { r.setPosition(); });
				$(window).resize(function() { r.setPosition(); });
			}
			/**
			 * 삭제하는 로직은 고민해보고 다시 구현하자.
			 */
		},addRemover:function() {
			var r		= this;
			setTimeout(function() {
				if (r.tbody.find("tr").length==0) return;
				r.tbody.find(">tr:last").remove();
				r.dat.shift();
				r.setPosition();
			},this.msgTime);
		},setPosition:function() {
			this.height = this.table.height();
			this.obj.css("height",this.height+"px");
			this.top		= $(window).height() - (this.height + 2) + $(window).scrollTop();
			this.obj.stop().animate({"top":this.top+"px"},1000);
		},setDivStyle:function() {
			this.divStyle	= {
					 "z-index"			:"32000"
					,"position"			:"absolute"
					,"overflow"			:"hidden"
					,"top"				:this.top	+"px"
					,"left"				:this.left	+"px"
					,"width"			:this.width
					,"height"			:this.height
			};		
			for (var v in this.divStyle) { this.obj.css(v, this.divStyle[v]); }
		},addMsg:function(m) {
			var r = this;
			if ($("#"+this.obj.attr("id")).length ==0) {
				this.obj.appendTo("body");
				this.setDivStyle();
				this.table.css("width","100%");
			}
			this.dat.push(m);
			if (this.dat.length > this.bufferSize) this.dat.shift();
			var tr = $("<tr align='center'></tr>");
			tr.prependTo(this.tbody);
			for (var i=0;i<this.head.length;i++) {

				var v = this.head[i];
				var td = $("<td align='center'><div></div></td>");
				var height;
				td.appendTo(tr);
				td.attr("id",		v['ID'	 ]);
				td.attr("style",	v['style']);
				
				var rdiv = td.find("div");																					// ROOT	Div
				var hdiv = $("<div></div>");																				// Body Div
				var bdiv = $("<div>"+m[v['ID']].replace(/\n/g, "<br />")+"</div>");																	// Header Div
				var cdiv = $("<div><img src='/demo/img/comm/bullet/x1.jpg' /></div>");											// Close Div
				
				hdiv.appendTo(rdiv);
				bdiv.appendTo(rdiv);
				cdiv.appendTo(rdiv);
				
				for (v in this.root_css) 	{ rdiv.css(v, this.root_css[v]); 	}		// RDIV 옛다 디자인이나 먹어라.
				for (v in this.header_css) 	{ hdiv.css(v, this.header_css[v]);	}		// HDIV 옛다 디자인이나 먹어라.
				for (v in this.body_css) 	{ bdiv.css(v, this.body_css[v]); 	}		// BDIV 옛다 디자인이나 먹어라.
				for (v in this.close_css) 	{ cdiv.css(v, this.close_css[v]); 	}		// CDIV 옛다 디자인이나 먹어라.
				
				if (v['ID']=="MSG") {
					td.css("cursor","pointer");
					td.dblclick(function(e) {
						var x = e.pageX - this.offsetLeft;
						var y = e.pageY - this.offsetTop;
						r.makeToolTip($(this).find("div").html(), x, y);
					});
				}
				rdiv.height((bdiv.height()+hdiv.height()+12)+"px");
				height = rdiv.height();
			//	td.height(height+"px");
			}
			tr.height(height+"px");
			if (this.tbody.find(">tr").length>this.tblSize) this.tbody.find(">tr:last").remove();
			this.addRemover();
			this.setPosition();
		},reDrawTbl:function(){
			var r = this;
			this.tbody.find("tr").remove();
			var idx = this.dat.length - this.tblSize;
			idx = (idx>0)?idx:0;
			for (var j=idx; j<this.dat.length; j++) {
				var m = this.dat[j];
				var tr = $("<tr></tr>");
				tr.prependTo(this.tbody);
				for (var i=0;i<this.head.length;i++) {
					var v = this.head[i];
					var td = $("<td><div></div></td>");
					td.appendTo(tr);
					td.attr("id",		v['ID'	 ]);
					td.attr("style",	v['style']);
//					td.find("div").attr("style","width:100%;height:15px;overflow:hidden;");
					td.find("div").html(m[v['ID']]);
					if (v['ID']=="MSG") {
						td.css("cursor","pointer");
						td.dblclick(function(e) {
							var x = e.pageX - this.offsetLeft;
							var y = e.pageY - this.offsetTop;
							r.makeToolTip($(this).find("div").html(), x, y);
						});
					}
				}
			}
		},makeToolTip:function(msg,l,t){
			if (jex.isNull(this.tooltipDiv)||this.tooltipDiv.length == 0) {
				this.tooltipDiv = $("<div id='_jexDebuggerTooltip'>"+msg+"</div>");
				this.tooltipDiv.appendTo("body");
				this.tooltipDivHeight = 200;
				this.tooltipDiv.attr("style","z-index:32768;background-color:#ffffff;position:absolute;min-height:"+this.tooltipDivHeight+"px;width:98%;top:"+(t-this.tooltipDivHeight)+"px;left;"+(l+this.tooltipDiv.width())+"px;border:1px solid #000000;");
				var r = this;
				this.tooltipDiv.dblclick(function() { r.tooltipDiv.hide(); });
			} else {
				this.tooltipDiv.html(msg);
				this.tooltipDiv.show();
			}
			
		},setHeader:function(h){
			this.head = h;
		},printInfo	:function(code,msg){
			var m = {};
			m['TYPE'] = "INFO";
			m['CODE'] = code;
//			m['MSG' ] = jex.getMsg(code) + "::" + jex.null2Void(msg);
			m['MSG' ] = this.makeMsg(arguments);
			this.addMsg(m);
		},printError:function(code,msg){
			/*var m = {};
			m['TYPE'] = "ERROR";
			m['CODE'] = code;
//			m['MSG' ] = jex.getMsg(code) + "::" + jex.null2Void(msg);
			m['MSG' ] = this.makeMsg(arguments);
			this.addMsg(m);*/
			if(typeof(code) == "object") {
				var code2 = code;
				
				code = code2['COMMON_HEAD']['CODE'];
				msg = code2['COMMON_HEAD']['MESSAGE'];
			}
			
			if(code.indexOf("SESSION_DISCONNECTED") > -1){
				var doc;                                               
				alert('세션이 종료되었습니다.');
				try{
					doc = window.parent;                               
					doc.selfClose();                                   
				}catch(e){
					self.close();                                      
				}
			}else{
				if(jex.isNull(msg)) {
					msg = "처리중 오류가 발생하였습니다.";
				}
				
				if(jex.isNull(code)){
					alert(msg);
				}else{
					alert("[" + code + "] " + msg);
				}
			}
			
		},makeMsg:function(arg){
//			var msg = jex.getMsg(arg[0]);
			var msg = arg[1];
			var mat = msg.split("%");
			
			for (var i=1; i<mat.length; i+=2) {
				jex.printDebug("i ::" + i);
				jex.printDebug("mat[i] " + mat[i]);
				jex.printDebug("arg[i] " + arg[(i-1)/2+1]);
				var regExp = new RegExp("%"+mat[i]+"%",'g');
				msg = msg.replace(regExp,arg[(i-1)/2+1]);
			}
	
			var msgAppend = (arg.length) - mat.length;
			msg = "<b>"+msg+"</b><br />";
			
			if (msgAppend>0) msg += "<br />";
			
			for (var i=0; i<msgAppend; i++) msg += jex.null2Void(arg[mat.length+i]);
			jex.printDebug("printMessage :: " + msg +"::" +msgAppend);
			return msg;
		}
	});
	jex.setMsgObj(new _JexMessage());	
})();
$(function() {
	jex.setMsgObj(jex.getRootDom().jex.getMsgObj());
});