/*
 * CrossEX Daemon Port Checker
 */
var isDebug = false;
var local_host = "wss://127.0.0.1";
var start_port = 34581;
var end_port;
var current_port;
var check_count = 3;


function wsPortScan(exwsParam) {
	if(exwsParam.port)
		start_port = exwsParam.port;
	
	if(exwsParam.localhost)
		local_host = exwsParam.localhost;
	if(exwsParam.chkCnt)
		check_count = exwsParam.chkCnt;
	end_port = start_port + check_count;
	current_port = start_port;
	wsPortScanWorker();
}

function wsPortScanWorker() {
	if (current_port >= end_port) {
		postMessage("false");
		return;
	}
	try {
		 var ws;
		ws = new WebSocket(local_host + ":" + current_port + "/");
		
		ws.onopen = function() {
		ws.send({});
		};
		
		ws.onmessage = function(event) {
			ws.close();
			postMessage(current_port);
		};
		
		ws.onerror = function() {
			current_port++;
			wsPortScanWorker();
		};
		
		ws.onclose = function() {
			
		};
	} catch (e) {
		
		postMessage("false");
		return;
	}
}

self.addEventListener('message', function(e) {
	self.wsPortScan(e.data);
}, false);
