var _fU_localeCode ="KO";

var COMMON_SCRIPT_00001  = "필수 입력 사항입니다.";
var COMMON_SCRIPT_00002  = "입력값을  % 사이로 입력해 주시기 바랍니다.";
var COMMON_SCRIPT_00003  = "입력을  % 자리로 해주십시오.";
var COMMON_SCRIPT_00004  = "[CapsLock]이 켜져 있습니다.";
var COMMON_SCRIPT_00005  = "정해진 최소값이 없습니다.";
var COMMON_SCRIPT_00006  = "정해진 최대값이 없습니다.";
var COMMON_SCRIPT_00007  = "숫자만 입력 가능합니다.";
var COMMON_SCRIPT_00008  = "한글만 입력 가능합니다.";
var COMMON_SCRIPT_00009  = "영어만 입력 가능합니다.";
var COMMON_SCRIPT_00010  = "한글,숫자만 입력 가능합니다.";
var COMMON_SCRIPT_00011  = "한글,영어만 입력 가능합니다.";
var COMMON_SCRIPT_00012  = "영어,숫자만 입력 가능합니다.";
var COMMON_SCRIPT_00013  = "한글,영어,숫자만 입력 가능합니다.";
var COMMON_SCRIPT_00014  = "한글은 입력 불가능합니다.";
var COMMON_SCRIPT_00015  = "- 만 입력 될수 없습니다.";
var COMMON_SCRIPT_00016  = "- 는  입력값 중 맨 앞에만 존재 하여야  합니다.";
var COMMON_SCRIPT_00017  = "소수점은 맨 앞이나 맨 뒤에  있을수 없습니다.";
var COMMON_SCRIPT_00018  = "소수점은 한개 이상 있을수 없습니다.";
var COMMON_SCRIPT_00019  = "숫자 , . , - 만 입력 가능합니다.";
var COMMON_SCRIPT_00020  = "새로고침 할 수 없는 페이지입니다.";

// 키보드 auto Focus 기능 제한
var IS_INT_AUTO_FOCUS       = false;
var FIRST_FOCUS_FIELD_ID    = "";

// 필수속성값 체크여부. 개발시 사용권고.
var CHK_NOTNUL_ATTRIBUTE    = false;

// IE여부
var IS_IE = false;
if( (navigator.appName == "Microsoft Internet Explorer") || (navigator.appName == "Netscape" && navigator.userAgent.indexOf("Trident") != -1 ) ) {
    IS_IE = true;
}

// 오페라브라우저 여부
var IS_OPERA = false;
if(navigator.appName.indexOf('Opera') > -1) {
    IS_OPERA = true;
}

var ENTFUNC = "";
/**
 * 최초 로딩시 페이지 초기 설정
 */
function initializeHtmlPage() {
    for(var i=0; i<document.forms.length; i++) {
        /*
        if(document.forms[i].autocomplete == undefined) {
            document.forms[i].autocomplete = "off";
        }
        */
        // 모든 페이지 autocomplete 방지
        document.forms[i].autocomplete = "off";

        document.forms[i].initialize = initializeHtmlForm;
        document.forms[i].initialize();
    }

    // 마우스 기능 제한(오른쪽 버튼 무시)
    var IS_INT_MOUSE = false;

    // 특수키 기능 제한(Ctrl + R, Ctrl + N, F5, Ctrl + V)
    var IS_INT_KEY = true;

    // 리얼서버가 아니면 마우스 제한 해제
    IS_INT_MOUSE    = false;
    IS_INT_KEY      = false;

    if(IS_INT_MOUSE) {
        document.oncontextmenu = function() {
            return false;
        };
        document.body.onselectstart = function(){return false;};
    }

    if(IS_INT_KEY) {
        if(document.body) {
            document.body.onkeydown = processKey;
        }
    }
}

/**
 * 특수키 기능을 제한하는 함수. (Ctrl + R, Ctrl + N, F5, Ctrl + V)
 *  Ctrl + V 허용  || event.keyCode == 86
 */
function processKey(event) {
    event = checkEvent(event);

    if((event.ctrlKey == true && (event.which == 78 || event.which == 82)) || (event.which >= 112 && event.which <= 123)) {
        if(event.which == 116) {
            fvAlert(COMMON_SCRIPT_00020);

            if(IS_IE) {
                event.keyCode = 2;
                return false;
            }
        }

        event.which = 0;
        event.cancelBubble = true;
        returnValue(event);
    }
}

/**
 * event.returnValue 멀티브라우저처리
 */
 function returnValue(event) {
    event = checkEvent(event);

    if(IS_IE) {
        event.returnValue = false;
    } else {
        event.preventDefault();
    }
}


/**
 * keycode값 리턴
 * ex) getKeycode(event);
 * @param event : 이벤트 객체
 * @return : 멀티브라우저용 keycode값
 */
function getKeycode(event){
    var keycode = IS_IE ? event.keyCode : event.which;

    return keycode;
}


/**
 * 이벤트가 발생한 객체 리턴
 * ex) getEventElement(event);
 * @param event : 이벤트 객체
 * @return : 멀티브라우저용 이벤트가 발생한 객체
 */
function getEventElement(event) {
    var elem = IS_IE ? event.srcElement : event.target;

    return elem;
}


/**
 *  특정폼을 Initalize 시키는 함수
 */
function formInitalizer(frm) {
    frm.initialize = initializeHtmlForm;
    frm.initialize();
}

/**
 * <pre>
 * validation check 함수
 * </pre>
 * @param : validation 검사를 할 폼.
 * @return : boolean
 * @see
 */
