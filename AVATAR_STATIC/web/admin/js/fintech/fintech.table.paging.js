$.fn.tablePaging = function( table_id, fn_getDat, callback, pageNo, pageSz, pagingSizeYn, cntsId ) {
    var _paging_draw_area = this;                      // 

    var pageIndex    = pageNo;
    var pageSize     = pageSz;
    var totalCnt     = "0";
    var maxPageView  = "10";
    var param        = {};

    var paging = {
    	initPage : function() {
    		param     = {};
    		pageIndex = "1";
    		totalCnt  = "0";
    	},
        setPaging : function(rec) {
        	var paginationHtml  = "";
        	pageSize = Number(this.getPageSz());
            var lastPageIndex   = Math.ceil(totalCnt/pageSize);
            var startPage       = 1 + Number(maxPageView) * Math.floor((pageIndex -1) / Number(maxPageView));
            var endPage         = startPage + (Number(maxPageView) - 1);
            if(endPage > lastPageIndex) endPage = lastPageIndex;
            var pageBlockCnt    = Math.ceil(lastPageIndex/maxPageView);
            var currentBlock    = Math.ceil(pageIndex/maxPageView);

            $(".paging").empty();

            // 처음으로 & 이전페이지 블럭
            if(currentBlock == 1) {
                paginationHtml += '<a href="javascript:void(0);" class="btn_pag_cntr first"><span class="blind">first</span></a>';
                paginationHtml += '<a href="javascript:void(0);" class="btn_pag_cntr prev"><span class="blind">previous</span></a>';
            } else {
                paginationHtml += '<a href="javascript:void(0);" class="pagingBtn btn_pag_cntr first on" data-page-no="1"><span class="blind">first</span></a>';
                paginationHtml += '<a href="javascript:void(0);" class="pagingBtn btn_pag_cntr prev on" data-page-no="'+(currentBlock*Number(maxPageView)-Number(maxPageView)+1-Number(maxPageView))+'"><span class="blind">previous</span></a>';
            }

            paginationHtml += '<span class="pag_num">';
            for(i=startPage; i<=endPage; i++) {
                if(i == Number(pageIndex)) {
                    paginationHtml += '<a href="javascript:void(0);" data-page-no="'+i+'" class="on">'+i+'</a>';
                } else {
                    paginationHtml += '<a href="javascript:void(0);" data-page-no="'+i+'" class="pagingBtn">'+i+'</a>';
                }
            }
            paginationHtml += '</span>';

            // 다음페이지 블럭 & 마지막 페이지
            if(pageBlockCnt == currentBlock) {
            	paginationHtml += '<a href="javascript:void(0);" class="btn_pag_cntr next"><span class="blind">next</span></a>';
            	paginationHtml += '<a href="javascript:void(0);" class="btn_pag_cntr last"><span class="blind">last</span></a>';
            } else {
            	paginationHtml += '<a href="javascript:void(0);" class="pagingBtn btn_pag_cntr next on" data-page-no="'+(currentBlock*Number(maxPageView)-Number(maxPageView)+1+Number(maxPageView))+'"><span class="blind">next</span></a>';
            	paginationHtml += '<a href="javascript:void(0);" class="pagingBtn btn_pag_cntr last on" data-page-no="'+lastPageIndex+'"><span class="blind">last</span></a>';
            }

            if(rec != null && rec != undefined && rec.length > 0) {
            	$(".paging").empty().append(paginationHtml);
            }

        	$(".paging").find(".pagingBtn").on("click", function() {
            	var movePageNo = $(this).attr("data-page-no");
            	if($.isFunction(fn_getDat))
				{
					fn_getDat(movePageNo);
				}
            });

        	if($.isFunction(callback))
			{
				try {
					$("#"+table_id).find("tbody > *").remove();
				} catch(e) {
					
				}
				if(rec != null && rec != undefined && rec.length > 0) {
					callback( $("#"+table_id), rec.slice(0, rec.length));
				} else {
					callback( $("#"+table_id), []);
				}
			}
        },
        setTotDataSize : function(cnt) {
        	totalCnt = cnt;
        },
        getPageSz : function() {
        	pageSize = $("[data-pageSezie]").eq(0).attr("data-pageSezie");
        	return pageSize;
        },
        getPageNo : function() {
        	return pageIndex;
        },
        getStartIdx : function(index) {
        	return ""+(index * Number(this.getPageSz()) - (Number(this.getPageSz())-1));
        },
        getEndIdx : function(index) {
        	return ""+index*Number(this.getPageSz());
        },
        setPageNo : function(pageNo) {
        	pageIndex = pageNo;
        },
        setParam : function(jexAjax, pageno) {
        	if(pageno == 1) {
        		param = jexAjax;
        	}
        },
        getParam : function(val, defVal) {
        	
        	if(param == null || param == undefined || param["input"] == null || param["input"] == undefined || param["input"][val] == null || param["input"][val] == undefined) {
        		return defVal;
        	}

        	return param.get(val);
        }
    };

    setPageSize(pageSz, fn_getDat);

    return paging;
};

