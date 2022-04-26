var view_stgup={};
var popDiv = true;
//view_stgup.pageUrl = parent.$("#ifrm_page").attr("src").split(".")[0];

new (Jex.extend({
    onload:function() {
    	$(document).click(function() {
    		$("#option_menu").css("display","none");
		}); 
		$(document).on("click", "#option_menu, #pageListStg", function(e) {
			e.stopPropagation(); 
		});
    }, event:function() {
        //--- define event action ---//
        this.addEvent('#pageListStg', 'click', function(){
            view_stgup.option_menu_view();
        });
        // 저장
        this.addEvent('#viewStgSave', 'click', function(){
            view_stgup.fn_save();
        });
        // 취소
        this.addEvent('#viewStgCancle', 'click', function(){
            $("#option_menu").css("display","none");
        });

        this.addEvent('.btn_popclose', 'click', function(){
            $("#option_menu").css("display","none");
        });

        $('#btnGoLast').click(function(){
            var setLi=$('#setUi').find('li').filter(".on");
            if(setLi.length==0) return false;
            $("#setUi").append(setLi);
        });

        $('#btnGoFirst').click(function(){
            var setLi=$('#setUi').find('li').filter(".on");
            if(setLi.length==0) return false;
            $("#setUi").prepend(setLi);
        });

        $('#btnGoNext').click(function(){
            var setLi=$('#setUi').find('li').filter(".on");
            if(setLi.length==0) return false;
            setLi.nextAll(".liDisplay:first").after(setLi);
        });

        $('#btnGoPrev').click(function(){
            var setLi=$('#setUi').find('li').filter(".on");
            if(setLi.length==0) return false;
            setLi.prevAll(".liDisplay:first").before(setLi);
        });
    }
}))();

view_stgup.option_menu_view = function(){
    popDiv = true;
    if($("#option_menu").css("display")=="none"){
        $("#option_menu").css("display","");
        fintech.common.moveLayer($("#pageListStg"), $("#option_menu"), "left");
    }else{
        $("#option_menu").css("display","none");
    }
};
view_stgup.fn_save = function(){
    var liSize = $('#setUi input').length;
    var jsonLineRECS  = []; //현재화면 재구성용
    var jsonLineREC   = null; //현재화면 재구성용
    var jsonLineRECS2  = []; //쿠키저장용
    var jsonLineREC2   = null; //쿠키저장용
    $.each($('#setUi input'),function(i){
        jsonLineREC = {};
        jsonLineREC2 = {};
        
        jsonLineREC["OTPT"]          = i+1;
        jsonLineREC["USE_YN"]        = $(this).is(':checked')?'Y':'N';
        jsonLineREC["VIEW_ID"]       = $(this).attr("viewId");
        jsonLineREC["VIEW_NM"]       = $(this).attr("viewNm");
        jsonLineREC["MDTY_YN"]       = $(this).attr("MdtyYn");
        jsonLineREC["DISPLAY_YN"]    = $(this).attr("displayYn");
        jsonLineREC["VIEW_CRE_INFM"] = $(this).attr("viewCreInfm");
        jsonLineREC["FORMATTER"]     = $(this).attr("formatter");
        jsonLineREC["CODE"]          = $(this).attr("code");
        jsonLineREC["ONCLICK"]       = $(this).attr("onclickclass");
        jsonLineREC["ONCLICKDATA"]   = $(this).attr("onclickdata");
        jsonLineREC["ONCLICKYN"]  	 = $(this).attr("onclickyn");
        jsonLineREC["VIEW_CLASS"]    = $(this).attr("viewClass");
        jsonLineREC["VIEW_STYLE"]    = $(this).attr("viewStyle");
        jsonLineREC["TITLE_YN"]      = $(this).attr("titleYn");


        jsonLineREC2["OTPT"]          = i+1;
        jsonLineREC2["USE_YN"]        = $(this).is(':checked')?'Y':'N';
        jsonLineRECS.push(jsonLineREC);
        jsonLineRECS2.push(jsonLineREC2);
    });

    // 쿠키저장
    try {
    	$.cookie(location.href, null);
    	$.cookie(location.href, JSON.stringify(jsonLineRECS2));
    } catch(e) {
    }

    $("#option_menu").css("display","none");
    //view_stgup.fn_search(false, false, jsonLineRECS);
    //view_stgup.fn_search(false);
    view_stgup.fn_search(false, false, jsonLineRECS);
    

    if(view_stgup.makeGb=="TABLE") {
        view_stgup.makeTable(view_stgup.tableId, view_stgup.checkBox, view_stgup.searchFn, view_stgup.radio, view_stgup.addColunm);
    } else {
        if($.isFunction(view_stgup.makeGridFn)) {
            view_stgup.makeGridFn();
        }
    }

    if($.isFunction(view_stgup.searchFn)) {
        view_stgup.searchFn();
    }
};

