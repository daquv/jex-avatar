/**
 * fileDownload sample script
 */
var KEYSHARPEX_INSTALL = {

	installWindow : null,
	
	download : function( moduleName, type ) {
		
		var pluginInfo = {};
		for(var i = 0; i < TOUCHENEX_CONST.pluginInfo.length; i++){
			if(TOUCHENEX_CONST.pluginInfo[i].exModuleName == moduleName){
				pluginInfo = TOUCHENEX_CONST.pluginInfo[i];
				//exlog("_INSTALL.download", pluginInfo);
				break;
			}
		}
		var dummyParam = "dummy="+Math.floor(Math.random() * 10000) + 1;
		

		
		
		// Extension
		if(type == "extension"){
			
			if(TOUCHENEX_UTIL.isChrome()){
				
				if(!this.installWindow || this.installWindow.closed){
					//this.installWindow = window.open(pluginInfo.exExtensionInfo.exChromeExtDownURL);
					this.installWindow = window.open(keysharpnxInfo.exExtensionInfo.exChromeExtDownURL);
					if(this.installWindow == null) alert("팝업차단을 확인해주세요.");
				}
				
			} else if(TOUCHENEX_UTIL.isFirefox()) {
				
				var params = {};
				dummyParam = "ver=" + keysharpnxInfo.exExtensionInfo.exFirefoxExtVer;
				
				params[keysharpnxInfo.exProtocolName + "_firefox"] = {
					URL: keysharpnxInfo.exExtensionInfo.exFirefoxExtDownURL + "?" + dummyParam,
					IconURL: keysharpnxInfo.exExtensionInfo.exFirefoxExtIcon
				};
				InstallTrigger.install(params);
				
			} else if(TOUCHENEX_UTIL.isOpera()) {
				
				dummyParam = "ver=" + keysharpnxInfo.exExtensionInfo.exOperaExtVer;
				window.open(keysharpnxInfo.exExtensionInfo.exOperaExtDownURL + "?" + dummyParam, "_self");
			} else {
				alert("현재 브라우저는 extension 설치를 지원하지 않습니다.");
			}
			return;
		}
		
		// EX
		if(type == "EX"){
			var downURL = "";
			
			if(TOUCHENEX_UTIL.isWin()){
				if(TOUCHENEX_UTIL.getBrowserBit() == "64"){
					downURL = keysharpnxInfo.exProtocolInfo.exWin64ProtocolDownURL;
				} else {
					downURL = keysharpnxInfo.exProtocolInfo.exWinProtocolDownURL;
				}
			}
			
			if(!TOUCHENEX_UTIL.isIE()){
				dummyParam = "ver=" + keysharpnxInfo.exProtocolInfo.exWinProtocolVer;
				window.open(downURL + "?" + dummyParam, "_self");
			} else {
				window.open(downURL, "_self");
			}
			return;
		}
		
		// Client
		if(type == "client"){
			var downURL = "";
			
			if(TOUCHENEX_UTIL.isWin()){
				if(TOUCHENEX_UTIL.getBrowserBit() == "64"){
					downURL = keysharpnxInfo.moduleInfo.exWin64Client;
				} else {
					downURL = keysharpnxInfo.moduleInfo.exWinClient;
				}
			} 
			
			if(!TOUCHENEX_UTIL.isIE()){
				dummyParam = "ver=" + keysharpnxInfo.moduleInfo.exWinVer;
				window.open(downURL + "?" + dummyParam, "_self");
			} else {
				window.open(downURL, "_self");
			}
			return;
		}
        
        //[2015.11]로컬웹서버 방식.
        // Daemon
		if(type == "daemon"){
			
			if(typeof TOUCHENEX_UTIL.typeDaemon == "function" && TOUCHENEX_UTIL.typeDaemon()){
				dummyParam = "ver=" + pluginInfo.exEdgeInfo.daemonVer;
				window.open(pluginInfo.exEdgeInfo.daemonDownURL + "?" + dummyParam, "_self");
			} else {
				alert("현재 브라우저는 daemon 설치를 지원하지 않습니다.");
			}
			return;
		}
	}
};