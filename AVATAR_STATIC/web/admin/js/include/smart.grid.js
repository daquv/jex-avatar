
var smart;
if(!smart) smart={};
if(!smart.grid) smart.grid={};

// 그리드 공통 옵션
smart.grid.getDefaultOptions = function() {
	return {
		width: "99.8%",
		//border: "0.7px solid #868686",
		border: "1px solid #999",
		imageUrl:"/img/grid/",
		font: "12px",
		autoWidth: false,
		ColHeader: {
			height: 24
			,reorderEnabled: true
			,reorderSyncEnabled:true
			,background: "#e5e5e5 repeat-x center bottom"
		//	,classColHeader  : "grid-colHeader"
			,resizeHandleBackground: ""
			,font: "10px"
			,headerStyle: " border-bottom: 1px solid silver; color : #637b97; "
			,padding:"0 5 0 5"
		},
		ColDefManager: {
			colDef: {
				resizable: true,
				tooltipEnabled: false,
				width: 100,
				sorter: "text"
			}
		},
		ViewportManager: {
	        rowsPerPage: 15,                 // 출력 ROW수
	        rowH: 20,                       // ROW의 높이
	        autoColWEnabled: true,
			borderThickness: 1,
	        evenOddRows: true,
	        oddRowsBackground: "#F4F4F4",
	        autoHeight: false,
	        autoWidth: false,
	        padding:"0 5 0 5"
		},
		autoColWEnabled: true,
		DataManager: {},
		SelectionManager : {}
	};
};

smart.grid.getDefaultScardOption = function() {
	return {
		width: "99.8%",
		//border: "0.7px solid #868686",
		border: "1px solid #999",
		imageUrl:"/img/grid/",
		font: "12px",
		autoWidth: false,
		ColHeader: {
			height: 30
			,reorderEnabled: true
			,reorderSyncEnabled:true
			,background: "#788496 repeat-x center bottom"
			,backgroundHover: "#788496 repeat-x center bottom"
		//	,classColHeader  : "grid-colHeader"
			,resizeHandleBackground: ""
			,font: "10px"
			,headerStyle: " border-bottom: 1px solid #626c79; color : #ffffff; font-size:12px;"
			,padding:"0 5 0 5"
		},
		ColDefManager: {
			colDef: {
				resizable: true,
				tooltipEnabled: false,
				width: 100,
				sorter: "text"
			}
		},
		ViewportManager: {
	        rowsPerPage: 15,                 // 출력 ROW수
	        rowH: 30,                       // ROW의 높이
	        autoColWEnabled: true,
			borderThickness: 1,
	        evenOddRows: true,
	        oddRowsBackground: "#F4F4F4",
	        autoHeight: false,
	        autoWidth: false,
	        padding:"0 5 0 5",
	        rowStyle:" font-size:12px;"
		},
		autoColWEnabled: true,
		DataManager: {},
		SelectionManager : {}
	};
};


smart.grid.esc_onClick = function(gridObj) {
	// 그리
	gridObj.bind({
		"keypress": function(e) {
			if(e.which==27) {
				gridObj.checkMgr.uncheckAll();
				e.preventDefault();//이벤트메소드로 원래event의 실행을 막는 기능을한다
			}
		}
	});
};

smart.grid.getSumOfColumn = function(gridObj, columnName) {
	var rows = gridObj.dataMgr.all;
	//var cnt = rows.length; 
	var sum = 0;
	
	$.each(rows, function(i) {
		eval("sum += smart.number.parseInt(rows["+i+"]."+columnName+");");
	});
	
	return sum;
};


/***********************************************
 * 랜더러 
 ***********************************************/
/**
 * 카드번호를 포맷팅한다.
 * 사용법 -> rederer:smart.grid.CardNoRenderer
 * @param val
 */
smart.grid.CardNoRenderer = function(val){
	return smart.common.formatCardNumber(val);
};

/**
 * 날짜를 포맷팅한다.
 * 사용법 -> rederer:smart.grid.DateRenderer
 * @param val
 */
smart.grid.DateRenderer = function(val){
	return formatter.date(val);
};

/**
 * 사업자번호를 포맷팅한다.
 * 사용법 -> rederer:smart.grid.BizNoRenderer
 * @param val
 */
smart.grid.BizNoRenderer = function(val){
	return smart.number.formatBizNumber(val);
};

/**
 * 숫자(금액) 포맷을 랜더링한다.
 * 사용법 -> renderer:smart.grid.CurrencyRenderer
 * @param val 
 */
smart.grid.CurrencyRenderer = function(val){
	return formatter.number(val);
};

/**
 * 숫자(건수) 포맷을 랜더링한다.
 * 사용법 -> renderer:smart.grid.CountRenderer
 * @param val 
 */
smart.grid.CountRenderer = function(val){
	return formatter.number(val);
};

/**
 * sumRenderer 용.
 * footer 의 건수합계 포맷을 랜더링 한다.
 * 사용법 -> sumRenderer:smart.grid.CountSumRenderer
 * @param name
 * @param sum
 */
smart.grid.CountSumRenderer = function (name, sum)
{
	return formatter.number(sum);
};

/**
 * sumRenderer 용.
 * footer 의 금액합계 포맷을 랜더링 한다.
 * 사용법 -> sumRenderer:smart.grid.CurrencySumRenderer
 * @param name
 * @param sum
 */