function setPageSize(pageSz, fn_getDat) {
    var html = "";
    html += "<div class=\"combo_wrap\">";
	html += "	<div class=\"combo_style\">";
	html += "		<a href=\"javascript:void(0);\" class=\"btn_style btn_combo_down\"><span id=\"pageSize\" data-pageSezie=\""+pageSz+"\">"+pageSz+"</span></a>";
	html += "		<ul id=\"pagesizeList\" style=\"display:none;\">";
	html += "			<li><a href=\"javascript:void(0);\" class=\"pageSizeList\" data-count=\"15\">15개</a></li>";
	html += "			<li><a href=\"javascript:void(0);\" class=\"pageSizeList\" data-count=\"20\">20개</a></li>";
	html += "			<li><a href=\"javascript:void(0);\" class=\"pageSizeList\" data-count=\"30\">30개</a></li>";
	html += "			<li><a href=\"javascript:void(0);\" class=\"pageSizeList\" data-count=\"50\">50개</a></li>";
	html += "		</ul>";
	html += "	</div>";
	html += "</div>";

	$(".n_paging_size").children().remove();
	$(".n_paging_size").append($(html));

	$(".n_paging_size").find(".btn_combo_down").on("click", function() {
		if($(".n_paging_size").find("#pagesizeList").is(":hidden")) {
			$(".n_paging_size").find("#pagesizeList").show();
		} else {
			$(".n_paging_size").find("#pagesizeList").hide();			
		}
	});

	$(".n_paging_size").find(".pageSizeList").on("click", function() {
		$(".n_paging_size").find(".btn_combo_down").html("<span id=\"pageSize\" data-pageSezie=\""+$(this).attr("data-count")+"\">"+$(this).attr("data-count")+"</span>");
		$(".n_paging_size").find("#pagesizeList").hide();
    	if($.isFunction(fn_getDat))
		{
			fn_getDat();
		}
	});
}

/**
 * 빈 행 만드는 함수 
 * @param trCnt        : 빈 행의 개수
 * @param recLength    : rec 길이  
 */
function getTempTr(colCnt, trCnt, recLength, aTrHeight){
    var tempTd = "";
    var trHtml = ""; 
    var trHeight = 25;
    
    if(null != aTrHeight && undefined != aTrHeight){
        trHeight = aTrHeight;
    }
    
    if(recLength > 0){
        trCnt = trCnt - recLength;
    }else{
        //
        if(trCnt < 1) trCnt = 10;
        $(".paging").hide();            // 페이징 숨김
    }
    
    for(var j=0; colCnt>j; j++){
        tempTd += "<td></td>";
    }
    
    for(var i=0; trCnt>i; i++){
        
        trHtml += "<tr style='height:"+trHeight+"px;'>"+tempTd+"</tr>";
        // trHtml += "<tr >"+tempTd+"</tr>";
    }
    
    return trHtml;
}