function initValidationCheck(checkForm) {
    for(var i=0; i<checkForm.elements.length; i++) {
        // mask한 값에서 마스크 값 삭제
        // maskform, userfmt, chartype=money, chartype=floatmoney, chartype=fexmoney
        if((checkForm.elements[i].getAttribute("maskform") != null && checkForm.elements[i].getAttribute("maskform") != undefined && checkForm.elements[i].getAttribute("maskform") != "") || ( checkForm.elements[i].getAttribute("userfmt") != null && checkForm.elements[i].getAttribute("userfmt") != undefined && checkForm.elements[i].getAttribute("userfmt") != "") || checkForm.elements[i].getAttribute("chartype") == "money" || checkForm.elements[i].getAttribute("chartype") == "floatmoney" || checkForm.elements[i].getAttribute("chartype") == "fexmoney") {
            if(checkForm.elements[i].getAttribute("maskform") == "usermask") {
                checkForm.elements[i].value = unMaskEngNum(checkForm.elements[i].value); // 사용자 마스크 지우기 로직.
            } else if(checkForm.elements[i].getAttribute("chartype") == "floatmoney" || checkForm.elements[i].getAttribute("chartype") == "fexmoney") {
                checkForm.elements[i].value = getOnlyFloatNumberFormat(checkForm.elements[i].value);
            } else {
                checkForm.elements[i].value = getOnlyNumberFormat(checkForm.elements[i].value);
            }
        }

        // input 타입
        // if(checkForm.elements[i].tagName.toString().toLowerCase() == "input")
        if(checkForm.elements[i].nodeName.toString().toLowerCase() == "input") {
            // 필수 값 체크
            if(checkForm.elements[i].getAttribute("nullable") == "false") {
                // alert("title -> "+checkForm.elements[i].getAttribute("title"));
                if(checkForm.elements[i].type.toString().toLowerCase() == "text" || checkForm.elements[i].type.toString().toLowerCase() == "password") {
                    if(checkForm.elements[i].value == "") {
                        if(checkForm.elements[i].getAttribute("colname") != null && checkForm.elements[i].getAttribute("colname") != undefined && checkForm.elements[i].getAttribute("colname") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + COMMON_SCRIPT_00001, checkForm.elements[i].name);
                        } else if(checkForm.elements[i].getAttribute("title") != null && checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + COMMON_SCRIPT_00001, checkForm.elements[i].name);
                        } else {
                            fvAlert(COMMON_SCRIPT_00001, checkForm.elements[i].name);
                        }

                        return false;
                    }
                } else if(checkForm.elements[i].type.toString().toLowerCase() == "checkbox" || checkForm.elements[i].type.toString().toLowerCase() == "radio") {
                    var checkState   = false;
                    var elementArray = eval("checkForm."+checkForm.elements[i].name);

                    for(var ct=0; ct<elementArray.length; ct++) {
                        if(elementArray[ct].checked == true) {
                            //alert(elementArray[ct]);
                            checkState = true;
                            break;
                        }
                    }

                    if(checkState == false) {
                        if(checkForm.elements[i].getAttribute("colname") != null && checkForm.elements[i].getAttribute("colname") != undefined && checkForm.elements[i].getAttribute("colname") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + COMMON_SCRIPT_00001, checkForm.elements[i].name);
                        } else if(checkForm.elements[i].getAttribute("title") != null && checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + COMMON_SCRIPT_00001, checkForm.elements[i].name);
                        } else {
                            fvAlert(COMMON_SCRIPT_00001, checkForm.elements[i].name);
                        }

                        //checkForm.elements[i].focus();
                        return false;
                    }
                }
            }

            if(checkForm.elements[i].value != "") {
                // 최대값 체크
                if(checkForm.elements[i].getAttribute("maximum") != null && checkForm.elements[i].getAttribute("maximum") != undefined && checkForm.elements[i].getAttribute("maximum") != "") {
                    if(!validationMaximum(checkForm.elements[i].getAttribute("maximum"), checkForm.elements[i].value)) {
                        var errMsg = COMMON_SCRIPT_00002; // 입력값을  % 사이로 입력해 주시기 바랍니다.
                        // minimum까지 설정되어 있으면..
                        if(checkForm.elements[i].getAttribute("minimum") != null && checkForm.elements[i].getAttribute("minimum") != undefined && checkForm.elements[i].getAttribute("minimum") != "") {
                            // min, max 의 값이 동일하면  범위없이 값만 찍어준다
                            if(checkForm.elements[i].getAttribute("minimum") == checkForm.elements[i].getAttribute("maximum")) {
                                errMsg = errMsg.replace("%", changeIntMoneyType(checkForm.elements[i].getAttribute("maximum")));
                            } else {
                                errMsg = errMsg.replace("%", changeIntMoneyType(checkForm.elements[i].getAttribute("minimum")) + " ~ " + changeIntMoneyType(checkForm.elements[i].getAttribute("maximum")));
                            }
                        // maximum만 설정되어 있으면..
                        } else {
                            errMsg = errMsg.replace("%", " ~ " + changeIntMoneyType(checkForm.elements[i].getAttribute("maximum")));
                        }

                        //  최대값 체크
                        if(checkForm.elements[i].getAttribute("colname") != null && checkForm.elements[i].getAttribute("colname") != undefined && checkForm.elements[i].getAttribute("colname") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + errMsg, checkForm.elements[i].name);
                        } else if(checkForm.elements[i].getAttribute("title") != null && checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + errMsg, checkForm.elements[i].name);
                        } else {
                            fvAlert(errMsg, checkForm.elements[i].name);
                        }

                        checkForm.elements[i].select();
                        return false;
                    }
                }

                // 최소값 체크
                if(checkForm.elements[i].getAttribute("minimum") != null && checkForm.elements[i].getAttribute("minimum") != undefined && checkForm.elements[i].getAttribute("minimum") != "") {
                    if (!validationMinimum(checkForm.elements[i].getAttribute("minimum"), checkForm.elements[i].value)) {
                        var errMsg = COMMON_SCRIPT_00002;
                        // maximum까지 설정되어 있으면..
                        if(checkForm.elements[i].getAttribute("maximum") != null && checkForm.elements[i].getAttribute("maximum") != undefined && checkForm.elements[i].getAttribute("maximum") != "") {
                            // min, max 의 값이 동일하면  범위없이 값만 찍어준다
                            if(checkForm.elements[i].getAttribute("minimum") == checkForm.elements[i].getAttribute("maximum")) {
                                errMsg = errMsg.replace("%",changeIntMoneyType(checkForm.elements[i].getAttribute("minimum")));
                            } else {
                                errMsg = errMsg.replace("%",changeIntMoneyType(checkForm.elements[i].getAttribute("minimum")) + " ~ " + changeIntMoneyType(checkForm.elements[i].getAttribute("maximum")));
                            }
                        // minimum만 설정되어 있으면..
                        } else {
                            errMsg = errMsg.replace("%",changeIntMoneyType(checkForm.elements[i].getAttribute("minimum"))+" ~ ");
                        }

                        // 최소값 체크
                        if(checkForm.elements[i].getAttribute("colname") != undefined && checkForm.elements[i].getAttribute("colname") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + errMsg , checkForm.elements[i].name);
                        } else if(checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + errMsg , checkForm.elements[i].name);
                        } else {
                            fvAlert(errMsg, checkForm.elements[i].name);
                        }

                        checkForm.elements[i].select();
                        return false;
                    }
                }

                // 최대 바이트 체크
                if(checkForm.elements[i].getAttribute("maxbyte") != undefined && checkForm.elements[i].getAttribute("maxbyte") != "") {
                    if(!validationMaxByte(checkForm.elements[i].value , checkForm.elements[i].getAttribute("maxbyte"), checkForm.elements[i].getAttribute("numfullchar"))) {
                        var errMsg = COMMON_SCRIPT_00003+"(BYTE)";

                        // minbyte까지 설정되어 있으면..
                        if(checkForm.elements[i].getAttribute("minbyte") != undefined && checkForm.elements[i].getAttribute("minbyte") != "") {
                            errMsg = errMsg.replace("%", checkForm.elements[i].getAttribute("minbyte") + "~" + checkForm.elements[i].getAttribute("maxbyte"));
                        // maxbyte만 설정되어 있으면..
                        } else {
                            errMsg = errMsg.replace("%", "~" + checkForm.elements[i].getAttribute("maxbyte"));
                        }

                        //colname 어트리뷰트 추가되면서 비교하는 if문 추가.20080129
                        if(checkForm.elements[i].getAttribute("colname") != undefined) {
                            fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + errMsg, checkForm.elements[i].name);
                        } else if(checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + errMsg, checkForm.elements[i].name);
                        } else {
                            fvAlert(errMsg, checkForm.elements[i].name);
                        }

                        checkForm.elements[i].select();
                        return false;
                    }
                }

                // 최소 바이트 체크
                if(checkForm.elements[i].getAttribute("minbyte") != undefined && checkForm.elements[i].getAttribute("minbyte") !="") {
                    if(checkForm.elements[i].value.length == 0 || (!validationMinByte(checkForm.elements[i].value, checkForm.elements[i].getAttribute("minbyte")))) {
                        var errMsg = COMMON_SCRIPT_00003+"(BYTE)";

                        // maxbyte까지 설정되어 있으면..
                        if(checkForm.elements[i].getAttribute("maxbyte") != undefined && checkForm.elements[i].getAttribute("maxbyte") != "") {
                            errMsg = errMsg.replace("%", checkForm.elements[i].getAttribute("minbyte") + "~" + checkForm.elements[i].getAttribute("maxbyte"));
                        // minbyte만 설정되어 있으면..
                        } else {
                            errMsg = errMsg.replace("%", checkForm.elements[i].getAttribute("minbyte") + "~");
                        }

                        if(checkForm.elements[i].getAttribute("colname") != undefined) {
                            fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + errMsg, checkForm.elements[i].name);
                        } else if(checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                            fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + errMsg, checkForm.elements[i].name);
                        } else {
                            fvAlert(errMsg , checkForm.elements[i].name);
                        }

                        checkForm.elements[i].select();
                        return false;
                    }
                }

                // 한글이 들어간 Input값은 2byte전각 문자로 바꿔준다.
                if(checkForm.elements[i].getAttribute("chartype") == "kor" || checkForm.elements[i].getAttribute("chartype") == "kornum" || checkForm.elements[i].getAttribute("chartype") == "koreng" || checkForm.elements[i].getAttribute("chartype") == "korengnum") {
                    /*
                    if(checkForm.elements[i].getAttribute("fullchar") != "false") {
                        checkForm.elements[i].value = convert2ByteCharToString(checkForm.elements[i].value, checkForm.elements[i].getAttribute("numfullchar"));
                    }
                    */
                }

                // 최소 길이 체크
                if(checkForm.elements[i].getAttribute("minlength") != undefined && checkForm.elements[i].getAttribute("minlength") != "") {
                    if(checkForm.elements[i].getAttribute("chartype") == "kor" || checkForm.elements[i].getAttribute("chartype") == "kornum" ||    checkForm.elements[i].getAttribute("chartype") == "koreng" || checkForm.elements[i].getAttribute("chartype") == "korengnum") {
                        if(checkForm.elements[i].getAttribute("fullchar") != "false") {
                            checkForm.elements[i].value = convert2ByteCharToString(checkForm.elements[i].value, checkForm.elements[i].getAttribute("numfullchar"));
                        }

                        var _minlen = checkForm.elements[i].getAttribute("minlength")-2;
                        if(checkForm.elements[i].getAttribute("fullchar") == "false") {
                            _minlen = checkForm.elements[i].getAttribute("minlength");
                        }

                        if(checkForm.elements[i].value.length == 0 || (!validationMinByte(checkForm.elements[i].value, (_minlen)))) {
                            var errMsg = COMMON_SCRIPT_00003;

                            // maxlength까지 설정되어 있으면..
                            if(checkForm.elements[i].getAttribute("maxLength") != undefined && checkForm.elements[i].getAttribute("maxLength") != "" && checkForm.elements[i].getAttribute("maxLength") != "2147483647") {
                                errMsg = errMsg.replace("%",_minlen/2+"~"+(checkForm.elements[i].getAttribute("maxLength")-2)/2);
                            // minlength만  설정되어 있으면..
                            } else {
                                errMsg = errMsg.replace("%",_minlen/2);
                            }

                            // colname 어트리뷰트 추가되면서 비교하는 if문 추가.20080129
                            if(checkForm.elements[i].getAttribute("colname") != undefined) {
                                fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + errMsg, checkForm.elements[i].name );
                            } else if(checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                                fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + errMsg, checkForm.elements[i].name);
                            } else {
                                fvAlert(errMsg, checkForm.elements[i].name);
                            }

                            checkForm.elements[i].select();
                            return false;
                        }
                    } else {
                        if(checkForm.elements[i].value.length < checkForm.elements[i].getAttribute("minlength")) {
                            var errMsg = COMMON_SCRIPT_00003;
                            // maxlength까지 설정되어 있으면..
                            if(checkForm.elements[i].getAttribute("maxLength") != undefined && checkForm.elements[i].getAttribute("maxLength") != "" && checkForm.elements[i].getAttribute("maxLength") != "2147483647") {
                                if(checkForm.elements[i].getAttribute("minlength") != checkForm.elements[i].getAttribute("maxLength")){
                                    errMsg = errMsg.replace("%",checkForm.elements[i].getAttribute("minlength")+"~"+checkForm.elements[i].getAttribute("maxLength"));
                                } else {
                                    errMsg = errMsg.replace("%",checkForm.elements[i].getAttribute("maxLength"));
                                }
                            // minlength만  설정되어 있으면..
                            } else {
                                errMsg = errMsg.replace("%",checkForm.elements[i].getAttribute("minlength"));
                            }

                            if(checkForm.elements[i].getAttribute("colname") != undefined) {
                                fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + errMsg,checkForm.elements[i].name);
                            } else if(checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                                fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + errMsg, checkForm.elements[i].name );
                            } else {
                                fvAlert(errMsg, checkForm.elements[i].name);
                            }

                            //checkForm.elements[i].focus();
                            return false;
                        }
                    }
                }

                //최대 길이 체크
                if(checkForm.elements[i].getAttribute("maxLength") != undefined && checkForm.elements[i].getAttribute("maxLength") != "") {
                    //한글이 들어간 Input값은 -2 byte로 maxByte 체크를 한다. 20080721 김재범 추가.
                    if(checkForm.elements[i].getAttribute("chartype") == "kor" || checkForm.elements[i].getAttribute("chartype") == "kornum" || checkForm.elements[i].getAttribute("chartype") == "koreng" || checkForm.elements[i].getAttribute("chartype") == "korengnum") {
                        if(checkForm.elements[i].getAttribute("fullchar") != "false") {
                            checkForm.elements[i].value = convert2ByteCharToString(checkForm.elements[i].value, checkForm.elements[i].getAttribute("numfullchar"));
                        }

                        var _maxlen = checkForm.elements[i].getAttribute("maxLength")-2;
                        if(checkForm.elements[i].getAttribute("fullchar") == "false" || (checkForm.elements[i].getAttribute("numfullchar") == "false" && !isHan(checkForm.elements[i].value))) {
                            _maxlen = checkForm.elements[i].getAttribute("maxLength");
                        }
                        //if(checkForm.elements[i].getAttribute("fullchar") == "false")
                        //_maxlen = checkForm.elements[i].maxLength;

                        if(!validationMaxByte(checkForm.elements[i].value, _maxlen, checkForm.elements[i].getAttribute("numfullchar"))) {
                            var errMsg = COMMON_SCRIPT_00003;

                            // minlength까지 설정되어 있으면..
                            if(checkForm.elements[i].getAttribute("minlength") != undefined && checkForm.elements[i].getAttribute("minlength") != "") {
                                if(checkForm.elements[i].getAttribute("minlength") != checkForm.elements[i].getAttribute("maxLength")) {
                                    errMsg = errMsg.replace("%",checkForm.elements[i].getAttribute("minlength")/2+"~"+_maxlen/2);
                                } else {
                                    errMsg = errMsg.replace("%",_maxlen/2);
                                }
                            // maxlength만  설정되어 있으면..
                            } else {
                                errMsg = errMsg.replace("%",(checkForm.elements[i].getAttribute("maxLength")-2)/2);
                            }

                            // colname 어트리뷰트 추가되면서 비교하는 if문 추가.20080129
                            if(checkForm.elements[i].getAttribute("colname") != undefined) {
                                fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + errMsg, checkForm.elements[i].name);
                            } else if(checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                                fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + errMsg , checkForm.elements[i].name);
                            } else {
                                fvAlert(errMsg, checkForm.elements[i].name);
                            }

                            checkForm.elements[i].select();
                            return false;
                        }
                    }
                }
            }
        // select 타입이 필수일때
        } else if(checkForm.elements[i].nodeName.toString().toLowerCase() == "select") {
            if(checkForm.elements[i].getAttribute("disables") == true) {
                // checkForm.elements[i].getAttribute("disabled") = false;
                checkForm.elements[i].setAttribute("disabled", false);
            }
            if(checkForm.elements[i].getAttribute("nullable") == "false" && checkForm.elements[i].value == "") {
                // COMMON_SCRIPT_00001 : 필수입력 사항입니다.
                if(checkForm.elements[i].getAttribute("colname") != null && checkForm.elements[i].getAttribute("colname") != undefined && checkForm.elements[i].getAttribute("colname") != "") {
                    fvAlert("[" + checkForm.elements[i].getAttribute("colname")  + "] " + COMMON_SCRIPT_00001 , checkForm.elements[i].name);
                } else if(checkForm.elements[i].getAttribute("title") != null && checkForm.elements[i].getAttribute("title") != undefined && checkForm.elements[i].getAttribute("title") != "") {
                    fvAlert("[" + checkForm.elements[i].getAttribute("title")  + "] " + COMMON_SCRIPT_00001 , checkForm.elements[i].name);
                } else {
                    fvAlert(COMMON_SCRIPT_00001, checkForm.elements[i].name);
                }

                //checkForm.elements[i].focus();
                return false;
            }
        }
    }

    return true;
}

