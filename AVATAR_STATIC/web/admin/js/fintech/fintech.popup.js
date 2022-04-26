(function($) {
    // 레이어
    $.fn.modalCon = function(options) {
    	// 세션체크 처리
    	if (this[15] != undefined) {
    		if (this[15].id == "errorWrap") {
        		$("body").append("<form id=\"logoutForm\" name=\"logoutForm\" method=\"post\"><input type=\"hidden\" name=\"code\" id=\"code\" value=\"SES001\"><input type=\"hidden\" name=\"msg\" id=\"msg\" value=\"해당컨텐츠의 세션이 종료되었습니다.\"></form>");
    			fintech.common.submit($("#logoutForm"), "error.act");	
    		}
    	}
    	// 바닥 popup content container 숨김
		$('.includePopupWrap').children(":not(.includePopup)").each(function() {
			$(this).addClass("includePopup");
		});

		var thisObj = this;
        return this.each(function(n) {
            options = options || {};
            var opts        = $.extend({}, $.fn.modalCon.defaults, options || {});
            var $cont       = $(this);                                             // 이벤트호출객체 a
            var $contWrap;                                                         // 레이어컨텐츠
            var $contCon;                                                          // 레이어컨텐츠내부 컨텐츠영역
            var contWrapID  = "modalContent";                                      // 레이어 아이디
            var data        = opts.data;
            var url         = opts.url;
            var obj         = $cont;
            var autoLoad    = opts.autoLoad;
            var layerScroll = null;
            var oldScroll   = null;
            var openObj     = $cont;

            if (autoLoad){
                if (opts.owner) obj = opts.owner;
                $contWrap = $('<div>').addClass(opts.onClass).appendTo('body');
                $contWrap.attr('id', contWrapID);
                $($contWrap).empty();
                $($contWrap).html(thisObj);

                setModalCon();

                if (typeof opts.callbackBefore === 'function') {
                    opts.callbackBefore();
                };
                return false;
            }
            $cont.unbind('click.modalCon').bind('click.modalCon', function(ev) {
                ev.preventDefault();
                if ($(this).is('.disabled') || $(this).prop('disabled')) return false;
                if ( $cont.hasClass("modalDisabled") ) {
                    if ( typeof(opts.callbackDisabled) == "function" ) opts.callbackDisabled();
                    return false;
                }
                if (url == false && data == false) return;

                $contWrap = $('<div>').addClass(opts.onClass).appendTo('body');
                $contWrap.attr('id', contWrapID);

                /* 이벤트 및 애니메이션 설정함수 호출(ajax컨텐츠일경우 data-target속성에 컨텐츠 출력됨) */
                if (url) {
                    ajaxCall(url, opts.ajaxOption, $contWrap, function() {
                        setModalCon();

                        // id 가 아닌 url로 올때 contWrapID 찾는 방법 추가 필요
                        if (typeof opts.callbackBefore === 'function') {
                            opts.callbackBefore();
                        };
                    });
                }

                if (data) {
                    $contWrap.html(data);
                    setModalCon();

                    if (typeof opts.callbackBefore === 'function') {
                        opts.callbackBefore();
                    };
                }
            });

            // 03. 레이어오픈 : 이벤트 및 애니메이션 설정
            function setModalCon() {
                $contCon = $contWrap.find(opts.layerWrap);

                var browser_width  = $(window).width();
                var browser_height = $(window).height();
                var layer_width    = $contCon.outerWidth();
                var layer_height   = $contCon.outerHeight();
                var margin_top     = Math.floor(layer_height /2) * (-1) + 'px';
                var margin_left    = Math.floor(layer_width /2) * (-1) + 'px';
                var position_left  = "50%";
                var position_top   = $(window).scrollTop() + ((browser_height-layer_height)/2);
                var $focusable;
                var $scrollCon     = $contCon.find(">.cont>.toggleView>.scrollContent");
                var $closeBtn      = $contWrap.find(".btnClose");

                // 오버레이의 zindex 체크
                var overLayZindex = 1995;

                // 모달출력
                if (opts.modal) {
                    $contWrap.before($("<div>").addClass(opts.modalClass));
                    $("."+opts.modalClass).css({'width' : browser_width, 'height' : browser_height});

                    // 맨 마지막에 생성된 오버레이의 zindex+1 값을 오버레이 값으로 지정함.(최초의 오버레이는 1996이 됨)
                    overLayZindex = $("."+opts.modalClass).eq($("."+opts.modalClass).length-1).css('z-index');
                    $("."+opts.modalClass).eq($("."+opts.modalClass).length-1).css('z-index', overLayZindex+1);
                }

                // 레이어팝업형태로 추가될경우 위치재설정
                if(browser_height<=layer_height) position_top = 0;
                var margin_left = (-1)*(layer_width/2);

                $contCon.css({
                    "left" : position_left,
                    "top" : position_top,
                    "marginLeft" : margin_left+"px",
                    "z-index" : (overLayZindex+1)
                });
                
                // 닫기버튼 이벤트설정
                $contWrap.find(opts.close_trigger).unbind("click").bind("click", function() {
                    callModalClose();
                    obj.focus();
                    return false;
                });
                // 최초 컨테이너에 포커스 처리한 상태에서 shift + tab 은 닫기버튼으로 포커스 처리
                $contCon.attr("tabindex","0").unbind("keydown.modalCon").bind("keydown.modalCon", function(e) {
                    if(e.keyCode == 9) {
                        $(this).unbind("keydown.modalCon");
                        if (e.shiftKey) {
                            $closeBtn.focus();
                            return false;
                        }
                    }
                }).unbind('focusout.modalCon').bind('focusout.modalCon', function(e) {
                    $(this).unbind('focusout.modalCon').attr('tabindex', null);
                });

                $(opts.close_trigger).focus();

                /**
                 * 팝업내 탭처리를 속도저하로 인해 막음 cgfamily 2015-10-14
                 * */
                /*
                $focusable = $contWrap.find(":focusable");
                // ascript(2013.08.05) - modalCon 포커스 순환 처리
                var scrollMode;
                $contWrap.off('keydown.modalCon', ':focusable').on('keydown.modalCon', ":focusable", function(e) {
                    e.stopPropagation();
                    if (this == $contWrap.find(':focus')[0] && e.keyCode == 9) {
                        var scrollAble = $scrollCon.is('.jspScrollable');
                        var checkMode = scrollMode != scrollAble;
                        if (checkMode) scrollMode = scrollAble;
                        if (scrollAble) {
                            $scrollCon.attr('tabindex', '0');
                        } else {
                            $scrollCon.attr('tabindex', null);
                        }

                        if (!$focusable.filter(this).length || !$focusable.eq(0).is(':focusable') || !$focusable.eq($focusable.length - 1).is(':focusable') || checkMode) {
                            $focusable = $contWrap.find(":focusable");
                        }
                        var $first = $focusable.eq(0);
                        var $last = $focusable.eq($focusable.length - 1);
                        if (e.shiftKey && (this == $first[0] || ($(this).attr('name') && $(this).attr('name') === $first.attr('name')) )) {
                            //console.log('마지막으로', $last);
                            $last.focus();
                            return false;
                        } else if (!e.shiftKey && this == $last[0]) {
                            //console.log('처음으로', $first);
                            if ($first.is('input:radio')) {
                                var $checked = $contWrap.find('[name=' + $first.attr('name') + ']:checked');
                                if ($checked.length) $contWrap.find('[name=' + $first.attr('name') + ']:checked').focus();
                                else $first.focus();
                            } else {
                                $first.focus();
                            }
                            return false;
                        }
                    }
                })
                .off('mousedown.modalCon', ':focusable').on('mousedown.modalCon', ':focusable', function(e) {
                    $scrollCon.attr('tabindex', null);
                });
                */

                // esc key layer hide event binding
                $contCon.on("keydown",function(e){
                    if(e.keyCode == 27){
                        callModalClose();
                        obj.focus();
                        return false;
                    }
                });

				$contWrap.find('.cont > .toggleView').addClass('skipToggle');
            }

            /* 04. 레이어닫기 */
            function callModalClose(){
            	// 시간연장 팝업 및 공통오류 팝업인 경우(개별 페이지에 includePopupWrap를 별도로 코딩한 경우가 있어 인덱스 처리 추가함)
                if(openObj.attr("id") == "HC_COMMON_LOGOUT_LAYER" || openObj.attr("id") == "HC_COMMON_ERROR_LAYER") {
                    $(".includePopupWrap").eq(0).append($contWrap.find(".includePopup"));
                    $contWrap.remove();
                // 이외의 경우
                } else {
                    $(".includePopupWrap").eq($(".includePopupWrap").length-1).append($contWrap.find(".includePopup"));
                    $contWrap.remove();
                }
                
                // 레이어 팝업이 이미 떠 있는 경우(이중 레이어)는 오버레이를 1개(시간연장팝업시 뜬 오버레이)만 제거
                if($("."+opts.modalClass) != null && $("."+opts.modalClass) != undefined && $("."+opts.modalClass).length > 0) {
                    $("."+opts.modalClass).eq($("."+opts.modalClass).length-1).remove();
                }

                if (typeof opts.callbackAfter === 'function') {
                    opts.callbackAfter();
                };
            }
        });
    };

    $.fn.modalCon.defaults = {
        modal            : true,
        modalClass       : "modalOverlay",
        onClass          : "wrapLayerOn",
        layerWrap        : ".pop_wrap",
        layerContent     : ".layerContent",
        close_trigger    : '.popupClose',
        url              : false,
        data             : false,
        callbackBefore   : function() {},
        callbackAfter    : function() {},
        callbackDisabled : null,
        autoLoad         : false
    };
})(jQuery);