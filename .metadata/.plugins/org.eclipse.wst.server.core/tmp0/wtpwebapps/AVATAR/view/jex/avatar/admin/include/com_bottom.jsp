<%@ page language="java" pageEncoding="UTF-8"%>
<script type="text/javascript">
var __f=Array.prototype;
if(!__f.forEach) {
    __f.forEach=function(f,g){
        var e,b=Object(this),a=b.length>>>0,c=0;
        if(!f||!f.call)throw new TypeError;
        for(g&&(e=g);c<a;){
            var d=String(c);
            b.hasOwnProperty(d)&&(d=b[d],f.call(e,d,c,b));c++
        }
    };
}

var jsConfig = {
    isMobile:false,
    minWidth:1000,
    url : '/admin/menu/menu.xml?20170920'
};

$(document).ready(function() {
    try {
        // 로딩바
        jex.setAjaxBeforeData(fintech.common.setNowLoding);
        jex.setAjaxCompleteData(fintech.common.removeLoding);

        // 데이터 로드 후 처리할 함수 설정
        $('body').gnbReady(setGNB);

        // GNB 데이터 로드
        getMenuData(function() {
            $.gnbReady.forEach(function(f) {
                f();
            });

            $.gnbReady = null;
            delete $.gnbReady;
            if (typeof __fn_init() == 'function') { 
            	__fn_init();  
           	}
        });

        $(document).on("click", ".menu_class", function() {
        	var html = "";
            var id = $(this).attr("data-package");
            var param = $(this).attr("data-param");
           	
            $("#frmMenuMove").remove();
            html +='<form  method="post" id="frmMenuMove">';
            html +='<input type="text" name="BLBD_DIV" value="'+param+'"/>';
            html +='</form>';
            $("body").append(html);
            $("#frmMenuMove").attr("action",id+".act");
            $("#frmMenuMove").submit();
        });
    } catch(e){
        
    };
/*
    $("input,textarea").live("click",function(){
        $(this).focus();
    });
*/
    initializeHtmlPage();

//     $.fintechSession({isAjax : true});
});

/**
 * GNB 설정(GNB 데이터를 GNB 마크업으로 파싱)
 */
function setGNB() {
    var $gnb = $('#leftMenu');
    var url  = location.href;
    var page = "";
    url = url.substring(url.indexOf("_")+1);
    url = url.substring(0, url.indexOf("_"));

    for(var idx=0; idx<url.length; idx++) {
        if( isNaN(String(url.charAt(idx))) ) {
            page += url.charAt(idx);
        } else {
            break;
        }
    }
    
   // page = "serpcmsadmin";
    page = $gnb.attr("data-SERP_MENU_ID");
    var $tag     = jsConfig.$gnbData.clone().find("#" + page);
    var $last    = $('#leftMenu :focusable:last');
    var limit;

    if ($gnb.length == 0) return;

    if(url != null && url != undefined && url != "") {
        jsConfig.pagecode = location.href;
        jsConfig.pagecode = jsConfig.pagecode.substring(jsConfig.pagecode.lastIndexOf("/")+1, jsConfig.pagecode.lastIndexOf("."));

        var parentTag = "li";
        var pageCode = jsConfig.pagecode.substring(0, jsConfig.pagecode.lastIndexOf("_")) + "_01";
        
        var frontCd = jsConfig.pagecode.substring(0, jsConfig.pagecode.lastIndexOf("_"))
        if(frontCd == "cust_0001"){
        	pageCode = jsConfig.pagecode.substring(0, jsConfig.pagecode.lastIndexOf("_")) + "_00";
        }
         
        /*
        if($tag.find("li").length == 0) {
            parentTag = "div";
        }
        */
        
        if($tag.find("#"+pageCode).parent().prop("tagName") == "DIV") {
            parentTag = "div";
        }
        
        $tag.find(parentTag).removeClass("on");    
        var $currentObj = $tag.find('#' + pageCode);
        if($currentObj.length == 0) {
            $currentObj = $tag.find("[data-package='"+pageCode+"']");
        }
        
        var $parentObj = $currentObj.parents(parentTag);
        //$parentObj.addClass("on");
    }
	
    $gnb.html($tag).show();

//     if($("div:first").attr("class") == "wrap") {
//         var html = "";
//         html += "<div class=\"top_logo_wrap\">";
//         html += "    <h1><img src=\"/img/logo_fintech.gif\" alt=\"Fintech\"></h1>";
//         html += "    <h2 id=\"topMenuTitle\">"+$("#"+page).attr("title")+"&nbsp;&nbsp;&nbsp;<span style='color:#ff6666;' id='logoutTimeTop'>&nbsp;</span></h2>";
//         html += "</div>";
//         $("div:first").prepend(html);
//     }
}

/**
 * menu.xml을 로드하는 함수
 */
function getMenuData(callback) {
    $.ajax({
        url : jsConfig.url,
        dataType : 'text',
        success : function(data) {
            var $data = $(data.replace(/<\?[\s\S]*\?>\s*/, ''));
            jsConfig.$gnbData = $data;
            if (typeof callback == 'function') callback();
        }
    });
}

/**
 * GNB 데이터 처리
 * @param $
 */