view_stgup.fn_search = function(viewMake, makeGb, list) {
    if(makeGb) view_stgup.makeGb=makeGb;
    var tmpList = [];
    /*
    // 쿠키 정보 존재시 쿠키정보로 처리함
    if($.cookie(location.href) != null && $.cookie(location.href) != undefined) {
    	try {
    		list = JSON.parse($.cookie(location.href));
    	} catch(e) {
    	}
    }
    */
    // 쿠키 정보 존재시 필요헤더정보만 쿠키정보로 처리함(쿠키크기 제한으로 조치)
    if($.cookie(location.href) != null && $.cookie(location.href) != undefined) {
    	try {
    		tmpList = JSON.parse($.cookie(location.href));
    		if (tmpList.length > 0) {
    			$.each(tmpList, function(i,v){
    				list[i]["OTPT"] = v.OTPT;
    				list[i]["USE_YN"] = v.USE_YN;
    			});
    		}
    	} catch(e) {
    	}
    }

    var addHtml='';
    view_stgup.VIEW_SETTING=[];
    $.each(list, function(i,v){
        var returnCheck="";
        if(v.DISPLAY_YN=="N") {
            returnCheck=" style='display:none;' ";
        }
        //alert(JSON.stringify(v));
        if(v.MDTY_YN=="Y"){
            if(viewMake) addHtml += "<li "+(returnCheck==""?"class=\"dis liDisplay\"":returnCheck)+"><div style=\"width:100%;\"><input type=\"checkbox\" id=\"viewOtpt"+(i+1)+"\" viewId=\""+fintech.common.null2void(v.VIEW_ID)+"\" "+(v.USE_YN=="Y"?"checked=\"checked\"":"")+" "+(v.MDTY_YN=="Y"?"disabled=\"disabled\"":"")+" value=\"Y\" MdtyYn=\"" + fintech.common.null2void(v.MDTY_YN) + "\" viewNm=\"" + fintech.common.null2void(v.VIEW_NM) + "\" displayYn=\"" + fintech.common.null2void(v.DISPLAY_YN) + "\" viewCreInfm=\""+fintech.common.null2void(v.VIEW_CRE_INFM)+"\" formatter=\"" + fintech.common.null2void(v.FORMATTER) + "\" code=\"" + fintech.common.null2void(v.CODE) + "\" onclickclass=\"" + fintech.common.null2void(v.ONCLICK) + "\" onclickdata=\"" + fintech.common.null2void(v.ONCLICKDATA) + "\" viewClass=\"" + fintech.common.null2void(v.VIEW_CLASS) + "\" viewStyle=\"" + fintech.common.null2void(v.VIEW_STYLE) + "\" titleYn=\"" + fintech.common.null2void(v.TITLE_YN) + "\" title=\"" + fintech.common.null2void(v.VIEW_TITLE) + "\" />" + fintech.common.null2void(v.VIEW_NM) + "</div></li>";
        }else{
            if(viewMake) addHtml += "<li "+(returnCheck==""?"class=\"liDisplay\"":returnCheck)+"><div style=\"width:100%;\"><input type=\"checkbox\" id=\"viewOtpt"+(i+1)+"\" viewId=\""+fintech.common.null2void(v.VIEW_ID)+"\" "+(v.USE_YN=="Y"?"checked=\"checked\"":"")+" "+(v.MDTY_YN=="Y"?"disabled=\"disabled\"":"")+" value=\"Y\" MdtyYn=\"" + fintech.common.null2void(v.MDTY_YN) + "\" viewNm=\"" + fintech.common.null2void(v.VIEW_NM) + "\" displayYn=\"" + fintech.common.null2void(v.DISPLAY_YN) + "\" viewCreInfm=\""+fintech.common.null2void(v.VIEW_CRE_INFM)+"\" formatter=\"" + fintech.common.null2void(v.FORMATTER) + "\" code=\"" + fintech.common.null2void(v.CODE) + "\" onclickclass=\"" + fintech.common.null2void(v.ONCLICK) + "\" onclickdata=\"" + fintech.common.null2void(v.ONCLICKDATA) + "\" viewClass=\"" + fintech.common.null2void(v.VIEW_CLASS) + "\" viewStyle=\"" + fintech.common.null2void(v.VIEW_STYLE) + "\" titleYn=\"" + fintech.common.null2void(v.TITLE_YN) + "\" title=\"" + fintech.common.null2void(v.VIEW_TITLE) + "\" />" + fintech.common.null2void(v.VIEW_NM) + "</div></li>";
        }

        if(returnCheck!="") return true;
        view_stgup.VIEW_SETTING.push(v);
    });

    if(viewMake){
        $('#setUi').find("li").remove();
        $('#setUi').append(addHtml);
    }

    if(viewMake) view_stgup.field_move();
};

