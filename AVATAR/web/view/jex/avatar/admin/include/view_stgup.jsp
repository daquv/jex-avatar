<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="jex.util.date.DateTime"%>
<!--
보기설정페이지 include 방법
목록보기설정 클릭하는 a 태그에 id 값 "pageListStg" 주기.
페이지에 탭에 따른 보기 설정이 다를경우 hidden 값으로 PAGE_DSNC 있어야 함.
페이지 호출할때 view_stgup.fn_search(val1, val2) 호출 -val1:div생성 여부 (true,,false), val2:테이블인이 그리드인지 여부 ("TABLE","GRID")
view_stgup.VIEW_SETTING 변수에 보기설정에 관련된 값 담아 둠. 가져가서 페이지에 맞게 사용하면 됨.
테이블 colgroup과 thead 그리는 함수 view_stgup.makeTable(val1, val2, val3, val4) -val1:테이블 ID 값, val2:테이블에 checkbox 사용여부(전체선택 체크박스 ID는 "checkboxAll" 로 생성함, val3:리스트 조회하는 function, val4:라디오버튼 여부
테이블 TBODY TD 그리는 함수 view_stgup.makeTableTbody(data) -data에 한 행의 데이터값 넣어주어야 함 RETURN으로 테이블 그릴수 있는 HTML 넘겨 줌. 받아서 그려야 함.
그리드 columns 값 넘겨주는 함수 view_stgup.gridColumnsVal(val1, val2) -val1:그리드 그려주는 function, val2: 리스트 조회하는 function
-->
<script type="text/javascript" src="/admin/js/include/view_stgup.js?<%=DateTime.getInstance().getDate("YYYYMMDDHH24MI")%>"></script>

<!-- !!!! 테스트 ##################################################### -->

<!-- !!!! 테스트 ##################################################### -->

<div id="page_option_set">
    <div id="option_menu" class="view_set_pop" style="display: none; position: absolute; width: 300px; background: #FFF; z-index: 9999;">
        <!-- 팝업 헤더 -->
        <div class="pop_header">
            <h1>보기설정</h1>
            <a href="javascript:" class="btn_popclose"><img src="/admin/img/btn/btn_popclose.gif" alt="팝업닫기"></a>
        </div>
        <!-- //팝업 헤더 -->

        <!-- 팝업 컨텐츠 -->
        <div class="pop_container">
            <!-- title -->
            <div class="pop_title_wrap">
                <div class="left">
                    <h2 class="bul_2">보이는 필드</h2>
                </div>
                <div class="right">
                    <span id="btnGoLast"><a href="javascript:"><img src="/admin/img/btn/btn_go_last.gif" alt=""></a></span> <span id="btnGoNext"><a href="javascript:"><img src="/admin/img/btn/btn_go_next.gif" alt=""></a></span>
                    <span id="btnGoPrev"><a href="javascript:"><img src="/admin/img/btn/btn_go_prev.gif" alt=""></a></span> <span id="btnGoFirst"><a href="javascript:"><img src="/admin/img/btn/btn_go_first.gif" alt=""></a></span>
                </div>
            </div>
            <!-- //title -->

            <div class="view_setting_lst mgt5">
                <ul id="setUi"></ul>
            </div>

            <!-- 하단버튼 -->
            <div class="t_center">
                <span class="btn_style2_b" id="viewStgSave"><a href="javascript:" style="color: #FFF;">저장</a></span>
                <span class="btn_style2" id="viewStgCancle"><a href="javascript:">취소</a></span>
            </div>
            <!-- //하단버튼 -->

        </div>
        <!-- //팝업 컨텐츠 -->
    </div>
</div>