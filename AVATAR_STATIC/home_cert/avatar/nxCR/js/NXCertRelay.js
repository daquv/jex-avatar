//var keysharpnxBaseDir = ""; //개발
var keysharpnxBaseDir = ""; //운영

var ksloadflag = false;

document.write("<script type='text/javascript' charset='utf-8' src='" + keysharpnxBaseDir+ "/nxCR/common/exproto.js'></script>"); 
document.write("<script type='text/javascript' charset='utf-8' src='" + keysharpnxBaseDir + "/nxCR/js/NXCertRelay_Install.js'></script>"); 
document.write("<script type='text/javascript' charset='utf-8' src='" + keysharpnxBaseDir + "/nxCR/js/NXCertRelay_Interface.js'></script>"); 

//[간편인증서내보내기/가져오기] 관련 변수. 
//var g_ICRP_ServerIP = "183.111.160.141"; // 개발
var g_ICRP_ServerIP = "183.111.151.72"; // 운영
var g_ICRP_ServerPort = "10500";
var g_ICRP_PwdCount = "3";
var g_ICRP_Function = "1";
var g_ICRP_BannerImgURL = "";		//QR코드인증서복사에서도 사용.	//QR코드인증서복사에서도 사용.
var g_ICRP_AutoFocus ="0";
var g_ICRP_PKCS12 ="0";
var g_ICRP_Language = "1";
var g_ICRP_RequiredAlg = "0";
var g_ICRP_Kmcertsupport= "0";
var g_ICRP_Keypro = "1";
var g_ICRP_CodeSignVerify = "1";
var g_ICRP_FontSizeEditCtrl = "15";
var g_ICRP_FontSizeCnum = "40";
var g_ICRP_CertDN = "";

//[QR코드인증서복사] 관련 변수
var g_QRServerSendCertURL   = "https://211.32.131.182:8600/QR_CERTMOVE/client/sendcert.jspx";
var g_QRServerMyCertURL     = "https://211.32.131.182:8600/QR_CERTMOVE/phone/mycert.jspx";
var g_QRServerAuthquertyURL = "https://211.32.131.182:8600/QR_CERTMOVE/client/checkcert.jspx";
var g_QR_TimerSecond = "60";
var g_QR_TimerFlag = "1";
var g_QR_HttpVer = "0";


//[공통][간편인증서내보내기/가져오기]인증서 정책 설정 변수.
//셋팅 리얼:TRUE 테스트:FALSE
var IsOnLine ='TRUE';
//var IsOnLine ='FALSE';
//var IsOnLine ='ALL';

var policyoid_yessign = ":1.2.410.200005.1.1.1";		//범용개인
	policyoid_yessign += ":1.2.410.200005.1.1.2";		//금융기업
	policyoid_yessign += ":1.2.410.200005.1.1.4";		//은행-보험
	policyoid_yessign += ":1.2.410.200005.1.1.5"; 		//범용기업
	policyoid_yessign += ":1.2.410.200005.1.1.6.1"; 	//법인, 용도제한(기업뱅킹)
	policyoid_yessign += ":1.2.410.200005.1.1.6.8"; 	//이세로, 용도제한(세금계산서)
	
var policyoid_signkorea = ":1.2.410.200004.5.1.1.5";  	//범용개인
	policyoid_signkorea += ":1.2.410.200004.5.1.1.7";   //범용법인
	policyoid_signkorea += ":1.2.410.200004.5.1.1.9";   //개인, 용도제한

var policyoid_signgate = ":1.2.410.200004.5.2.1.1";		//범용기업
	policyoid_signgate += ":1.2.410.200004.5.2.1.2";	//범용개인
	policyoid_signgate += ":1.2.410.200004.5.2.1.7.1";	//은행-보험
	
var policyoid_crosscert = ":1.2.410.200004.5.4.1.1";	//범용개인
	policyoid_crosscert += ":1.2.410.200004.5.4.1.2"; 	//범용기업
	policyoid_crosscert += ":1.2.410.200004.5.4.1.101"; //은행-보험
	