//----------------------------------------------------------------------------
// 기존 formValidation.js에 있던 사항
//----------------------------------------------------------------------------
/**
 * 이벤트 체크
 * Firefox와 IE간 호환을 위함
 */
function checkEvent(event) {
    if(IS_IE) {
        event = window.event;
        event.target = event.srcElement;
        event.which = event.keyCode;
    }

    return event;
}
/**
 * 다국어 alert() 메세지를 출력
 * ex : fvAlert('I18NUtil.getLabel(localeCode, "IBA00001","개별1회이체한도금액이 초과하였습니다.")') (스크립틀릿임.)
 * @param : 다국어 메세지
 * @return : alert(msg) 메세지
 * @see
 */
function fvAlert(msg, focusfield) {
    // 필드명 내 <br> 제거
    if(msg.indexOf('[') == 0) {
        var tmp = msg.substring(msg.indexOf('['), msg.indexOf(']')+1);
        msg = msg.substring(msg.indexOf(']')+1);
        tmp = tmp.replace(/<br>/, ' ');
        tmp = tmp.replace(/<br\/>/, ' ');
        tmp = tmp.replace(/<br \/>/, ' ');

        msg = tmp + msg;
    }

    try {
        if(focusfield==null || focusfield==undefined || focusfield =="") {
            // chkFormName;
            alert(msg);
        } else {
            if(focusfield.indexOf("_E2E123_") > -1) {
                //alert(msg,"setFocusField('#"+focusfield.replace("_E2E123_","")+"')");
            } else {
                alert(msg);
                try {
                    setFocusField('#'+focusfield);
                } catch(e) {}
            }
        }
    } catch(e) {
        alert(msg);
    }
}

//----------------------------------------------------------------------------
// 페이지 initialize 관련 함수 시작
//----------------------------------------------------------------------------
/**
 * html 페이지 로딩후 최초 실행하는 스크립트.
 */
//inc_bottom에서 해주므로 주석처리 함
//initializeHtmlPage();

/**
 * 호출된 폼마다 셋팅하기.
 * initialize시 셋팅하는 정보 : 필수 요소(css),mask,letter type
 * @param : 없음
 * @return : 없음
 * @see
 */
function initializeHtmlForm() {
    // 입력필드 하나인 경우 엔터키 입력시 리로드 방지
    try {
    	if($("input[name='_DUMMY_INPUT']").length == 0) {
    		var dummy_e = document.createElement("input");
            dummy_e.setAttribute("type", "text");
            dummy_e.setAttribute("name", "_DUMMY_INPUT");
            dummy_e.style.display = "none";

            this.appendChild(dummy_e);    		
    	}
    } catch(e) {

    }

    for (var i=0; i<this.elements.length; i++) {
        if(this.elements[i].getAttribute("type") == "text" || this.elements[i].getAttribute("type") == "password") {
            // 텍스트박스 기본 속성값 체크. 개발시에만 사용하기 바람.
            if(CHK_NOTNUL_ATTRIBUTE) {
                if((this.elements[i].getAttribute("maxlength") == null || this.elements[i].getAttribute("maxlength") == undefined) && (this.elements[i].getAttribute("maxbyte") == null || this.elements[i].getAttribute("maxbyte") == undefined)) {
                    fvAlert("알림", "maxlength 속성 누락! [" + this.elements[i].getAttribute("name") + "]");
                }
                if(this.elements[i].getAttribute("chartype") == null || this.elements[i].getAttribute("chartype") == undefined) {
                    fvAlert("알림", "chartype 속성 누락! [" + this.elements[i].getAttribute("name") + "]");
                }
                if(this.elements[i].getAttribute("colname") == null || this.elements[i].getAttribute("colname") == undefined) {
                    fvAlert("알림", "colname 속성 누락! [" + this.elements[i].getAttribute("name") + "]");
                }
            }
        }

        if(this.elements[i].nodeName.toString().toLowerCase() == "input") {
        	/*
            if(this.elements[i].getAttribute("enc") == null || this.elements[i].getAttribute("enc") == undefined) {
                this.elements[i].setAttribute("Security", "off");
            } else {
                this.elements[i].setAttribute("Security", "on");
            }
            */
            // chartype가 정의되지 않았을 경우
            if(this.elements[i].getAttribute("chartype") == null || this.elements[i].getAttribute("chartype") == undefined || this.elements[i].getAttribute("chartype") == "") {
                notEnter(this.elements[i]);
            }
            // mask가 있을경우 #은 값을 의미함.
            if(this.elements[i].getAttribute("maskform") != null && this.elements[i].getAttribute("maskform") != undefined && this.elements[i].getAttribute("maskform") != "") {
                if(this.elements[i].getAttribute("maskform") != "usermask") {
                    initSetMaskUp(this.elements[i]); // mask 타입(ex : ####/##/## , ####-##-## , ######-####### , ###-##-##### , ...)
                }
            }

            // 주민/사업자번호 처리
            if(this.elements[i].getAttribute("userfmt") != null && this.elements[i].getAttribute("userfmt") != undefined && this.elements[i].getAttribute("userfmt") != "") {
                initSetDefalutMaskUp(this.elements[i]); // mask 타입(ex : ####/##/## , ####-##-## , ######-####### , ###-##-##### , ...)
            }

            // 문자 타입이 있을경우
            if(this.elements[i].getAttribute("chartype") != null && this.elements[i].getAttribute("chartype") != undefined) {
                initSetLetterType(this.elements[i]); // 문자 셋(english,korean,english+number, number, floatmoney,int)타입
            }

            // maxlength가 있을경우
            if(this.elements[i].getAttribute("maxlength") != null && this.elements[i].getAttribute("maxlength") != undefined) {
                initSetMaxLength(this.elements[i]);
            }

            // maxByte가 있을경우
            if(this.elements[i].getAttribute("maxbyte") != null && this.elements[i].getAttribute("maxbyte") != undefined) {
                initSetMaxLength(this.elements[i]);
            }

            // engcase가  있을 경우
            if(this.elements[i].getAttribute("engcase") != undefined) {
                initSetUpperLower(this.elements[i]);
            }

            // 입력 모드 설정이  있을 경우
            if(this.elements[i].getAttribute("imemode") != null && this.elements[i].getAttribute("imemode") != undefined) {
                initImeMode(this.elements[i]);
            }

            // 첫번째 text 필드에 포커스 주기
            /*
            if(this.elements[i].type != undefined) {
                if(this.elements[i].type.toLowerCase() == "text" || this.elements[i].type.toLowerCase() == "password") {
                    if(!isFirstObj && this.elements[i].firstObj!="false") {
                        try {
                            if(this.elements[i].readonly == undefined) {
                                // 화면이 내려가는 문제로 인해 포커스 제거
                                this.elements[i].focus();
                                FIRST_FOCUS_FIELD_ID = this.elements[i].id;

                                try {
                                    this.elements[i].setActive();
                                } catch(e) {

                                }

                                isFirstObj = true;
                                FirstObj   = this.elements[i];
                            }
                        } catch(e) {

                        }
                    }
                }
            }
            */
        }
    }
}
/**
 * chartype 이 없을 때 엔터키 입력시 서브밋 방지 이벤트할당
 * @param elem
 */
function notEnter(elem) {
    if(fintech.common.null2void(elem.onkeyup) == "") {
        elem.onkeydown = function(event) {
            setDoNotEnter(event, elem);
        };
        elem.onkeyup = function(event) {
            setDoNotEnter(event, elem);
            setOverSetFocus(event, elem);
        };
    }
}
/**
 * replaceAll 처리
 */
String.prototype.replaceAll = function(strValue1, strValue2) {
    return this.split(strValue1).join(strValue2);
};
/**
 * chartype 이 없을 때 엔터키 입력시 서브밋 방지
 * @param elem
 */