view_stgup.field_move = function(){
    $('#setUi li').click(function(){
        $('#setUi').find('li').removeClass("on");
        $(this).addClass("on");
    });

};

view_stgup.makeTable = function(tableId, checkBox, searchFn, radio, addColunm){
    $("#"+tableId).find("colgroup").find("col").remove();
    $("#"+tableId).find("thead").find("tr").find("th").remove();
    $("#"+tableId).find("tbody").find("tr").remove();
    view_stgup.tableId=tableId;
    view_stgup.checkBox=checkBox;
    view_stgup.searchFn=searchFn;
    view_stgup.radio=radio;
    view_stgup.addColunm = addColunm;
    var tableColgroup="";
    var tableThead="";
    if(checkBox){
        tableColgroup+="<col style=\"width:30px;\" />";
        tableThead+="<th scope=\"col\"><div><input type=\"checkbox\" id=\"checkboxAll\"/></div></th>";
    }else if(radio){
        tableColgroup+="<col style=\"width:30px;\" />";
        tableThead+="<th scope=\"col\"><div></div></th>";
    }
    $.each(view_stgup.VIEW_SETTING,function(i,v){
        if(v.USE_YN=="Y"){
            tableColgroup+="<col "+v.VIEW_STYLE+" />";
            //tableThead+="<th scope=\"col\""+(fintech.common.null2void(v.VIEW_CLASS)==""?"":" class=\""+v.VIEW_CLASS+"\"")+"><div>"+v.VIEW_NM+"</div></th>";
            tableThead+="<th scope=\"col\" class=\""+v.VIEW_CLASS+"\"><div>"+v.VIEW_NM+"</div></th>";
        }
    });

    if(addColunm == null || addColunm == undefined || addColunm == true) {
        tableColgroup+="<col />";
        tableThead+="<th scope=\"col\"><div></div></th>";
    }

    $("#"+tableId).find("colgroup").append(tableColgroup);
    $("#"+tableId).find("thead").find("tr").append(tableThead);

};