var policyoid_tradesign = ":1.2.410.200012.1.1.1";		//범용개인
	policyoid_tradesign += ":1.2.410.200012.1.1.3";		//범용기업
	policyoid_tradesign += ":1.2.410.200012.1.1.101";	//은행-보험

var policyoid_ncasign = ":1.2.410.200004.5.3.1.9";		//범용개인
	policyoid_ncasign += ":1.2.410.200004.5.3.1.2";		//범용기업
	
var accept_list = "";
var accept_list_real="yessignCA";
	accept_list_real+=policyoid_yessign;
	
	// 증권전산원 인증서 수용 부분
	accept_list_real+=",SignKorea CA";
	accept_list_real+=policyoid_signkorea;
	
	// 한국정보인증 인증서 수용 부분
	accept_list_real+=",signGATE CA2";
	accept_list_real+=policyoid_signgate;
	
	// 한국전자인증 인증서 수용 부분
	accept_list_real+=",CrossCert Certificate Authority";
	accept_list_real+=policyoid_crosscert;
	
	// 한국무역정보통신 인증서 수용 부분
	accept_list_real+=",TradeSignCA";
	accept_list_real+=policyoid_tradesign;
	
	// 한국전산원 인증서 수용 부분
	accept_list_real+=",NCASignCA";
	accept_list_real+=policyoid_ncasign;
	
	//2048
	accept_list_real+=",yessignCA Class 1";
	accept_list_real+=policyoid_yessign;
//2048 new
	accept_list_real+=",yessignCA Class 2";
	accept_list_real+=policyoid_yessign;	

        accept_list_real+=",CrossCertCA3";
	accept_list_real+=policyoid_crosscert;
 
	accept_list_real+=",signGATE CA5";
	accept_list_real+=policyoid_signgate;
 
	accept_list_real+=",SignKorea CA3";
	accept_list_real+=policyoid_signkorea;
 
	accept_list_real+=",TradeSignCA3";
	accept_list_real+=policyoid_tradesign;

	accept_list_real+=",SignKorea CA2";
	accept_list_real+=policyoid_signkorea;
	
	accept_list_real+=",signGATE CA4";
	accept_list_real+=policyoid_signgate;
	
	accept_list_real+=",CrossCertCA2";
	accept_list_real+=policyoid_crosscert;
	
	accept_list_real+=",TradeSignCA2";
	accept_list_real+=policyoid_tradesign;

var accept_list_test="yessignCA-TEST";
	accept_list_test+=policyoid_yessign;
	
	accept_list_test+=",SignGateFTCA CA";
	accept_list_test+=policyoid_signgate;
	
	accept_list_test+=",signGATE FTCA02";
	accept_list_test+=policyoid_signgate;
	
	accept_list_test+=",SignKorea Test CA";
	accept_list_test+=policyoid_signkorea;
	
	accept_list_test+=",NCATESTSign";
	accept_list_test+=policyoid_ncasign;
	
	accept_list_test+=",CrossCertCA-Test2";
	accept_list_test+=policyoid_crosscert;
	
	accept_list_test+=",TestTradeSignCA";
	accept_list_test+=policyoid_tradesign;
	
	//2010.08.05 추가 yhp
	accept_list_test+=",yessignCA-Test Class 0";
	accept_list_test+=policyoid_yessign;
	
	//2048
	accept_list_test+=",yessignCA-Test Class 1";
	accept_list_test+=policyoid_yessign;
	
	//2048 new 2015.12
	accept_list_test+=",yessignCA-Test Class 2";
	accept_list_test+=policyoid_yessign;
	accept_list_test+=",signGATE FTCA04";
	accept_list_test+=policyoid_signgate;
	
	accept_list_test+=",SignKorea Test CA2";
	accept_list_test+=policyoid_signkorea;
	
	accept_list_test+=",CrossCertTestCA2";
	accept_list_test+=policyoid_crosscert;
	
	accept_list_test+=",TradeSignCA2009Test2";
	accept_list_test+=policyoid_tradesign;
	
if(IsOnLine == 'TRUE'){
	//리얼 인증서
	accept_list = accept_list_real;
}else if(IsOnLine == 'FALSE'){
	//테스트 인증서
	accept_list = accept_list_test;
}else if(IsOnLine == 'ALL'){
	accept_list = accept_list_real + "," + accept_list_test;
}