function setDoNotEnter(event,elem) {
    event = checkEvent(event);

    if(event.which == 13) {
        return false;
    }
    if(event.shiftKey) {
        if(event.which == 188 || event.which == 190 || event.which == 222 || event.which == 55 || event.which == 220) {
            alert("<, >, \", ', & 등의 특수문자는 허용하지 않습니다.");

            if(!IS_IE) {
                elem.value = elem.value.replaceAll(",", "").replaceAll(".", "").replaceAll("\"", "").replaceAll("'", "").replaceAll("<", "").replaceAll(">", "").replaceAll("&", "");
            }

            returnValue(event);
        }
    } else {
        if(event.which == 220 || event.which == 222) {
            alert("<, >, \", ', & 등의 특수문자는 허용하지 않습니다.");

            if(!IS_IE) {
                elem.value = elem.value.replaceAll(",", "").replaceAll(".", "").replaceAll("\"", "").replaceAll("'", "").replaceAll("<", "").replaceAll(">", "").replaceAll("&", "");
            }

            returnValue(event);
        }
    }
}
/**
 * ImeMode 설정.
 * @param : elem
 * @return : void
 * @see
 */
function initImeMode(elem) {
    if(elem.imemode == "kor") {
        elem.style.imeMode = "active";
    } else if(elem.imemode == "eng") {
        elem.style.imeMode = "inactive";
    } else {
        elem.style.imeMode = "auto";
    }
}

/**
 * uppercase, lowercase 설정시 keyPress시 이벤트 발생.
 * @param : elem
 * @return : void
 * @see
 */
function initSetUpperLower(elem) {
    //if(elem.onblur == undefined) {
        elem.onblur = setUpperLowerCase;
    //}
}

/**
 * input 테그에 uppercase, lowercase 속성이 있을경우 발생
 * @param :
 * @return : void
 * @see
 */
function setUpperLowerCase() {
    if(this.value == "") {
        return;
    }

    if(this.getAttribute("engcase") != undefined) {
        if(this.getAttribute("engcase")=="lowercase") {
            this.value = this.value.toLowerCase();
        } else if(this.getAttribute("engcase")=="uppercase") {
            this.value = this.value.toUpperCase();
        }
    }
}

/**
 * input 테그에 capslock 속성이 있을경우 발생
 * @param :
 * @return : void
 * @see
 */
function setCapslockCase(event) {
    return;

    /*
    event = checkEvent(event);
    var pKey = String.fromCharCode(event.which);

    //if( event.target.capslock != undefined) {
         var myKeyCode=0;
         var myShiftKey=false;

         // Internet Explorer 4+
         if ( document.all ) {
          myKeyCode=event.keyCode;
          myShiftKey=event.shiftKey;

         // Netscape 4
         } else if ( document.layers ) {
          myKeyCode=event.which;
          myShiftKey=( myKeyCode == 16 ) ? true : false;

         // Netscape 6
         } else if ( document.getElementById ) {
          myKeyCode=event.which;
          myShiftKey=( myKeyCode == 16 ) ? true : false;

         }
         // Upper case letters are seen without depressing the Shift key, therefore Caps Lock is on
         if ( ( myKeyCode >= 65 && myKeyCode <= 90 ) && !myShiftKey ) {
          fvAlert( COMMON_SCRIPT_00004 );

         // Lower case letters are seen while depressing the Shift key, therefore Caps Lock is on
         } else if ( ( myKeyCode >= 97 && myKeyCode <= 122 ) && myShiftKey ) {
          fvAlert( COMMON_SCRIPT_00004 );
         }
    //}
    */
}

/**
 * maxlength, maxbyte 설정시 keyUp시 이벤트 발생.
 * @param : elem
 * @return : void
 * @see
 */
function initSetMaxLength(elem) {
    /*
    if((elem.maxlength != undefined && elem.maxlength > 0 && elem.maxlength != 2147483647) && elem.chartype != undefined && (elem.chartype == "kor" || elem.chartype == "kornum" || elem.chartype == "koreng" || elem.chartype == "korengnum")) {
       elem.maxlength = elem.maxlength + 2;
    }
    */
    if(fintech.common.null2void(elem.onkeyup) == "") {
        elem.onkeyup = setOverSetFocus;
    }

    //if(elem.onblur == undefined) elem.onblur = setUpperLowerCase;
}

/**
 * maxlength, maxbyte 설정시 최대값보다 더 들어왔을시 자동 포커스 이동.
 *  ex : setOverSetFocus()
 * @param :
 * @return :
 * @see
 */
function setOverSetFocus(event, elem) {
    var _this = this;
    if(elem) _this = elem;
    event = checkEvent(event);

    if($(_this).attr("readonly") || $(_this).attr("disabled")) {
        return false;
    }

    // 2012.06.06 이태욱수정
    // 파폭에서는 마우스 클릭 시에도 onkeyup 이벤트 발생하므로 마우스클릭(229)시에는 처리 안함
    if(event.which == 229) {
        return;
    }

    // 탭키 입력시 실행안함.
    if(event.which == 9 || event.which == 16) {
        return false;
    }
    if(event.which>=37 && event.which<=40) {
        return;
    }

    // this 개체가 속한  폼이름 가져오기
    var thisFrm = eval(_this.parentElement);

    while("form" != thisFrm.tagName.toString().toLowerCase()) {
        thisFrm = eval(thisFrm.parentElement);
    }

    var nextFocus = _this;
    var eleValue = $(_this).val();

    // 다음 포커스 타겟 가져오기.
    for(var i=0; i<thisFrm.elements.length; i++) {
        // 현재 this값이 선택된 elements이면 다음으로 이동 될 포커스를 가져오기 위한 로직수행.
        if(_this == thisFrm.elements[i]) {
            if(thisFrm.elements[i].nextfocus != undefined && thisFrm[thisFrm.elements[i].nextfocus] != undefined) {
                // nextfocus 속성이 있을경우 nextfocus값을 다음 포커스로 잡는다.
                nextFocus = thisFrm[thisFrm.elements[i].nextfocus];
                break;
            }
            // elements가 undefined 될 때 까지 수행함.
            while(thisFrm.elements[++i] != undefined) {
                // 현재 elements의 부모중의 속성이 display = none이면 다음 포커스 타겟을 가져온다.
                var targetCursor = eval(thisFrm.elements[i].parentElement);
                while("form" != targetCursor.tagName.toString().toLowerCase()) {
                    //alert(targetCursor.parentElement.readonly)
                    if(targetCursor.parentElement.style.display == "none" || targetCursor.parentElement.readonly == true) {
                        break;
                    }

                    targetCursor = eval(targetCursor.parentElement);
                }
                if(targetCursor.parentElement.style.display == "none") {
                    continue;
                }

                // elements타입이 input (text,radio,checkbox), textarea, select 일경우 다음 포커스 obj저장.
                if(thisFrm.elements[i].tagName.toString().toLowerCase() == "input" && ((thisFrm.elements[i].type == "text")|| ( thisFrm.elements[i].type == "password")) || (thisFrm.elements[i].tagName.toString().toLowerCase() == "textarea") || (thisFrm.elements[i].tagName.toString().toLowerCase() == "select")) {
                    // nextFocus 객체가 활성화 되지 않은 상태이면 다음 객체로....
                    if(thisFrm.elements[i].disabled==true || thisFrm.elements[i].style.disabled==true || thisFrm.elements[i].readonly != undefined || thisFrm.elements[i].style.display == "none" || thisFrm.elements[i].style.visibility == "hidden" || thisFrm.elements[i].focuspass=="true") {

                    } else {
                        nextFocus = thisFrm.elements[i];
                        break;
                    }
                }
            }
        }
    }

    if(nextFocus == _this) {
        IS_INT_AUTO_FOCUS = false;
    } else {
        IS_INT_AUTO_FOCUS = false; // 마지막필드에서 AUTO_FOCUS값이 false가 되버리고, 다시 위에 필드를 수정시에는 AUTO_FOCUS를 true로 돌려놓아야하므로..
    }

    // 엔터키 입력시 처리. 다음포커스로이동. 다음 포커스 없을경우 서브밋.
    /*
    if(event.which == 13) {
        if(this.type == "text" || this.type == "password" || this.tagName.toString().toLowerCase() == "select") {
            if(nextFocus == this) {
                if(ENTFUNC != "") {
                    eval(ENTFUNC);
                    return;
                }
            } else {
                nextFocus.focus();
            }
        }
    }
    */

    // 포커스 이동. maxlength 2147483647은 maxlength의 값을 주지 않았을경우 기본적으로 주는 최대값.
    // 1. maxbyte와 maxlength를 둘다 선택 하였을때..
    if($(_this).attr("maxbyte") != undefined && $(_this).attr("maxlength") != 2147483647) {
        if(($(_this).attr("maxlength") <= $(_this).val().length) || ($(_this).attr("maxbyte") <= calculate_msglen($(_this).val()))) {
            // IS_INT_AUTO_FOCUS true 설정 시 자동 포커싱 기능 안되게.
            if(IS_INT_AUTO_FOCUS) {
                if(nextFocus.tagName.toString().toLowerCase() == "select") {
                    nextFocus.focus();
                } else {
                    nextFocus.select();
                }
            }

            $(_this).val(cutStringToByte(eleValue, $(_this).attr("maxbyte")));
        }
    // 2. maxlength만 설정했을때..
    } else if($(_this).attr("maxbyte") == undefined && $(_this).attr("maxlength") != 2147483647) {
        // 금액포매팅 후 length 처리
        if($(_this).attr("chartype") == "money") {
            $(_this).val(changeIntMoneyType($(_this).val()));
        }
        if($(_this).attr("chartype") == "floatmoney") {
            $(_this).val(changeIntFloatMoneyType($(_this).val()));
        }
        if($(_this).attr("chartype") == "fexmoney") {
            $(_this).val(changeIntFloatMoneyType($(_this).val()));
        }

        // 한글이 포함된 chartype경우는 maxlength-2 값을 넘긴다.
        var _maxlen = $(_this).attr("maxlength")-2;

        if($(_this).attr("fullchar") == "false" || ($(_this).attr("numfullchar") == "false" && !isHan($(_this).val()))) {
            _maxlen = $(_this).attr("maxlength");
        }

        if(($(_this).attr("chartype") == "kor" || $(_this).attr("chartype") == "kornum" || $(_this).attr("chartype") == "koreng" || $(_this).attr("chartype") == "korengnum")) {
            if((($(_this).attr("fullchar") == "false" && _maxlen <= calculate_msglen($(_this).val())) || ($(_this).attr("fullchar") != "false" && (_maxlen/2) <= $(_this).val().length)) && (($(_this).attr("numfullchar") == "false" && _maxlen <= calcuate_HanMsglen($(_this).val())) || ($(_this).attr("numfullchar") != "false" && (_maxlen/2) <= $(_this).val().length))) {
                _this.blur();

                if(IS_INT_AUTO_FOCUS) {
                    if(nextFocus.tagName.toString().toLowerCase() == "select") {
                        nextFocus.focus();
                    } else {
                        nextFocus.select();
                    }
                }

                if($(_this).attr("fullchar") == "false") {
                    $(_this).val(cutStringToByte(eleValue, _maxlen));
                } else if($(_this).attr("numfullchar") == "false") {
                    $(_this).val(cutStringToByte(eleValue, _maxlen, true));
                } else {
                    $(_this).val(eleValue.substring(0,(_this.maxLength-2)/2));
                }
            }
        } else if($(_this).attr("maxlength") <= $(_this).val().length) {
            if(IS_INT_AUTO_FOCUS) {
                if(nextFocus.tagName.toString().toLowerCase() == "select") {
                    nextFocus.focus();
                } else {
                    nextFocus.select();
                }
            }

            $(_this).val(cutStringToByte($(_this).val(), $(_this).attr("maxlength")));
        } else if($(_this).attr("maxlength") < $(_this).val().length) {
            if(IS_INT_AUTO_FOCUS) {
                if(nextFocus.tagName.toString().toLowerCase() == "select") {
                    nextFocus.focus();
                } else {
                    nextFocus.select();
                }
            }

            $(_this).val(cutStringToByte($(_this).val(), $(_this).attr("maxlength")));
        }
    // 3. maxByte만 설정했을때..
    } else if($(_this).attr("maxbyte") != undefined && $(_this).attr("maxlength") == 2147483647) {
        if(_this.maxbyte <= calculate_msglen($(_this).val())) {
            if(IS_INT_AUTO_FOCUS) {
               if(nextFocus.tagName.toString().toLowerCase() == "select") {
                    nextFocus.focus();
                } else {
                    nextFocus.select();
                }
            }

            $(_this).val(cutStringToByte(eleValue, $(_this).attr("maxbyte")));
        }
    }

    // 크롬에서 처리위해 또 포매팅
    if($(_this).attr("chartype") == "money") {
        $(_this).val(changeIntMoneyType($(_this).val()));
        if(fintech.common.null2void($(_this).attr("transHan")) != "") {
            jb_transHan($(_this).attr("id"), $(_this).attr("transHan"));
        }
    }
    if($(_this).attr("chartype") == "floatmoney") {
        $(_this).val(changeIntFloatMoneyType($(_this).val()));
    }
    if($(_this).attr("chartype") == "fexmoney") {
        $(_this).val(changeIntFloatMoneyType($(_this).val()));
    }
}
/**
 * 문자열을 Byte길이로 잘라옴.
 *  ex : cutStringToByte(form1.name.value, bytelength)
 * @param : 바이트 길이로 자를 문자열
 * @return : 바이트 길이
 * @see
 */
