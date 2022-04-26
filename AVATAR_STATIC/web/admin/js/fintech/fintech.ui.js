var fintech;
var contentId = location.search.split("=")[1];

if(!fintech) fintech={};

if(!fintech.ui) {
    fintech.ui={};
    /**
     * 페이징처리
     * @param  div_id		페이징 표시할 요소 id
     * @param  callback		페이징 표시 후 실행될 함수
     * @param  curPageNo	현재페이지 번호
     * @param  totPage		전체페이지 번호
     */
    fintech.ui.drawTablePaing = function( div_id, callback, curPageNo, totRec/*totPage*/, recPerPage/*input_page_size*/,detailInput) {
        var page_size = 10; //표시할 페이지 수
        var totPage = Math.ceil(totRec/recPerPage);
        var currentPage  = (curPageNo)?curPageNo:1;
        if(parseInt(currentPage) < 1) currentPage = 1;
        if(parseInt(currentPage) > parseInt(totPage)) currentPage = totPage;
        var lastBlock    = Math.ceil(totPage/page_size);
        var currentBlock = Math.ceil(currentPage/page_size);
        var firstPage     = currentBlock*page_size-page_size+1;
        var lastPage      = currentBlock*page_size;

        $("#"+div_id).children().remove();
        $("#"+div_id).prev(".combo_wrap").show();
        if(totPage > 0){

            var firstHtml = "<a id='paging_first' href='javascript:' class='btn_pag_cntr first'><span class='blind'>first</span></a>";
            var prevHtml  = "<a id='paging_pre' href='javascript:' class='btn_pag_cntr prev'><span class='blind'>previous</span></a>";
            var nextHtml  = "<a id='paging_next' href='javascript:' class='btn_pag_cntr next'><span class='blind'>next</span></a>";
            var lastHtml  = "<a id='paging_last' href='javascript:' class='btn_pag_cntr last'><span class='blind'>last</span></a>";
            var pageHtml  = "<span class='pag_num'>";
            var countNum=0;

            for(var i = firstPage; i <= lastPage && i <= totPage;  i++){
                if(currentPage == i){
                    pageHtml += "<a class='on'>"+i+"</a>";
                }else{
                    pageHtml += "<a>"+i+"</a>";
                }
            }
            pageHtml += " </span>";

            $("#"+div_id).append(firstHtml);
            $("#"+div_id).append(prevHtml);
            $("#"+div_id).append(pageHtml);
            $("#"+div_id).append(nextHtml);
            $("#"+div_id).append(lastHtml);

            if(currentBlock != 1){
                $("#paging_first").addClass("on");
            }

            if(currentBlock != lastBlock){
                $("#paging_last").addClass("on");
            }

            if(currentPage != 1){
                $("#paging_pre"  ).addClass("on");
            }

            if(currentPage != totPage){
                $("#paging_next").addClass("on");
            }

        }else{
            $("#"+div_id).prev(".combo_wrap").hide();
        }


        var input = {};
        $("#"+div_id).find("#paging_first").click(function(){
            $(".layertype1").hide();
            if($(this).hasClass("on")==false){ return false;}

            if($.isFunction(callback)){
                if(detailInput==null) {
                    input["PG_NO"] = "1";
                    input["PAGE_NO"] = "1";
                    callback(input);
                }else{
                    detailInput["PG_NO"] = "1";
                    detailInput["PAGE_NO"] = "1";
                    callback(detailInput);
                }
            }
        });
        $("#"+div_id).find("#paging_pre").click(function(){
            $(".layertype1").hide();
            if($(this).hasClass("on")==false){ return false;}

            currentPage = Number(currentPage)-1;

            if(currentPage < 0) currentPage = 1;
            if($.isFunction(callback)){
                if(detailInput==null) {
                    input["PG_NO"] = currentPage.toString();
                    input["PAGE_NO"] = currentPage.toString();
                    callback(input);
                }else{
                    detailInput["PG_NO"] = currentPage.toString();
                    detailInput["PAGE_NO"] = currentPage.toString();
                    callback(detailInput);
                }
            }
        });
        $("#"+div_id).find("#paging_next").click(function(){
            $(".layertype1").hide();
            if($(this).hasClass("on")==false){ return false;}

            currentPage = Number(currentPage)+1;

            if(currentPage > totPage){
                currentPage = totPage;
            }

            if($.isFunction(callback)){
                if(detailInput==null) {
                    input["PG_NO"] = currentPage.toString();
                    input["PAGE_NO"] = currentPage.toString();
                    callback(input);
                }else{
                    detailInput["PG_NO"] = currentPage.toString();
                    detailInput["PAGE_NO"] = currentPage.toString();
                    callback(detailInput);
                }
            }
        });
        $("#"+div_id).find("#paging_last").click(function(){
            $(".layertype1").hide();
            if($(this).hasClass("on")==false){ return false;}

            if($.isFunction(callback)){
                if(detailInput==null) {
                    input["PG_NO"] = totPage.toString();
                    input["PAGE_NO"] = totPage.toString();
                    callback(input);
                }else{
                    detailInput["PG_NO"] = totPage.toString();
                    detailInput["PAGE_NO"] = totPage.toString();
                    callback(detailInput);
                }
            }
        });
        $("#"+div_id).find(".pag_num a").click(function(){
            $(".layertype1").hide();
            if($(this).hasClass("on")==true){ return false;}

            currentPage = $(this).html();

            if($.isFunction(callback)){
                if(detailInput==null) {
                    input["PG_NO"] = currentPage;
                    input["PAGE_NO"] = currentPage;
                    callback(input);
                }else{
                    detailInput["PG_NO"] = currentPage;
                    detailInput["PAGE_NO"] = currentPage;
                    callback(detailInput);
                }
            }
        });

        $("#"+div_id).prev(".combo_wrap").find(".combo_style").click(function(e){
            $(this).find("ul").toggle();
            //Keeps the rest of the handlers from being executed
            e.stopImmediatePropagation();
        });

        $("#"+div_id).prev(".combo_wrap").find("ul li").click(function(e){
            $("#"+div_id).parents(".paging_wrap").find(".combo_style ul").hide();
            if($(".paging_wrap").find(".btn_combo_down span").text() != $(this).text()){
                $(".paging_wrap").find(".btn_combo_down span").text($(this).text());
                if(!(contentId == 'undefined' || contentId == null || contentId == "" || contentId == undefined)) {
                    $.cookie("PAGE_SIZE_"+contentId, Number($.trim($(this).text()).replace(/[^0-9]/gi, '')) ,{expires:20*365});
                }
                callback();
            }
            e.stopImmediatePropagation();
        });

        $("body").click(function(e){
            var _target = $(e.target);
            if(!_target.parents().is('.combo_wrap') && !_target.is('.btn_combo_down')){
                $("#"+div_id).parents(".paging_wrap").find(".combo_style ul").hide();
            }
        });
    };
}