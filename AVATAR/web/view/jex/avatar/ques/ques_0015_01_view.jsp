<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0015_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김정용 (  )
 * @Description      : 
 * @History          : 20220421203317, 김정용
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0015_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0015_01.js
 * </pre>
 **/
%>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>ASK AVATAR</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
    <%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
    <script type="text/javascript"
            src="/js/jex/avatar/ques/ques_0015_01.js?<%=_CURR_DATETIME%>2"></script>
</head>

<body class="bg_F5F5F5">

<!-- content -->
<div class="content m_cont_pd25">

    <div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 --><!-- 하단에 마이크버튼 있는경우 pdb100 추가 -->
        <!-- 배너 영역 -->
        <div class="banner_slideMN slideMN30 swiper-container">
            <div class="swiper-wrapper">
                <div class="sectMN31 swiper-slide">
                    <div class="sect_inn">
                        <a href="#none"><img src="../img/m_bnnrMN310.png" alt=""></a>
                    </div>
                </div>

            </div>
            <!-- Pagination -->
            <div class="swiper-pagination"></div>
            <!-- Pagination -->
        </div>
        <!-- //배너 영역 -->


        <!-- 전체 질문 보기 -->
        <div class="ai_list_v type4">
            <div class="tit">
                <div class="left">
                    <p>이렇게 물어보세요!</p>
                </div>
                <div class="right"></div>
            </div>

            <ul class="allQues2 type3">
                <li>
                    <dl>
                        <dt>
                            <p><img src="../img/icon_briefing.png" alt="브리핑"></p>
                            <p>브리핑</p>
                        </dt>
                        <dd>
                            <ul>
                                <li><a href=/ques_comm_11.act?INTE_INFO={"recog_txt":"브리핑","recog_data":{"appInfo":{"NE-DETAIL":"브리핑"},"Intent":"IB001"}}&EMN=000001>“브리핑 해줘”</a></li>
                                <li><a href="#">“대출 현황 브리핑 해줘”</a></li>
                                <li><a href="#">“수신 현황 브리핑 해줘”</a></li>
                                <li><a href="#">“외환 현황 브리핑 해줘”</a></li>
                                <li><a href="#">“카드 현황 브리핑 해줘”</a></li>
                                <li><a href="#">“연체 현황 브리핑 해줘”</a></li>
                                <li><a href="#">“뉴스 브리핑 해줘”</a></li>
                            </ul>
                        </dd>
                    </dl>
                </li>
            </ul>
            <ul class="allQues2 type3">
                <li>
                    <dl>
                        <dt>
                            <p><img src="../img/icon_company.png" alt="기업정보"></p>
                            <p>기업정보</p>
                        </dt>
                        <dd>
                            <ul>
                                <li><a href="#">“○○○ 기업 정보는?”</a></li>
                                <li><a href="#">“○○○ 기업 정보 요약해줘”</a></li>
                                <li><a href="#">“○○○ 기업 뉴스 보여줘”</a></li>
                            </ul>
                        </dd>
                    </dl>
                </li>
            </ul>
            <ul class="allQues2 type3 caseTop">
                <li>
                    <dl>
                        <dt>
                            <p><img src="../img/icon_call.png" alt="전화"></p>
                        </dt>
                        <dd>
                            <ul>
                                <li><a href="#">“전화해줘”</a></li>
                                <li><a href="#">“문자보내줘”</a></li>
                            </ul>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <!-- //질의 리스트영역 -->

    </div>

</div>
<!-- //content -->

<!-- (modify)20211022 -->
<script>
    $(document).ready(function(){

        $(".js_controll ul").css({"max-height":"164px","overflow":"hidden"});
        $(".btn_drop.open").click(function(){
            if($(this).hasClass("open")){
                $(this).addClass("close");
                $(this).removeClass("open");
                $(".js_controll ul").css("max-height","100%");
            }else{
                $(this).addClass("open");
                $(this).removeClass("close");
                $(".js_controll ul").css("max-height","164px");
            }
        });

//	var swiper1 = new Swiper('.banner_slide_freQues', {
//		pagination:{
//			el: '.swiper-pagination',
//			clickable: true,
//		},
//		on:{
//			init: function () {
//			const numberOfSlides = this.slides.length;
//				if(numberOfSlides == 1){
//					$(this).find(".swiper-pagination").hidden();
//				}
//			}
//		}
//	});

        var swiper = new Swiper('.banner_slideMN', {
            pagination:{
                el: '.swiper-pagination',
                clickable: true,
            },
            autoplay:{
                delay:2000,
            },
        });
        $(".swiper-pagination-bullet:only-child").css({"visibility":"hidden"});

        /* (add)20210929 */
        var limite = 5;
        $('.askAvatar_sub2 ul li').each(function(i){
            if(i > limite-1){
                $('.askAvatar_sub2 ul li').eq(i).hide();
            }
        })
        $(".askAvatar_sub2 .bt_more").click(function(){
            $(".askAvatar_sub2 .bt_more span").toggleClass("fold");
            $('.askAvatar_sub2 ul li').each(function(i){
                if(i > limite-1){
                    $('.askAvatar_sub2 ul li').eq(i).toggle();
                }
            });
        });
        var limite2 = 3;
        $('.js_limite').each(function(a){
            $('.js_limite').eq(a).find("li").each(function(i){
                if(i > limite2-1){
                    $('.js_limite').eq(a).find("li").eq(i).hide();
                }
            });
        });

        $(".bt_more").click(function(){
            var thisPrev = $(this).prev();
            $(this).toggleClass("close");
            $(this).prev().find("li").each(function(i){
                if(i > limite2-1){
                    thisPrev.find("li").eq(i).toggle();
                }
            });
        });
        /* //(add)20210929 */
    })
</script>
<!-- //(modify)20211022 -->

</body>
</html>