view_stgup.gridColumnsVal = function(makeGridFn,searchFn){

    view_stgup.makeGridFn=makeGridFn;
    view_stgup.searchFn=searchFn;
    var gridColumns=[];
    $.each(view_stgup.VIEW_SETTING,function(j,k){
        if(k.USE_YN=="Y"){
            if(fintech.common.null2void(k.VIEW_CRE_INFM)==""){
                gridColumns.push({key:k.VIEW_ID,name:k.VIEW_NM,width:Number(k.VIEW_STYLE),colClass:k.VIEW_CLASS});
            }else{
                var gridColumnsOption=eval("["+k.VIEW_CRE_INFM+"]");
                gridColumns.push(gridColumnsOption[0]);
            }
        }
    });
    return gridColumns;
};

view_stgup.makeTableTbody = function(data,idx) {
    var thCnt = $("#"+view_stgup.tableId).find("thead").find("th").length;
    var tdCnt = 0;
    var tableTd="";
    
    
    $.each(view_stgup.VIEW_SETTING,function(j,k) {
    	
        if(k.USE_YN=="Y") {
            tdCnt++;
            if(fintech.common.null2void(k.VIEW_CRE_INFM) == "") {
                var orgDat = "";
                var dat = fintech.common.null2void(data[k.VIEW_ID]);
                
                var clickdata = "";
                if (fintech.common.null2void(k.TITLE_YN) == "Y") {
                	orgDat = " title='"+(fintech.common.null2void(data[k.VIEW_ID])=="" ? "" : formatter.phone(data[k.VIEW_ID]))+"'";
                }
                if(fintech.common.null2void(k.FORMATTER) != "") {
                    dat = eval(k.FORMATTER + "('" + data[k.VIEW_ID] + "');");
                }
                if(fintech.common.null2void(k.CODE) != "") {
                    dat = eval(k.CODE + "['"+data[k.VIEW_ID]+"'];");
                }
                if(fintech.common.null2void(k.ONCLICK) != "") {
                    if(fintech.common.null2void(k.ONCLICKDATA) != "") {
                        var arrSetData = k.ONCLICKDATA.split(",");
                        for(var idx=0; idx<arrSetData.length; idx++) {
                            var d = fintech.common.null2void(data[arrSetData[idx]]);
                            clickdata += " data-" + arrSetData[idx] + "='" + d + "'";
                        }
                    }
                    if(fintech.common.null2void(dat) != "") {
                    	if(fintech.common.null2void(k.ONCLICKYN) != ""){
                    		var onclickyn = data[k.ONCLICKYN];
                    		if(onclickyn != "N"){
                    			dat = "<a class=\""+fintech.common.null2void(k.ONCLICK)+"\" href=\"javascript:void(0);\" " + clickdata + "><font color=\"blue\" style=\"text-decoration:underline\">" + dat + "</font></a>";
                    		}
                    	}else{
                    		dat = "<a class=\""+fintech.common.null2void(k.ONCLICK)+"\" href=\"javascript:void(0);\" " + clickdata + "><font color=\"blue\" style=\"text-decoration:underline\">" + dat + "</font></a>";
                    	}
                    }
                }
                
                tableTd+="<td "+(fintech.common.null2void(k.VIEW_CLASS)==""?"":" class='"+k.VIEW_CLASS+"'")+orgDat+"><div><span>"+fintech.common.null2void(dat)+"</span></div></td>";
            } else {
                tableTd+=eval(k.VIEW_CRE_INFM);
            }
        }
    });
    
    if(view_stgup.radio) tdCnt++;
    if(view_stgup.checkBox) tdCnt++;
    if(view_stgup.addColunm != null && view_stgup.addColunm != undefined && view_stgup.addColunm == false) {
    	
    	
        for(var idx=0; idx<thCnt-tdCnt; idx++) {
            tableTd+="<td><div></div></td>";
        }
    }
    return tableTd;
};