(function($) {
    // GNB 데이터 로드 후 콜백함수 호출 플러그인
    $.gnbReady = [];
    $.fn.gnbReady = function() {
        var bln = $.gnbReady instanceof Array;
        for (var i=0, len=arguments.length; i<len; i++) {
            if (bln) $.gnbReady.push(arguments[i]);
            else arguments[i]();
        }
    };
})(jQuery);
/**
 * 세션 타임아웃처리
 */
var _SESSION_TIME_      = 600;
var sessionTimedefaults = {sessionTime : _SESSION_TIME_, alertTime : 60, captureMin : 0, captureSec : 0, tid : null};

(function($) {
    //var _SESSION_TIME_ = 600;
    var fintechSession = function(options) {
        this.options = {};
        this.options = options;
    }
    fintechSession.prototype = {
        init : function(isAjax) {
            var self = this;
            self.config = $.extend({}, sessionTimedefaults, self.options);
            if(isAjax) {
                sessionTimedefaults.tid = setInterval($.proxy(self.showTime, self), 1000);
            } else {
                sessionTimedefaults.sessionTime = _SESSION_TIME_; 
            }
        },
        drawAlertLayer : function() {
            $(".__timerPop").show();
            this.layerEventHandle();
        },
        layerEventHandle : function() {
            var self = this;
            
            var $TimeExtend = $("#activityLogin");
            $TimeExtend.off("click");
            $TimeExtend.on("click", function(e) {
                self.extend(e);
            });
        },
        extend : function(e) {
            var self = this;
            if(e) {
                e.preventDefault();
                e.stopPropagation();    
            }

            var jexAjax = jex.createAjaxUtil('com_0001_01_r001');
            jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부

            jexAjax.execute(function(dat) {
                sessionTimedefaults.sessionTime = _SESSION_TIME_;
                $(".__timerPop").hide();
            });
        },
        showTime : function() {
            sessionTimedefaults.captureMin = Math.floor(sessionTimedefaults.sessionTime / 60);
            sessionTimedefaults.captureSec = sessionTimedefaults.sessionTime % 60;
            
            if(sessionTimedefaults.captureMin < 10) {
                sessionTimedefaults.captureMin = "0" + sessionTimedefaults.captureMin;
            }
            if(sessionTimedefaults.captureSec < 10) {
                sessionTimedefaults.captureSec = "0" + sessionTimedefaults.captureSec;
            }
            
            $("#logoutTime").html(sessionTimedefaults.captureMin + ":" + sessionTimedefaults.captureSec);
            $("#logoutTimeTop").html(sessionTimedefaults.captureMin + ":" + sessionTimedefaults.captureSec);
            if(sessionTimedefaults.sessionTime == sessionTimedefaults.alertTime) {
                this.drawAlertLayer();
            } else if(sessionTimedefaults.sessionTime == 0) {
                sessionTimedefaults.tid = null;
                $("body").append("<form id=\"logoutForm\" name=\"logoutForm\" method=\"post\"><input type=\"hidden\" name=\"code\" id=\"code\" value=\"SES001\"><input type=\"hidden\" name=\"msg\" id=\"msg\" value=\"해당컨텐츠의 세션이 종료되었습니다.\"></form>");
                fintech.common.submit($("#logoutForm"), "error.act");
            }
            sessionTimedefaults.sessionTime--;
        }
    };

    fintechSession.defaults = fintechSession.prototype.defaults;
    $.fintechSession = function(options) {
        var sessionTime = new fintechSession(options);
        sessionTime.init(options.isAjax);
        return sessionTime;
    };
})(jQuery);
</script>

<div class="__timerPop" id='mask'
	style='z-index: 99999999; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: #000; filter: alpha(opacity = 70); -khtml-opacity: 0.7; -moz-opacity: 0.7; opacity: 0.7; display: none;'></div>
<div class="__timerPop" id='mask_content'
	style='z-index: 999999999; position: absolute; top: 30%; left: 50%; width: 400px; height: 260px; padding: 0; margin: 0 0 0 -200px; display: none;'>
	<dl>
		<dt
			style='height: 31px; padding: 16px 0 0 90px; font-size: 14px; color: #555; font-weight: bold; background: url(/img/bg/bg_pop_logout_wrap_top.png) no-repeat;'>
			자동로그아웃까지 <span style='font-size: 16px; color: #ff6666;'
				id='logoutTime'>&nbsp;</span> 초 남았습니다.
		</dt>
		<dd
			style='padding: 26px 0 30px 0; text-align: center; font-size: 12px; color: #555; line-height: 18px; background: url(/img/bg/bg_pop_logout_wrap_cont.png) no-repeat;'>
			<strong style='font-size: 20px; color: #333;'>자동로그아웃 안내</strong>
			<p style='padding: 20px 0 35px 0;'>
				고객님의 안전한 서비스 이용을 위해 <strong style='color: #ff6666;'
					id='activityTime'></strong><br> 서비스 이용이 없어 자동 로그아웃 됩니다.<br>
				계속 이용하시려면 <strong style='color: #ff6666;'>[계속사용하기]</strong> 버튼을
				클릭하세요.
			</p>
			<a href='javascript:void(0);'
				style='display: inline-block; width: 116px; height: 31px; line-height: 31px; font-size: 12px; text-decoration: none; text-align: center; color: #fff !important; font-weight: bold; background: url(/img/btn/btn_logout_ok2.gif) no-repeat;'
				id='activityLogin'>계속사용하기</a>
		</dd>
	</dl>
</div>