function cutStringToByte(strValue, cutByte, numfullchar) {
    var sumLength = 0;
    var resultStr = "";

    for(var i=0; i<strValue.length; i++) {
        if(escape(strValue.charAt(i)).length > 3) {
            strLength = 2;
        } else if(strValue.charAt(i) == '<' || strValue.charAt(i) == '>') {
            strLength = 4;
        } else {
            if(numfullchar && isHan(strValue)) {
                strLength = 2;
            } else {
                strLength = 1;
            }
        }

        if(cutByte < (sumLength + strLength)) {
            break;
        }

        sumLength += strLength;
        resultStr += strValue.charAt(i);
    }

    return resultStr;
}

/**
 * 기본 masking 처리
 *  ex : initSetDefalutMaskUp(form1.name)
 * @param : 마스크를 셋팅할 element
 * @return : void
 * @see
 */
function initSetDefalutMaskUp(elem) {
    if(elem.getAttribute("userfmt")=="ssncorp") {
        if(elem.onkeypress == undefined) elem.onkeypress = setKeyInputNumberOnly;
        if(elem.onfocus == undefined) elem.onfocus = filterGetNumberOnly;
        if(elem.onblur == undefined) elem.onblur = setInitSsnCorpMaskUp;
    } else if(elem.getAttribute("userfmt")=="post") {
        if(elem.onkeypress == undefined) elem.onkeypress = setKeyInputNumberOnly;
        if(elem.onfocus == undefined) elem.onfocus = filterGetNumberOnly;
        if(elem.onblur == undefined) elem.onblur = setInitPostMaskUp;
    } else if(elem.getAttribute("userfmt")=="datetime") {
        if(elem.onkeypress == undefined) elem.onkeypress = setKeyInputNumberOnly;
        if(elem.onfocus == undefined) elem.onfocus = filterGetNumberOnly;
        if(elem.onblur == undefined) elem.onblur = setInitDateMaskUp;
    } else if(elem.getAttribute("userfmt")=="date") {
        if(elem.onkeypress == undefined) elem.onkeypress = setKeyInputNumberOnly;
        if(elem.onfocus == undefined) elem.onfocus = filterGetNumberOnly;
        if(elem.onblur == undefined) elem.onblur = setInitDateMaskUp;
    } else if(elem.getAttribute("userfmt")=="monthdate") {
        if(elem.onkeypress == undefined) elem.onkeypress = setKeyInputNumberOnly;
        if(elem.onfocus == undefined) elem.onfocus = filterGetNumberOnly;
        if(elem.onblur == undefined) elem.onblur = setInitMonthDateMaskUp;
    }
}

/**
 * 날짜시간형식 위한 함수
 * @param :
 * @return : void
 * @see
 */
function setInitDateMaskUp() {
	var mask = "";

	if(this.value == "") return;

	if(this.value.length==6) {
        mask = "##:##:##";
    } else if(this.value.length==8) {
        mask = "####-##-##";
    } else {
        return;
    }

    var inputV = getOnlyNumberFormat(this.value);

    for(var i=0; i<mask.length; i++) {
        if(mask.substring(i,i+1) != "#") {
            inputV = inputV.substring(0,i) + mask.substring(i,i+1) + inputV.substring(i);
        }
    }

    this.value = inputV;
}

/**
 * 년월날짜형식 위한 함수
 * @param :
 * @return : void
 * @see
 */
function setInitMonthDateMaskUp() {
    if(this.value == "") return;

    // var mask = this.maskform;
    if(this.value.length==6) {
        var mask = "####-##";
    } else {
        return ;
    }

    var inputV = getOnlyNumberFormat(this.value);

    for(var i=0; i<mask.length; i++) {
        if(mask.substring(i,i+1) != "#") {
            inputV = inputV.substring(0,i) + mask.substring(i,i+1) + inputV.substring(i);
        }
    }

    this.value = inputV;
}

/**
 * 우편번호 셋팅하기 위한 함수
 * @param :
 * @return : void
 * @see
 */
function setInitPostMaskUp() {
    if(this.value == "") return;

    // var mask = this.maskform;
    if(this.value.length==6) {
        var mask = "###-###";
    } else {
        return ;
    }

    var inputV = getOnlyNumberFormat(this.value);

    for(var i=0; i<mask.length; i++) {
        if ( mask.substring(i,i+1) != "#" ) {
            inputV = inputV.substring(0,i) + mask.substring(i,i+1) + inputV.substring(i);
        }
    }

    this.value = inputV;
}

/**
 * 주민사업자번호 셋팅하기 위한 함수
 * @param :
 * @return : void
 * @see
 */
function setInitSsnCorpMaskUp() {
	var mask = "";

	if(this.value == "") return;

	if(this.value.length==10) {
        mask = "###-##-#####";
    } else if (this.value.length==13) {
        mask = "######-#######";
    } else {
        return;
    }

    var inputV = getOnlyNumberFormat(this.value);

    for(var i=0; i<mask.length; i++) {
        if(mask.substring(i,i+1) != "#") {
            inputV = inputV.substring(0,i) + mask.substring(i,i+1) + inputV.substring(i);
        }
    }

    this.value = inputV;
}

/**
 * 숫자열 마스크 씌우기
 *  ex : initSetMaskUp(form1.name)
 * @param : 마스크를 셋팅할 element
 * @return : void
 * @see
 */
function initSetMaskUp(elem) {
    elem.onkeypress = setKeyInputNumberOnly;
    if(elem.onfocus == undefined) elem.onfocus = filterGetNumberOnly;
    if(elem.onblur == undefined) elem.onblur = setInitMaskUp;
}

/**
 * 페이지 초기화시에 onfocus 이벤트에 할당되면 이 Elemnent에 숫자외의 문자("," , "/" , "-")는 focus시에 제거됨
 * @param :
 * @return : void
 * @see
 */
function filterGetNumberOnly() {
    this.value = getOnlyNumberFormat(this.value);
    this.select();
}

/**
 * 문자열에서 숫자만 빼오기 체크 로직
 * ex : getOnlyNumberFormat(form1.name.value)
 * @param : 변환할 String 값
 * @return : void
 * @see
 */
function getOnlyNumberFormat(sv) {
    if(sv == null) return;

    var temp="";
    var ret = "";

    for(var index=0; index<sv.length; index++) {
        temp = parseInt(sv.charAt(index), 10);
        if(temp >= 0 || temp <= 9) {
            ret +=temp;
        }
    }

    return ret;
}

/**
 * 문자열에서 숫자,'-','.' 만 빼오기 체크 로직
 * ex : getOnlyNumberFormat(form1.name.value)
 * @param : 변환할 String 값
 * @return : void
 * @see
 */
function getOnlyFloatNumberFormat(sv) {
    if(sv == null) return;

    var temp="";
    var ret = "";

    for(var index=0; index<sv.length; index++) {
        if(sv.charAt(index) == '-' || sv.charAt(index) == '.') {
            ret += sv.charAt(index);
            continue;
        }

        temp = parseInt(sv.charAt(index), 10);

        if( temp >= 0 || temp <= 9) {
            ret += temp;
        }
    }

    return ret;
}

/**
 * 페이지 초기화시에 마스크 설정값대로 변환하기
 * @param :
 * @return : void
 * @see
 */
function setInitMaskUp() {
    // var mask = this.maskform;
    var mask = document.getElementsByName(this.name)[0].getAttribute('maskform');

    if(this.value == "") {
        return;
    }

    var inputV = getOnlyNumberFormat(this.value);

    for(var i=0; i<mask.length; i++) {
        if(mask.substring(i,i+1) != "#") {
            inputV = inputV.substring(0,i) + mask.substring(i,i+1) + inputV.substring(i);
        }
    }

    this.value = inputV;
}

/**
 * 페이지 초기화시 숫자만 입력받기
 * @param :
 * @return : void
 * @see
 */
