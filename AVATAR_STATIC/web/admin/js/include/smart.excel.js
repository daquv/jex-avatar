/**
 * 
 */
$(document).ready(function(){
	try{
		var excelDownloadHtml="<div style='display:none' id='_jexGridExcelDown'>";
		//excelDownloadHtml+="<form method='post' enctype='multipart/form-data' name='_jexGridDownloadForm' id='_jexGridDownloadForm' action='/view/jex/webcash/include/downloadProc.jsp' target='_jexGridDownloadIfrm'>";
		excelDownloadHtml+="<form method='post' enctype='multipart/form-data' name='_jexGridDownloadForm' id='_jexGridDownloadForm' action='/view/jex/avatar/include/downloadProc.jsp' target='_jexGridDownloadIfrm'>";
		excelDownloadHtml+="<textarea  name='json' id='json'></textarea>";
		excelDownloadHtml+="</form>";
		excelDownloadHtml+="<iframe name='_jexGridDownloadIfrm' id='_jexGridDownloadIfrm' style='width:0px;height:0px;display:none'/>";
		excelDownloadHtml+="</div>";	
		$("body").append(excelDownloadHtml);
		
		console.log("Download form >>>>>>>>>>>>>>>>>>");
		console.log(excelDownloadHtml);
	}catch(e){
		console.log("excelDownloadHtml ERROR: "+e);
		console.log("excelDownloadHtml ERROR_MSG: "+e.message);
		
	};
});

function _excelDownload(downGrid, title){
	//원본 그리드 정보읽기
	
	var orgGrid = downGrid;
	var jgridDownload = {};
	jgridDownload.fileTitle = {
		title: jexjs.null2Void(title,"")
		,details:[]
	};

	//파일의 헤더(타이틀)정보 읽기
	if(!!orgGrid.fileTitle)
	{
		jgridDownload.fileTitle.title = orgGrid.fileTitle.title;
		for(var key in orgGrid.fileTitle.details)
		{
			if(!!orgGrid.fileTitle.details[key].key)
			{
				jgridDownload.fileTitle.details.push({
					key:orgGrid.fileTitle.details[key].key
					,value:orgGrid.fileTitle.details[key].value
				});
			}
		}
	}
	
	var _datalist = orgGrid.dataMgr.datalist;
	var _datalistLength = _datalist.length;

	if(_datalist.length==0)
	{
		alert("저장 할 항목이 없습니다. 저장항목을 확인해주세요.");
		return false;
	}
	
	
	
	var orgColDef = orgGrid.colDefMgr.getAll();
	var _colDefList = [];
	for(var i=0 ; i<orgColDef.length ; i++)
	{
		if( orgColDef[i].key == "checkbox" || orgColDef[i].hidden )
		{
			continue;
		}

		_colDefList.push({
			 gridunqid : String(i)
			,name : orgColDef[i].name
			,key : orgColDef[i].key
			,width: orgColDef[i].width
			,sumRenderer: !!orgColDef[i].sumRenderer?true:false
			,renderer : orgColDef[i].renderer
			,excelFormat : orgColDef[i].excelFormat
		});
	}
	var _colDefLength = _colDefList.length;
	var _saveDatalist = [];
	var _saveDatarow;
	var pattern = /(<([^>]+)>)/gi;	// 컬럼안에 태그 있을경우 내용까지 공백으로 변환되어 변경 by lsh
	for(var i=0 ; i<_datalistLength ; i++)
	{
		_saveDatarow = {};
		for(var j=0 ; j<_colDefLength ; j++)
		{
			var _cellValue;
			//var _cellValue = !!_colDefList[j].renderer?_colDefList[j].renderer(_datalist[i][ _colDefList[j].key ] , i):_datalist[i][ _colDefList[j].key ];
			if( !!_colDefList[j].renderer ) {
				try{
					var tempValue = _datalist[i][ _colDefList[j].key ];
					if(tempValue == null || tempValue == undefined || tempValue == "" || tempValue == "undefined"){
						tempValue ="";
					}
					_cellValue = _colDefList[j].renderer(tempValue , i , j , _datalist[i] , _colDefList[j]);
					if(_cellValue == null || _cellValue == undefined || _cellValue == "" || _cellValue == "undefined"){
						_cellValue = "";
					}else{
						if(typeof _cellValue == "string"){
							_cellValue = _cellValue.replace(pattern, "").replace(/&nbsp;/ig, " "); 	
						}
					}
				}catch(e){
					_cellValue = "";
				}
			}else{
				_cellValue = _datalist[i][ _colDefList[j].key ];
                if(_colDefList[j].name=="")
                    _colDefList[j].name="메모";
			}

			if (_colDefList[j].excelFormat == "int"){
				if((typeof _cellValue) == "string"){
					_cellValue = parseInt(_cellValue.replace(/,/g,"").replace("\\(", "").replace("\\)", ""));
				}
			}
			
			_saveDatarow["A"+j] = _cellValue==undefined?"":_cellValue;
			
		}
		
		_saveDatalist.push(_saveDatarow);
	} 

	var result = {
		colDef:_colDefList,
		data:_saveDatalist,
		title:jgridDownload.fileTitle
	};
	$("#_jexGridDownloadForm").find("#json").val( encodeURI(JSON.stringify(result)) );

	document.getElementById("_jexGridDownloadForm").submit();

	checkAjaxEnd(jgridDownload.fileTitle, _saveDatalist.length);
};

function checkAjaxEnd(title, dataCnt)
{
	var interval = window.setInterval(checkStart, 1000);
	
	var isWait = false;
	function checkStart()
	{
		if(isWait)	return;
		
		isWait = true;
		
		$.ajax({
	        type:"POST",
	        //url:"/view/jex/serpcmsadmin/include/excel_out.jsp",
	        url:"/view/jex/avatar/include/excel_out.jsp",
	        data:"",
	        cache:false,
	        async:true,
	        success: function(out) {
	        	
				if (typeof(out)=="string") out = JSON.parse(out);
				
				if(out.RESULT=="SUCCESS"||out.RESULT=="FAIL")
				{
					
					var hisData = {
					    menu_nm : title.title,
						save_file_nm : out.FILE_NAME,
						data_cnt : dataCnt,
						accs_ip : out.ACCS_IP
					};
						
					insertFileHistory(hisData);
					
					window.clearInterval(interval);
				}
				
				isWait = false;
	        }
		});
	}
}


function insertFileHistory(data){
	
	var input ={
		"MENU_NM" : data.menu_nm,
		"SAVE_FILE_NM" : data.save_file_nm,
		"DATA_CNT" : data.data_cnt,
		"ACCS_IP" : data.accs_ip
	};
	
	$.ajax({
        type:"POST",
        url:"/filesave_0001_01_c001"+".jct",
        data:input,
        success: function(out) {
        	console.log(out);
        	
        }
	});
	
	
}