smart.grid.CurrencySumRenderer = function (name, sum)
{
	//var tag = "<span class='title'><strong>%name%</strong> 합계: </span><span class='content'>%sum% 원</span>";
	//return tag.replace(/%name%/g, name).replace(/%sum%/g, jex.web.format.currency(sum));
	//return jex.web.format.currency(sum) + " 원";
	return "\\ " + formatter.number(sum);
};

/**
 * sumRenderer 용.
 * footer 의 금액합계 포맷을 랜더링 한다.
 * 사용법 -> sumRenderer:smart.grid.CurrencySumRenderer
 * @param name
 * @param sum
 */
smart.grid.CurrencyHalfSumRenderer = function (name, sum)
{
	//var tag = "<span class='title'><strong>%name%</strong> 합계: </span><span class='content'>%sum% 원</span>";
	//return tag.replace(/%name%/g, name).replace(/%sum%/g, jex.web.format.currency(sum));
	//return jex.web.format.currency(sum) + " 원";
	return "\\ " + formatter.number(sum / 2);
};

/**
 * sumRenderer 용2
 * 단위를 지정할수있다.
 * denomination 가 number타입으로 입력되면 해당값만큼 곱한값이되고, 문자열로 단위를 입력하면 해당단위로 합계가 표시된다.
 * 사용예 -> sumRenderer:smart.grid.CurrencySumRenderer2(10000) => sum값25일경우, 푸터에 "250,000 원" 으로 표현
 *          sumRenderer:smart.grid.CurrencySumRenderer2("백만원") => sum값이25일경우, 푸터에 "25 백만원" 으로 표현
 */
smart.grid.CurrencySumRenderer2 = function(denomination)
{
	return function (name, sum)
	{
		var _denomination = "원";
		if(denomination)
		{
			if(typeof denomination == "string")
			{
				_denomination = denomination;
			}
			else
			{
				if( isNaN(denomination) ) denomination = 1;
				sum = sum * denomination;
			}
		}
		return smart.grid.CurrencySumRendererTemplet(name, sum, _denomination);
	};
};

/**
 * sumRenderer 템플릿 
 */
smart.grid.CurrencySumRendererTemplet = function(name, sum, denomination)
{
	var tag = "<span class='title'><strong>%name%</strong> 합계: </span><span class='content'>%sum% "+denomination+"</span>";
	return tag.replace(/%name%/g, name).replace(/%sum%/g, formatter.number(sum));
};

/***********************************************
 * 에디터
 ***********************************************/
/**
 * 숫자입력용 에디터
 * 사용예 -> editor:smart.grid.IntegerEditor(), validator:smart.grid.IntegerValidator
 *          ㄴ> 입력값을 반영할때 숫자인지 검증하기위해선 위와같이 validator를 추가해야한다.
 *              validator가 없으면 숫자인지 검증하지 않음
 *              업무별로 입력값검증을 추가하려면 validator를 구현해서 사용하면됨.
 * @param options
 */
smart.grid.IntegerEditor = function(options)
{
	return JGM.create("Editor", {
				 edit: function(){
				 	var s=this.cell.getValue();
//				 	return '<input type="text" style="ime-mode:disabled" onkeydown="javascript:if(!smart.grid.isIntegerKeydown(event)) return false;" value="'+(Util.isNull(s)?"":s)+'"/>';
//				 	return '<input type="text" style="ime-mode:disabled" onkeydown="javascript:if(!smart.grid.isIntegerKeydown(event)) return false;" value="'+(Util.isNull(s)?"":s)+'"/>';
				 	return '<div onfocus="javascript:this.childNodes[0].focus();"><input type="text" style="ime-mode:disabled" value="'+(Util.isNull(s)||s=="0"?"":s)+'" class="basic-editor"/></div>';
			 	}
//				,valid: (!!options&&!!options.valid)?options.valid:function(val, cell) {
//					if(isNaN(val))
//					{
//						jex.web.info("WM0128");
//						return false;
//					}
//					return true;
//				}
				,value:function()
				{
					//사용자 입력값 추출
					//var _val = this.cell.getNode().childNodes[0].value;
					//수정모드시 해당쎌에 우측정렬이 되어있으면 input이 셀을 벗어나는 현상이있어서
					//input을 div로 한번 감싸고 아래처럼 값꺼내도록 함
					var _val = this.cell.getNode().childNodes[0].childNodes[0].value;
					var _tempVal = new Number(_val);
					if( isNaN(_tempVal) )
					{
						return "0";
					}
					else
					{
						return String(_tempVal);
					}
				}
			});
};

/***********************************************
 * 기능함수
 ***********************************************/
/**
 * srcGrid에서 체크된 데이터를 targetGrid로 보내고 srcGrid에선 삭제한다.
 * @param srcGrid
 * @param targetGrid
 */
smart.grid.moveDatalist = function(srcGrid, targetGrid)
{
	var checkedList = srcGrid.checkMgr.getCheckList().slice();
	
	if( checkedList.length == 0 )
	{
		alert("대상을 선택해 주세요");
		return false;
	}

	targetGrid.dataMgr.addList( checkedList );
	srcGrid.dataMgr.removeList( checkedList );
	return true;
};