function setKeyInputNumberOnly(event) {
    event = checkEvent(event);

    // shift + tab 입력가능하게 해야하므로 주석처리 함
    //if(event.shiftKey == true)  returnValue(event);

    // 숫자 키코드값
    if(event.which < 48 || event.which > 57) {
        // enter, tab, backspace 방향키(앞,뒤)는 예외처리 39번 ' 라서 제외했음
        if(event.which == null || event.which == 0 || event.which == 8 || event.which == 9) {
            return true;
        }

        turnoff_fx_event_func(event);
    }

    var pKey = String.fromCharCode(event.which);
    if(getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");
        if(userKey.toLowerCase() == "all") {
            userKey = getusercharall();
        }

        for(var i=0;i< userKey.length;i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}

/**
 * event 발생시 브라우저별로 자체 제공하는 특별기능 끄기.
 * @param event
 */
function turnoff_fx_event_func(event) {
    event = event || window.event;

    if (event.preventDefault) {
        event.preventDefault();   // firefox/모질라에서 event 발생시 자체 제공하는 특별기능 끄기.
    } else {
        returnValue(event);
    }
}

/**
 *
 * @param event
 */
function preventDefault(event) {
    if (event.currentTarget.allowDefault) {
         return;
    }

    e.preventDefault();
}

/**
 * 숫자만 입력하는 INPUT창에 붙여넣기를 했을 경우에도 숫자만 입력 되게.
 * @param :
 * @return : void
 * @see
 */
function setPasteNumberOnly(event) {
    /*
    event = checkEvent(event);

    var clipdata = window.clipboardData.getData("Text");
    clipdata = clipdata.replace(/-/gi,"");

    if(clipdata.match(/^\d+$/ig) == null) {
        // alert("형식이 맞지 않습니다.");
        return false;
    }

    var element = document.all.tags('INPUT');

    for(var idx=0; idx<element.length; idx++) {
        var obj = element[idx];

        if(obj.onpaste && obj == this) {
            obj.value = clipdata.substring(0,clipdata.length);
        }
    }

    turnoff_fx_event_func(event);
    */
    return false;
}

/**
 * 페이지 초기화시에 언어 및 숫자형 입력 및 표현 처리.
 * @param : 이벤트를 셋팅할 element
 * @return : void
 * @see
 */
function initSetLetterType(elem) {
    // 한글만
    if(elem.getAttribute("chartype") == "kor") {
        elem.style.imeMode = "active";
        if(elem.onkeypress == undefined) {
            elem.onkeypress = setLetterKoreanOnly;
        }
    // 한글+숫자
    } else if (elem.getAttribute("chartype").toLowerCase() == "kornum") {
        elem.style.imeMode = "active";
        if(elem.onkeypress == undefined) {
            elem.onkeypress = setLetterKorNumOnly;
        }
    // 한글+영문
    } else if (elem.getAttribute("chartype").toLowerCase() == "koreng") {
        elem.style.imeMode = "auto";
        if(elem.onkeypress == undefined) {
            elem.onkeypress = setLetterKorEngOnly;
        }
    // 한글+영문+숫자
    } else if (elem.getAttribute("chartype").toLowerCase() == "korengnum") {
        elem.style.imeMode = "auto";
        if(elem.onkeypress == undefined) {
            elem.onkeypress = setLetterKorEngNumOnly;
        }
    // 영어만
    } else if (elem.getAttribute("chartype").toLowerCase()  == "eng") {
        elem.style.imeMode = "disabled";
        if(elem.onkeypress == undefined) {
            elem.onkeypress = setLetterEnglishOnly;
        }
        if(elem.onblur == undefined) {
            elem.onblur = chkNotKorField;  // 한글오류처리IE제외브라우져관련
        }
    // 영어+숫자
    } else if (elem.getAttribute("chartype").toLowerCase()  == "engnum") {
        elem.style.imeMode = "disabled";
         if(elem.onkeypress == undefined) {
             elem.onkeypress = setLetterEngNumOnly;
         }
         if(elem.onblur == undefined) {
             elem.onblur = chkNotKorField;
         }
    // 특수문자 입력 안되게 수정해야함.
    } else if (elem.getAttribute("chartype").toLowerCase()  == "float") {
         // 실수형
         if(elem.onkeypress == undefined) {
             elem.onkeypress = setLetterFloatOnly;
         }
         if(elem.onblur == undefined) {
             elem.onblur = chkNotKorField;
         }
    // 정수형
    } else if (elem.getAttribute("chartype").toLowerCase()  == "int") {
         if(elem.onkeypress == undefined) {
             elem.onkeypress = setLetterInteger;
         }
         if(elem.onblur == undefined) {
             elem.onblur = chkNotKorField;
         }
    // 오직 숫자만
    } else if (elem.getAttribute("chartype").toLowerCase()  == "onlynum") {
        elem.style.imeMode = "disabled";
        elem.onpaste       = setPasteNumberOnly;
        elem.onkeypress    = setKeyInputNumberOnly;
        if(elem.onblur == undefined) {
            elem.onblur = chkNotKorField;
        }
    } else if (elem.getAttribute("chartype").toLowerCase()  == "date") {
    	elem.style.imeMode = "disabled";
    	elem.onpaste       = setPasteNumberOnly;
        elem.onkeypress    = setKeyInputNumberOnly;
    	elem.onfocus = function(e) {
    		var value = $(this).val();
    		$(this).val(value.replaceAll("-",""));
    		$(this).attr("maxlength", 8);
    	}
    	elem.onblur = function(e) {
    		var value = $(this).val();
    		if(isHan(this.value)) {
    	        $("#" + this.id).val("");
    	        fvAlert(COMMON_SCRIPT_00014,"setFocusField('#"+this.id+"')");
    	        return false;
    	    }
    		$(this).val(formatter.date(value));
    		$(this).attr("maxlength", 8);
    	}
    // 정수로만 된 아주 기본적인 금액 표시
    } else if ((elem.getAttribute("chartype").toLowerCase()  == "money") && !(elem.getAttribute("readonly"))) {
        elem.style.imeMode = "disabled";
        //elem.style.direction = "rtl";  // 인풋박스 오른쪽 정렬 스타일
        elem.style.textAlign = "right";

        if(fintech.common.null2void(elem.onkeypress) == "") {
            elem.onkeypress = setLetterInteger; // setFloatMoney; 키를 눌렀다 놓았을때
        }
        if(fintech.common.null2void(elem.onblur) == "") {
            // ff 오류
            elem.onblur = setKeypressMoney;
        }
    } else if ((elem.getAttribute("chartype").toLowerCase() == "floatmoney") && !(elem.getAttribute("readonly"))) {
        elem.style.imeMode = "disabled";
        // elem.style.direction = "rtl";
        elem.style.textAlign = "right";
        if(elem.onkeypress == undefined) {
            elem.onkeypress = setLetterFloatOnly; // 키를 눌렀다 놓았을때
        }
        if(elem.onblur == undefined) {
            elem.onblur = setFloatMoney;
        }
    } else if ((elem.getAttribute("chartype").toLowerCase() == "fexmoney") && !(elem.getAttribute("readonly"))) {
        elem.style.imeMode = "disabled";
        elem.style.textAlign = "right";
        if(elem.onkeypress == undefined) {
            elem.onkeypress = setLetterFloatOnly; // 키를 눌렀다 놓았을때
        }
        if(elem.onblur == undefined) {
            elem.onblur = setFexMoney;
        }
    }
}

/**
 * 페이지 초기화시 -,숫자 입력받기( - 키코드값 189)
 * @param :
 * @return : void
 * @see
 */
function setKeydownMoney(event) {
    event = checkEvent(event);
    if(event.shiftKey == true) returnValue(event);

    // 숫자 키코드값
    if(event.which<48||(event.which>57&&event.which<96)||event.which>105) {
        // enter, tab, backspace 방향키(앞,뒤),delete는 예외처리
        if(event.which == 8 || event.which == 9 || event.which == 37 || event.which == 39 || event.which == 189 || event.which == 46) {
            return true;
        }

        turnoff_fx_event_func(event);
    }
}

/**
 * 페이지 초기화 시에 금액 형태일 경우 키 입력시 금액 형태로 전환
 * @param :
 * @return : void
 * @see
 */
function setKeypressMoney(event) {
    event = checkEvent(event);

    var ev = getEventElement(event);
    var tempV = ev.value;
    if (!IS_IE) {
    	if(isHan(tempV)) {
            $("#" + ev.id).val("");
            fvAlert(COMMON_SCRIPT_00014,"setFocusField('#"+ev.id+"')");
            turnoff_fx_event_func(event);
            return;
        }
    }
    if(tempV.length > 0) {
        var stat = true;

        while(stat) {
            if(tempV.length > 0 && tempV.substring(0,1)==0) {
                tempV = tempV.substr(1);
            } else {
                stat = false;
            }
        }
    }

    var moneyReg = new RegExp('(-?[0-9]+)([0-9]{3})');

    // 2012.06.06 이태욱수정
    // ff 오류로 인해(텍스트박스에서 blur시 금액버튼 클릭할 때 NaN 발생) 주석처리
    //tempV = tempV + pKey;
    tempV = tempV.replaceAll(",", "");
    tempV = String(Number(tempV));
    while(moneyReg.test(tempV)) {
        tempV = tempV.replace(moneyReg, '$1,$2');
    }

    if(Number(tempV.replaceAll(",","")) == 0) {
    	ev.value = 0;
    } else {
    	ev.value = tempV;    	
    }

    if(event.which == 9) {
        ev.select();
    }
    chkNotKorFieldVal(this.id, this.value);
    turnoff_fx_event_func(event);
}

/**
 * 스트링값을 정수형 머니 형태로 변환
 *  ex : changeIntMoneyType("1100000") 리턴되는 데이타 : 1,100,000
 * @param : 변환할 String 데이타
 * @return : 금액 형태로 변환된 스트링
 * @see
 */
function changeIntMoneyType(data) {
    var tempV = data;
    tempV = String(tempV);
    var moneyReg = new RegExp('(-?[0-9]+)([0-9]{3})');
    tempV = tempV.replaceAll(",", "");

    while(moneyReg.test(tempV)) {
        tempV = tempV.replace(moneyReg, '$1,$2');
    }

    return tempV;
}

/**
 * 스트링값을 실수형 머니 형태로 변환
 *  ex : changeIntFloatMoneyType("11000.11") 리턴되는 데이타 : 11,000.11
 * @param : 변환할 String 데이타
 * @return : 금액 형태로 변환된 스트링
 * @see
 */
function changeIntFloatMoneyType(data) {
    var tempV = data;
    var floatnum = "";

    if(tempV.indexOf(".") != -1) {
        floatnum = tempV.substring(tempV.indexOf(".")); // + pKey;
        tempV = tempV.substring(0,tempV.indexOf("."));
    }

    var moneyReg = new RegExp('(-?[0-9]+)([0-9]{3})');
    tempV = tempV.replace(/\,/g, "");

    while(moneyReg.test(tempV)) {
        tempV = tempV.replace(moneyReg, '$1,$2');
    }

    tempV = tempV+floatnum;

    return tempV;
}

/**
 * 실수형 금액 입력제어 스크립트. 숫자 , . , - 값만 입력받음. 소수점 두째 자리까지만 입력됨
 *  ex : changeIntMoneyType("1100000") 리턴되는 데이타 : 1,100,000
 * @param : 변환할 String 데이타
 * @return : 금액 형태로 변환된 스트링
 * @see
 */
function setKeydownFloatMoney(event) {
    event = checkEvent(event);
    if(event.shiftKey == true) returnValue(event);

    var floatindex = getEventElement(event).value.indexOf(".");

    if(floatindex != -1) {
        var floatNum = getEventElement(event).value.substring(floatindex+1);
        if (event.which == 8 ) {
            return;
        } else if (floatNum.length > 1 ) {
            turnoff_fx_event_func(event);
        }
    }

    // 숫자 키코드값
    if(event.which<48||(event.which>57&&event.which<96)||event.which>105) {
        if( event.which == 8 || event.which == 9 || event.which == 37 || event.which == 39 || event.which == 189) {
            return;
        } else if(event.which == 190 && floatindex == -1) {
            return
        }

        turnoff_fx_event_func(event);
    }
}

/**
 * 키 입력시 float 타입의 금액 형태로 전환
 * @param :
 * @return :
 * @see
 */
function setFloatMoney(event) {
    event = checkEvent(event);
    var ev = getEventElement(event);
    var pKey = String.fromCharCode(event.which);

    var tempV = ev.value;
    var floatnum = "";

    if(tempV.indexOf(".") != -1) {
        floatnum = tempV.substring(tempV.indexOf(".")) + pKey;
        tempV = tempV.substring(0,tempV.indexOf("."));
    } else {
        tempV = tempV + pKey;
    }

    var moneyReg = new RegExp('(-?[0-9]+)([0-9]{3})');
    tempV = tempV.replace(/\,/g, "");

    while(moneyReg.test(tempV)) {
        tempV = tempV.replace(moneyReg, '$1,$2');
    }

    ev.value = tempV+floatnum;
    if(event.which == 9){ev.select();}
    turnoff_fx_event_func(event);

    chkNotKorFieldVal(this.id, this.value);
}

/**
 * 키 입력시 float 타입의 외환금액 형태로 전환 - 소수점 둘째자리에서 버림.
 * @param :
 * @return :
 * @see
 */
function setFexMoney(event) {
    event = checkEvent(event);
    var ev = getEventElement(event);
    var pKey = String.fromCharCode(event.which);

    var tempV = ev.value;
    var floatnum = "";

    if(tempV.indexOf(".") != -1) {
        floatnum = tempV.substring(tempV.indexOf("."), parseInt(tempV.indexOf(".") + 3)) + pKey;
        tempV = tempV.substring(0,tempV.indexOf("."));
    } else {
        tempV = tempV + pKey;
    }

    var moneyReg = new RegExp('(-?[0-9]+)([0-9]{3})');
    tempV = tempV.replace(/\,/g, "");

    while(moneyReg.test(tempV)) {
        tempV = tempV.replace(moneyReg, '$1,$2');
    }

    ev.value = tempV+floatnum;
    if(event.which == 9){ev.select();}
    turnoff_fx_event_func(event);

    chkNotKorFieldVal(this.id, this.value);
}

/**
 * 키 입력시 한글만 입력받기
 * @param :
 * @return :
 * @see
 */
function setLetterKoreanOnly(event) {
    event = checkEvent(event);

    if(event.which == null || event.which == 0 || event.which == 8 || event.which == 9 ||  event.which == 39) {
        return true;
    }

    var pKey = String.fromCharCode(event.which);
    if(!((pKey.charCodeAt() > 0x3130 && pKey.charCodeAt() < 0x318F) || (pKey.charCodeAt() >= 0xAC00 && pKey.charCodeAt() <= 0xD7A3))) {
        turnoff_fx_event_func(event);
        delete eReg;
    }

    if(getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");
        if(userKey.toLowerCase()=="all") {
            userKey = getusercharall();
        }

        for(var i=0; i<userKey.length;i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}

/**
 * 키 입력시 한글,숫자 입력받기
 * @param :
 * @return :
 * @see
 */
function setLetterKorNumOnly(event) {
    event = checkEvent(event);
    var pKey = String.fromCharCode(event.which);
    if(event.which == null || event.which == 0 || event.which == 8 || event.which == 9 ||  event.which == 39) {
        return true;
    }
    if(!((pKey.charCodeAt() > 0x3130 && pKey.charCodeAt() < 0x318F) || (pKey.charCodeAt() >= 0xAC00 && pKey.charCodeAt() <= 0xD7A3) || !setKeyInputNumberOnly(event))) {
        turnoff_fx_event_func(event);
       // delete eReg;
    }

    if( getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");
        if(userKey.toLowerCase()=="all") {
            userKey = getusercharall();
        }
        for(var i=0; i<userKey.length; i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}

/**
 * 키 입력시 한글,영어만 입력받기
 * @param :
 * @return :
 * @see
 */
function setLetterKorEngOnly(event) {
    event = checkEvent(event);
    var pKey = String.fromCharCode(event.which);
    var eReg = /[a-zA-Z]/g;

    if(event.which == null || event.which == 0 || event.which == 8 || event.which == 9 ||  event.which == 39) {
        return true;
    }
    if(!((pKey.charCodeAt() > 0x3130 && pKey.charCodeAt() < 0x318F) || (pKey.charCodeAt() >= 0xAC00 && pKey.charCodeAt() <= 0xD7A3) || !(pKey!="\r" && setLetterEnglishOnly(event)))) {
        turnoff_fx_event_func(event);
        delete eReg;
    }

    //setUpperLowerCase();
    setCapslockCase();

    if(getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");

        if(userKey.toLowerCase() == "all") {
            userKey = getusercharall();
        }

        for(var i=0; i<userKey.length; i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}

function test(event) {
    event = event || window.event;

    if (event.preventDefault) {
        return true;
    } else {
        event.returnValue  = true;
    }
}

/**
 * 이벤트 한글체크
 */
function chkNotKorField() {
    if(isHan(this.value)) {
        $("#" + this.id).val("");
        fvAlert(COMMON_SCRIPT_00014,"setFocusField('#"+this.id+"')");
    }
}

/**
 * 입력값 한글체크
 * @param objid
 * @param val
 */
function chkNotKorFieldVal(objid, val) {
    if(isHan(val)) {
        $("#" + objid).val("");
        fvAlert(COMMON_SCRIPT_00014,"setFocusField('#"+objid+"')");
    }
}

function isHan(pValue) {
    var rtnData = false;

    if(isEmpty(pValue)) {
        rtnData = false;
    }

    for(var idx=0;idx < pValue.length;idx++) {
        var c = escape(pValue.charAt(idx));
        if(!rtnData && c.indexOf("%u") > -1) {
            rtnData = true;
            break;
        }
    }

    return rtnData;
}
function isEmpty(pValue) {
	if(pValue == undefined || pValue == null || fintech.common.null2void(String(pValue)).replaceAll(" ", "") == "") {
        return true;
    }

    return false;
}
function setFocusField(obj) {
	$(obj).focus();
}

/**
 * 키 입력시 한글,영어,숫자만 입력받기
 * @param :
 * @return :
 * @see
 */
function setLetterKorEngNumOnly(event) {
    event = checkEvent(event);
    var pKey = String.fromCharCode(event.which);

    if(!((pKey.charCodeAt() > 0x3130 && pKey.charCodeAt() < 0x318F) || (pKey.charCodeAt() >= 0xAC00 && pKey.charCodeAt() <= 0xD7A3)) && ((event.which < 65 || event.which > 122) || (90 < event.which && event.which < 97))) {
        // 숫자허용
        if((47 < event.which && event.which < 58) && !event.shiftKey) {
            return true;
        }
        // enter, tab, backspace 방향키(앞,뒤)는 예외처리
        if(event.which == null || event.which == 0 || event.which == 8 || event.which == 9 || event.which == 39) {
           return true;
        }

        turnoff_fx_event_func(event);
    }

    //setUpperLowerCase();
    setCapslockCase();

    if(getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");

        if(userKey.toLowerCase() == "all") {
            userKey = getusercharall();
        }

        for(var i=0; i<userKey.length; i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}

/**
 * 키 입력시 영어만 입력받기
 * @param :
 * @return :
 * @see
 */
function setLetterEnglishOnly(event) {
    event = checkEvent(event);

    var pKey = String.fromCharCode(event.which);

    // 문자 키코드값
    if((event.which < 65 || event.which > 122) || (90 < event.which && event.which < 97)) {
        // enter, tab, backspace 방향키(앞,뒤)는 예외처리
        if(event.which == null || event.which == 0 || event.which == 8 || event.which == 9 || event.which == 39) {
            return true;
        }

        turnoff_fx_event_func(event);
    }

    //setUpperLowerCase();
    setCapslockCase();

    if(getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");

        if(userKey.toLowerCase()=="all") {
            userKey = getusercharall();
        }

        for(var i=0; i<userKey.length; i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}

/**
 * 키 입력시 영어,숫자만 입력받기
 * @param : event
 * @return :
 * @see
 */
function setLetterEngNumOnly(event) {
    event = checkEvent(event);

    var pKey = String.fromCharCode(event.which);

    // 문자 키코드값
    if((event.which < 65 || event.which > 122) || (90 < event.which && event.which < 97) ) {
        // 숫자허용
        if((47 < event.which && event.which < 58) && !event.shiftKey) {
            return true;
        }
        // enter, tab, backspace 방향키(앞,뒤)는 예외처리 39 는 ' 라서 제거
        if(event.which == null || event.which == 0 || event.which == 8 || event.which == 9) {
            return true;
        }

        turnoff_fx_event_func(event);
    }

    //setUpperLowerCase();
    setCapslockCase();

    if(getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");

        if(userKey.toLowerCase() == "all") {
            userKey = getusercharall();
        }

        for(var i=0; i<userKey.length; i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}

/**
 * 키 입력시 숫자,- 값만 입력받음.
 * @param :
 * @return :
 * @see
 */
function setLetterInteger(event) {
    event = checkEvent(event);

    var pKey = String.fromCharCode(event.which);
    //var intReg = /[0-9\\-]/g;
    var intReg = /[0-9]/g;

    // 엔터키 및 regkey가 아닐경우 리턴
    /*
    if(pKey!="\r" && !intReg.test(pKey)) {
        turnoff_fx_event_func(event);
    }
    */
    // 숫자가 아닌경우는 리턴
    if(!intReg.test(pKey)) {
        if(event.which != 0 && event.which != 8) {
            turnoff_fx_event_func(event);
        }
    }

    delete intReg;

    if(getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");

        if(userKey.toLowerCase() == "all") {
            userKey = getusercharall();
        }

        for(var i=0; i<userKey.length; i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}

/**
 * 키 입력시 숫자 , . , - 값만 입력받음.
 * @param :
 * @return :
 * @see
 */
function setLetterFloatOnly(event) {
    event = checkEvent(event);

    var pKey = String.fromCharCode(event.which);
    var floatReg = /[0-9\\.\\-]/g;

    // 엔터키 및 regkey가 아닐경우 리턴
    if(pKey!="\r" && !floatReg.test(pKey)) {
        turnoff_fx_event_func(event);
    }

    delete floatReg;

    if(getEventElement(event).getAttribute("userchar") != undefined) {
        var userKey = getEventElement(event).getAttribute("userchar");

        if(userKey.toLowerCase()=="all") {
            userKey = getusercharall();
        }

        for(var i=0; i<userKey.length; i++) {
            if(pKey == userKey.charAt(i)) {
                event.returnValue=true;
                break;
            }
        }
    }
}
//----------------------------------------------------------------------------
// 페이지 initialize 관련 함수 끝
//----------------------------------------------------------------------------



/**
 * 최소값 체크 로직
 * ex : validationMinimum("100000","10000")
 * @param : 지정된 최소 value
 * @param : 입력된 Value
 * @return : boolean
 * @see
 */
function validationMinimum(minV,inV) {
    if (minV == "") {
        fvAlert(COMMON_SCRIPT_00005);
        return false;
    }

    if(parseFloat(inV) < parseFloat(minV)) {
        return false;
    }

    return true;
}

/**
 * 최대값 체크 로직
 * ex : validationMaximum("100000","10000")
 * @param : 지정된 최대 value
 * @param : 입력된 Value
 * @return : boolean
 * @see
 */
function validationMaximum(maxV,inV) {
    if(maxV == "") {
        fvAlert(COMMON_SCRIPT_00006);
        return false;
    }

    if(parseFloat(maxV) < parseFloat(inV)) {
        return false;
    }

    return true;
}

/**
 * 최대 btye 체크 로직
 * ex : validationMaxByte(form1.inputname.value , 10)
 * @param : 체크할 String value
 * @param : 최대 byte
 * @return : boolean
 * @see
 */
function validationMaxByte(textObj, length_limit, numfullchar) {
    if(numfullchar == "false" && !isHan(textObj)) {
        return true;
    }

    var length  = calculate_msglen(textObj);

    if (length > length_limit) {
        return false;
    }

    return true;
}

/**
 * 최소 btye 체크 로직
 * ex : validationMinByte(form1.inputname.value , 10)
 * @param : 체크할 String value
 * @param : 최소 byte
 * @return : boolean
 * @see
 */
function validationMinByte(textObj, length_limit) {
    var length = calculate_msglen(textObj);

    if (length < length_limit) {
        return false;
    }

    return true;
}

/**
 *
 * @param message
 * @returns {Number}
 */
function calcuate_HanMsglen(message) {
    var nbytes = 0;
    var isHangul = false;

    for(var i=0; i<message.length; i++) {
        var ch = message.charAt(i);

        if(isHangul(ch)) {
            //nbytes = calculate_msglen(convert2ByteCharToString(message));
            isHangul = true;
        } else {
            //nbytes = calculate_msglen(message);
            //if(!isHangul) isHangul = false;
        }
    }

    if(isHangul) {
        nbytes = calculate_msglen(convert2ByteCharToString(message));
    } else {
        nbytes = calculate_msglen(message);
    }

    return nbytes;
}

/**
 * 한글 2글자 영문 1글자로 길이 측정하여 문자열의 byte 길이를 리턴한다.
 * ex : validationMaxByte(form1.inputname.value , 10)
 * @param : 체크할 String value
 * @return : 측정한 해당 값의 byte 길이
 * @see
 */
function calculate_msglen(message) {
    var nbytes = 0;

    for(var i=0; i<message.length; i++) {
        var ch = message.charAt(i);

        if(escape(ch).length > 4) {
            nbytes += 2;
        } else if(ch == '\n') {
            if(message.charAt(i-1) != '\r') {
                nbytes += 1;
            }
        } else if (ch == '<' || ch == '>') {
            nbytes += 4;
        } else {
            nbytes += 1;
        }
    }

    return nbytes;
}

/**
 * 사용자가 지정한 마스크업 스타일중 영어,숫자 혼합인 데이타의 mask를 지울때 사용 영어,숫자 이외의 문자 제거
 *  ex : unMaskEngNum(String)
 * @param : 마스크가 있는 String
 * @return : 구분자를 제외한 String
 * @see
 */
function unMaskEngNum(data) {
    var accReg = new RegExp('([a-zA-Z0-9])');
    var temp = "";

    for(var i=0; i<data.length; i++) {
        if(accReg.test(data.substr(i,1))) {
            temp += data.substr(i,1);
        }
    }

    return temp;
}

/**
 * 문자열을 전각문자열로 변환 (문자열의 반각문자를 전각문자로 변환함)
 * @param : x_string 변환할 문자열
 * @return : 변환된 전각문자열
 * @see
 */
function convert2ByteCharToString(x_string, numfullchar) {
    return x_string;
    /*
    if(numfullchar == "false") {
        if(!isHan(x_string)) {
            return x_string;
        }

        var isAllNum = true;
        // 만약 필드에 숫자만 들어가있다면 전각문자로 변환하지 않는다.

        for(i=0;i < x_string.length;i++) {
            var c  = x_string.charCodeAt(i)
            if(((c > 0x3130 && c < 0x318F) || (c >= 0xAC00 && c <= 0xD7A3)))
            {
                isAllNum = false;
                break;
            }
        }
        if(isAllNum) {
            return x_string;
        }
    }

    var x_2byteString = ""; // 컨버트된 문자
    var isBeforeSpace = false;

    for(var i=0; i<x_string.length; i++) {
        var c = x_string.charCodeAt(i);

        // 전각으로 변환될수 있는 문자의 범위
        if(32 <= c && c <= 126) {
            // 스페이스인경우 ascii 코드 32
            if(c == 32) {
                // 아래와 같이 변환시 깨짐.
                // x_2byteString = x_2byteString + unescape("%uFFFC");
                // 스페이스가 연속으로 2개 들어왔을경우 스페이스 하나로 처리하기 위함..
                if(isBeforeSpace) {
                    x_2byteString = x_2byteString + "";
                    isBeforeSpace = false;
                } else {
                    x_2byteString = x_2byteString + unescape("%u"+gf_DecToHex(12288));
                    isBeforeSpace = true;
                }
            } else {
                x_2byteString = x_2byteString + unescape("%u"+gf_DecToHex(c+65248));
                isBeforeSpace = false;
            }
        } else {
            x_2byteString = x_2byteString + x_string.charAt(i);
            isBeforeSpace = false;
        }
    }

    return  x_2byteString;
    */
}

/**
 * 반각문자를 전각문자로 변환한다.
 * @param : 전각문자로 변환할 문자
 * @return : 변환된 전각문자
 * @see
 */
function convert2ByteChar(x_char) {
    var x_2byteChar = ""; // 컨버트된 문자
    var c = x_char.charCodeAt(0);

    // 전각으로 변환될수 있는 문자의 범위

    if(32 <= c && c <= 126) {
        // 스페이스인경우 ascii 코드 32
        if(c == 32) {
            // 아래와 같이 변환시 깨짐.
            // x_2byteChar = unescape("%uFFFC");
            x_2byteChar = unescape("%u"+gf_DecToHex(12288));
        } else {
            x_2byteChar = unescape("%u"+gf_DecToHex(c+65248));
        }
    }

    return  x_2byteChar;
}

/**
 * HEX코드 복호화
 */
function gf_DecToHex(dec) {
    return dec.toString(16);
}

/**
 * 문자 방지(한글 제외)
 *  ex : ONKEYPRESS="hasOnlyNumber();"
 * @param : boolean
 * @return : void
 * @see
 */
function hasOnlyNumber(Obj, event) {
    event = checkEvent(event);
    var keyCode = event.which ? event.which : event.which ? event.which : event.charCode;

    // Select Box외 기타 이벤트 방지
    if(keyCode > 222) {
        return false;
    }

    if (keyCode != 13) {
        if(!((keyCode>45 && keyCode<58) || (keyCode>95 && keyCode<106) || (keyCode>7 && keyCode<10) || (keyCode>36 && keyCode<41))) {
            fvAlert(COMMON_SCRIPT_00007);

            if(Obj == null) {
                turnoff_fx_event_func(event);
            } else {
                Obj.value = "";
                Obj.focus();
            }
        }
    }
}

/**
 * 특수문자 리턴
 * @returns {String}
 */
function getusercharall() {
    return "~!@#$%^&*()_+|-=.,?";
}

/**
 * 금액을 한글로 표시
 * @param sour
 * @param targ
 */
function jb_transHan(id, targ) {
    var s = Number($("#"+id).val().replaceAll(",", "").replaceAll("-", ""))+"";
    var t = $("#"+targ);

    if(s.length > 16) {
        if(t.attr("type") == "text") {
            t.val('숫자가 너무 큽니다');
        } else {
            t.html('숫자가 너무 큽니다');
        }

        return;
    } else if(isNaN(s)) {
        if(t.attr("type") == "text") {
            t.val('숫자가 아닙니다');
        } else {
            t.html('숫자가 아닙니다');
        }

        return;
    }

    b1  = ' 일이삼사오육칠팔구';
    b2  = '천백십조천백십억천백십만천백십원';
    tmp = '';
    cnt = 0;

    while(s != '') {
        cnt++;
        tmp1 = b1.substring(s.substring(s.length-1,s.length), Number(s.substring(s.length-1,s.length))+1); // 숫자
        tmp2 = b2.substring(b2.length-1,b2.length); // 단위
        if(tmp1==' ') { // 숫자가 0일때
            if(cnt%4 == 1) { // 4자리로 끊어 조,억,만,원 단위일때만 붙여줌
                tmp = tmp2 + tmp;
            }
        } else {
            if(tmp1 == '일' && cnt%4 != 1) { // 단위가 조,억,만,원일때만 숫자가 일을 붙여주고 나머지는 생략 ex) 삼백일십만=> 삼백십만
                tmp = tmp2 + tmp;
            } else {
                tmp = tmp1 + tmp2 + tmp; // 그외에는 단위와 숫자 모두 붙여줌
            }
        }

        b2 = b2.substring(0, b2.length-1);
        s = s.substring(0, s.length-1);
    }

    tmp = tmp.replace('억만','억').replace('조억','조'); // 조,억,만,원 단위는 모두 붙였기 때문에 필요없는 단위 제거

    if(t.attr("type") == "text") {
        t.val(tmp);
    } else {
        t.html(tmp);
    }
}