//////////////////////////////간편 인증서 복사 관련 문구. - 수정 (2017-11-08 정태성)
function SetExplainStr() {
	//메인 타이틀 설정. 
	KSCertRelayNXInterface.KS_SetStr_ICRP_MAIN_TITLE(["[비즈플레이] 인증번호로 인증서 복사하기"]);
	KSCertRelayNXInterface.KS_SetStr_ICRP_MAIN_TITLE_ENG(["[Page input message] [Simple Certificate Export/Import]Main Title"]);
	
	//설명 문구 설정. 인증서 내보내기 문구. 
	KSCertRelayNXInterface.KS_SetStr_CERTEXPORT_INTRO(["인증서 내보내기 시작.\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTEXPORT_INTRO_ENG(["[Page input message]  Start Certificate Export.\r\nSetStr_CERTEXPORT_INTRO"]);
	
	//내보내기. 인증서 선택.
	KSCertRelayNXInterface.KS_SetStr_CERTEXPORT_CERTSELECT_2(["인증서가 선택되었습니다.\r\n비밀번호입력.\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTEXPORT_CERTSELECT_2_ENG(["[Page input message]  Certificate is selected\r\nInput password.\r\nSetStr_CERTEXPORT_CERTSELECT_2"]);
	
	// 내보내기. 인증번호 입력.	
	KSCertRelayNXInterface.KS_SetStr_CERTEXPORT_INPUTCNUM_3(["인증번호 입력.\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTEXPORT_INPUTCNUM_3_ENG(["[Page input message]  Input Authentication Number.\r\nSetStr_CERTEXPORT_INPUTCNUM_3"]);
	
	// 내보내기. 내보내기 완료 문구.
	KSCertRelayNXInterface.KS_SetStr_CERTEXPORT_SUC_4(["인증서 내보내기 완료.\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTEXPORT_SUC_4_ENG(["[Page input message]  SetStr_CERTEXPORT_SUC_4.\r\nSetStr_CERTEXPORT_SUC_4"]);
		
	// 가져오기. 시작.
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_INTRO_1(["[인증서 가져오기]\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_INTRO_1_ENG(["[Page input message] [Certificate Import]\r\nSetStr_CERTIMPORT_INTRO_1"]);
	
	// 가져오기. 인증서 선택.
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_CERTSELECT_2(["[인증서 가져오기]\r\n인증서 선택.\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_CERTSELECT_2_ENG(["[Page input message] [Certificate Import]\r\nSelect Certificate.\r\nSetStr_CERTIMPORT_CERTSELECT_2"]);
	
	// 가져오기. 인증번호 생성.
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_MAKECNUM_3(["[인증서 가져오기]\r\n인증번호 생성\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_MAKECNUM_3_ENG(["[Page input message] [Certificate Import]\r\nAuthentication Number generation\r\nSetStr_CERTIMPORT_MAKECNUM_3"]);
	
	// 가져오기. 인증번호가 존재하지 않을 경우. (인증서를 내보내는 쪽에서 인증번호를 입력하지 않았을 경우)
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_WRONGCNUM(["[인증서 가져오기]\r\n보내는 단말에서 인증번호를 입력하세요.\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_WRONGCNUM_ENG(["[Page input message] [Certificate Import]\r\nPlease, input Authentication Number in the device.\r\nSetStr_CERTIMPORT_WRONGCNUM"]);
	
	// 가져오기. 가져오기완료.
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_SUC(["[인증서 가져오기]\r\n인증서 가져오기 완료.\r\n"]);
	KSCertRelayNXInterface.KS_SetStr_CERTIMPORT_SUC_ENG(["[Page input message] [Certificate Import]\r\nsuccess import.\r\nSetStr_CERTIMPORT_SUC"]);
}

function SetExplainStr_QR() {
	//메인 타이틀 설정. 
	KSCertRelayNXInterface.KS_SetStr_QRCODE_Main_Name(["[QR인증서복사]메인타이틀"]);
	KSCertRelayNXInterface.KS_SetStr_QRCODE_Main_Name_ENG(["[Page input message] [QR]Main Title"]);

	KSCertRelayNXInterface.KS_SetStr_QRCODE_DLG1_INTRO(["[QRcode 인증서복사]\r\nSetStr_QRCODE_DLG1_INTRO"]);
	KSCertRelayNXInterface.KS_SetStr_QRCODE_DLG1_INTRO_ENG(["[Page input message] [QR] \r\nSetStr_QRCODE_DLG1_INTRO"]);

	KSCertRelayNXInterface.KS_SetStr_QRCODE_DLG1_CERTSELECT(["[QRcode 인증서복사]\r\n인증서가 선택되었습니다.\r\nSetStr_QRCODE_DLG1_CERTSELECT"]);
	KSCertRelayNXInterface.KS_SetStr_QRCODE_DLG1_CERTSELECT_ENG(["[Page input message] [QR] \r\nSetStr_QRCODE_DLG1_CERTSELECT"]);
	
	KSCertRelayNXInterface.KS_SetStr_QRCODE_DLG2_INTRO(["[QRcode 인증서복사]\r\nSetStr_QRCODE_DLG2_INTRO"]);
	KSCertRelayNXInterface.KS_SetStr_QRCODE_DLG2_INTRO_ENG(["[Page input message] [QR] \r\nSetStr_QRCODE_DLG2_INTRO"]);
	KSCertRelayNXInterface.KS_SetStr_QRCODE_DLG2_DISPLAYQRCODE(["[QRcode 인증서복사]\r\nQR코드가 생성되었습니다.\r\nSetStr_QRCODE_DLG2_DISPLAYQRCODE"]);
	KSCertRelayNXInterface.KS_SetStr_QRCODE_DLG2_DISPLAYQRCODE_ENG(["[Page input message] [QR] \r\nSetStr_QRCODE_DLG2_DISPLAYQRCODE"]);
	
	KSCertRelayNXInterface.KS_SetStr_QRCODE_CERT_DEL_EXPLAIN(["[QRcode 인증서복사]\r\n인증서를 삭제합니다."]);
	KSCertRelayNXInterface.KS_SetStr_QRCODE_CERT_DEL_EXPLAIN_ENG(["[Page input message] [QR] \r\nCertificate delete"]);

	KSCertRelayNXInterface.KS_SetStr_QRCODE_CERT_DEL_CONFIRM_STR(["[QRcode 인증서복사]\r\n정말 인증서를 삭제 하시겠습니까?"]);
	KSCertRelayNXInterface.KS_SetStr_QRCODE_CERT_DEL_CONFIRM_STR_ENG(["[Page input message] [QR] \r\nCertificate delete"]);
}
//###################  Browser check ########################//
//////////////////////////////////////
// TODO EX plugin - Web
//////////////////////////////////////

if (!window.console)
	console = {log : function(msg) {}};

function KS_loading() {
	exlog("==============loading================");
	try {
		if(!ksloadflag){
			TOUCHENEX_CHECK.check([keysharpnxInfo] , "KS_loading_callback");
			ksloadflag=true;
		}
	} catch (e) {}
}
function KS_loading_callback(check) {
	exlog("KS_loading_callback", check);
	try {
        currStatus = check;
        if (currStatus.status) {
            keysharpnxInfo.ksInstalled = currStatus.status;
            TOUCHENEX_LOADING("KS_loadingCallback");
        } else {
        	KS_notInstall(currStatus);
        }
    } catch (e) {}
}

function KS_loadingCallback(check) {
//console.log("==============KS_loadingCallback================");	
}

function KS_extensionInstall() {
	if(TOUCHENEX_UTIL.isChrome() || TOUCHENEX_UTIL.isFirefox() || TOUCHENEX_UTIL.isOpera()){
		KS_extensiondownload();
	}
}

function KS_extensiondownload() {
    KEYSHARPEX_INSTALL.download('nxwirelesscert', 'extension');
}

function KS_installPage() {
    if (typeof Keysharp_installpage == "undefined") {
        location.href = keysharpnxInfo.ksInstallpage;
    }
	
}

function KS_isInstallcheck() {
    try {
        KS_installCheck('KS_installCheckCallback');
    } catch (e) {}
}

function KS_installCheck(callback) {
    try {
        TOUCHENEX_CHECK.check([keysharpnxInfo], callback);
  	} catch (e) {}
}

function KS_installCheckCallback(check) {
    try {
        currStatus = check;
        if (currStatus.status) {
            keysharpnxInfo.isInstalled = currStatus.status;
            if (typeof Keysharp_installpage != "undefined") {
                KS_moveMainPage();
            }
        } else {
            KS_notInstall(currStatus); 
        }
    } catch (e) {}
}

function KS_moveMainPage() {
    location.href = keysharpnxInfo.ksMainpage;
}

function KS_notInstall(currStatus) {
	try {
        if (!currStatus.status) {
			keysharpnxInfo.ksInstalled = currStatus.status;
            if (typeof Keysharp_installpage == "undefined") {
            	KS_installPage();
            } else {
                if (!currStatus.info[0].isInstalled) {
                    if (!currStatus.info[0].extension) {
                        if (TOUCHENEX_UTIL.isChrome() || TOUCHENEX_UTIL.isFirefox() || (TOUCHENEX_UTIL.isOpera())) {
                            ////KS_extensiondownload();
                            keysharpnxInfo.exInstalled = false;
                        }
                    }//test
                    else{
                    	keysharpnxInfo.exInstalled = true;
                    }

                    if (!currStatus.info[0].client || !currStatus.info[0].EX) {
                       //Keysharpnx_download();
                        keysharpnxInfo.clInstalled = false;
                    }//test
                    else{
                    	keysharpnxInfo.clInstalled = true;
                    }
                } else {
                    if (typeof Keysharp_installpage != "undefined") {
                        KS_moveMainPage();
                    }
                }
            }
        } else {
            keysharpnxInfo.isInstalled = currStatus.status;
            if (typeof Keysharp_installpage != "undefined") {
                KS_moveMainPage();
            }
        }
    } catch (e) {}
}
function KS_download() {
    KEYSHARPEX_INSTALL.download('nxwirelesscert', 'client');
}

function LoadMain() {
	if(SupportCheck())
	{
		exlog("LoadMain");
		SetRelayServer();
		SetBannerImg();
		SetFunction();
		SetExplainStr();
		SetDisplayOID();
		SetPwdCount();
		//SetPKCS12();
		//SetAutoFocus();
		SetLanguage();
		//SetKmcertsupport();
		//SetRequiredAlg();
		//SetKeypro();
		//SetCodeSignVerify();
		//SetCertDN();
		//SetFontSizeEditCtrl();
		//SetFontSizeCnum();
		//SetCertDelete();
		KSCertRelayNXInterface.KS_LoadMain(["NONE" , "NONE"]);
	}
	else
	{
		//안내페이지 이동시 사용
		//location.href = keysharpnxInfo.ksInstallpage;
	}
}


function SetRelayServer() {
   
	KSCertRelayNXInterface.KS_SetRelayServer([g_ICRP_ServerIP , g_ICRP_ServerIP , g_ICRP_ServerPort]);
}

function SetFunction() {
	KSCertRelayNXInterface.KS_SetFunction([g_ICRP_Function]);
}

function SetDisplayOID() {
	KSCertRelayNXInterface.KS_SetDisplayOID([accept_list]);
}

function SetBannerImg() {
	KSCertRelayNXInterface.KS_SetBannerImg([g_ICRP_BannerImgURL]);
}

function SetPwdCount() {
	KSCertRelayNXInterface.KS_SetPwdCount([g_ICRP_PwdCount]);
}

function SetPKCS12() {
	KSCertRelayNXInterface.KS_SetPKCS12([g_ICRP_PKCS12]);
}

function SetAutoFocus() {
	KSCertRelayNXInterface.KS_SetAutoFocus([g_ICRP_AutoFocus]);
}

function SetLanguage() {
	KSCertRelayNXInterface.KS_SetLanguage([g_ICRP_Language]);
}

function SetKmcertsupport() {
	KSCertRelayNXInterface.KS_SetKmcertsupport([g_ICRP_Kmcertsupport]);
}

function SetRequiredAlg(){	
	KSCertRelayNXInterface.KS_SetRequiredAlg([g_ICRP_RequiredAlg]);
}

function SetKeypro(){
	KSCertRelayNXInterface.KS_SetKeypro([g_ICRP_Keypro]);
}

function SetCodeSignVerify(){	
	KSCertRelayNXInterface.KS_SetCodeSignVerify([g_ICRP_CodeSignVerify ]);
}

function SetCertDN() {
	KSCertRelayNXInterface.KS_SetCertDN([g_ICRP_CertDN]);
}

function SetCertDelete() {
	KSCertRelayNXInterface.KS_SetCertDelete(["1","[페이지입력문구]인증서 내보내기 후 인증서를 삭제하는게 안전합니다."]);
}

function SetFontSizeEditCtrl(){	
	KSCertRelayNXInterface.KS_SetFontSizeEditCtrl([g_ICRP_FontSizeEditCtrl]);
}

function SetFontSizeCnum(){	
	KSCertRelayNXInterface.KS_SetFontSizeCnum([g_ICRP_FontSizeCnum]);
}
function SetServerSendCert_QR() {
	KSCertRelayNXInterface.KS_SetServerSendCert_QR([g_QRServerSendCertURL]);
}

function SetServerMyCert_QR() {
	KSCertRelayNXInterface.KS_SetServerMyCert_QR([g_QRServerMyCertURL]);
}

function SetQRTimer() {
	KSCertRelayNXInterface.KS_SetQRTimer([g_QR_TimerSecond, g_QR_TimerFlag]);
	KSCertRelayNXInterface.KS_SetServerAuthQuery_QR([g_QRServerAuthquertyURL]);
}

function SetHttpVer_QR() {
	KSCertRelayNXInterface.KS_SetHttpVer_QR([g_QR_HttpVer]);
}

function LoadMainQR() {
	if(SupportCheck())
	{
		SetBannerImg();
		SetServerSendCert_QR();
		SetServerMyCert_QR();
		SetQRTimer();
		SetDisplayOID();
		SetExplainStr_QR();
		SetLanguage();
		//SetHttpVer_QR();
		//SetKeypro();
		//SetPKCS12();
		//SetCodeSignVerify();
		//SetCertDelete();
		KSCertRelayNXInterface.KS_LoadMainQR(["NONE" , "NONE"]);
	}
	else
	{
		//안내페이지 이동시 사용
		//location.href = keysharpnxInfo.ksInstallpage;
	}
}
function SupportCheck()
{
	try{
		if(TOUCHENEX_UTIL.isWin()){
			if(TOUCHENEX_UTIL.isIE() && parseInt(TOUCHENEX_UTIL.getBrowserVer()) >= parseInt(keysharpnxInfo.reqSpec.Browser.MSIE)) return true;
			else if(TOUCHENEX_UTIL.isChrome() && parseInt(TOUCHENEX_UTIL.getBrowserVer()) >= parseInt(keysharpnxInfo.reqSpec.Browser.CHROME)) return true;
			else if(TOUCHENEX_UTIL.isFirefox() && parseInt(TOUCHENEX_UTIL.getBrowserVer()) >= parseInt(keysharpnxInfo.reqSpec.Browser.FIREFOX)) return true;
			else if(TOUCHENEX_UTIL.isOpera() && parseInt(TOUCHENEX_UTIL.getBrowserVer()) >= parseInt(keysharpnxInfo.reqSpec.Browser.OPERA)) return true;
			else if(TOUCHENEX_UTIL.isSafari() && parseInt(TOUCHENEX_UTIL.getBrowserVer()) >= parseInt(keysharpnxInfo.reqSpec.Browser.SAFARI_WIN)) return true;
			else if(TOUCHENEX_UTIL.isEdge()) return true;
			else
			{
				alert("현재 사용중인 브라우저는 최신버전이 아닙니다. 최신버전으로 업데이트 후 이용부탁드립니다.");
				return false;
			}
		}
		else {
			alert(" 현재 미지원 운영체제에서 사용중입니다. Windows 환경에서 이용부탁드립니다.");
			return false;
		}
	}catch(e){
	alert ("미지원환경입니다.")
	return false;
	}
}
