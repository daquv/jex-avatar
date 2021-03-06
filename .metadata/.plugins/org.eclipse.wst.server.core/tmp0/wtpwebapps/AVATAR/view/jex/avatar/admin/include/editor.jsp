<!--
	다음오픈에디터 사용 튜토리얼은 이 페이지로 대신합니다. 
	추가적인 기능 개발 및 플러그인 개발 튜토리얼은 홈페이지를 확인해주세요.
	작업이 완료된 후에는 주석을 삭제하여 사용하십시요.
	
	다음오픈에디터의 라이선스는 GNU LGPL(Lesser General Public License) 으로
	오픈되어 있는 소스이므로 저작권료 없이 사용이 가능하며, 목적에 맞게 수정하여 사용할 수 있으십니다.
	또한 LGPL에는 수정한 부분의 소스공개를 권장하고 있으나, 강제 사항은 아니므로 공개하지 않으셔도 무방합니다.
	다만 사용하시는 소스 상단 부분에 다음오픈에디터를 사용하셨음을 명시해 주시길 권장 드리며,
	꾸준한 업데이트를 할 예정이니 종종 방문 하셔서 버그가 수정 되고 기능이 추가된 버전들을 다운로드 받아 사용해 주세요.
	
	라이센스 : GNU LGPL(Lesser General Public License)
	홈페이지 : http://code.google.com/p../daumopeneditor/
-->
<%@page contentType="text/html;charset=utf-8"%>
<%@page import="jex.util.StringUtil"%>

 <link rel="stylesheet" href="/admin/daumopeneditor/css/editor.css?20200902113000" type="text/css"  charset="utf-8"/>
 <!-- <script type="text/javascript" charset="utf-8" src="/admin/daumopeneditor/js/editor_loader.js"></script> --> 
<%
	String contentWidth = StringUtil.null2void(request.getParameter("contentWidth"), "500");
	String contentHeight = StringUtil.null2void(request.getParameter("contentHeight"), "200");
%>
<!-- 에디터 컨테이너 시작 -->
<!-- 에디터 시작 -->
<!--
	@decsription 
	등록하기 위한 Form으로 상황에 맞게 수정하여 사용한다. Form 이름은 에디터를 생성할 때 설정값으로 설정한다. 
-->

<div id="tx_trex_container" class="tx-editor-container">
	<!-- 사이드바 -->
	<div id="tx_sidebar" class="tx-sidebar">
		<div class="tx-sidebar-boundary">
			<!-- 사이드바 / 첨부 -->

			<ul class="tx-bar tx-bar-left tx-nav-opt">
				<li class="tx-list tx-bar-left">
					<div unselectable="on" class="tx-switchtoggle" id="tx_switchertoggle">
						<a href="javascript:;" title="에디터 타입">에디터</a>
					</div>
				</li>
			</ul>
  			<ul class="tx-bar tx-bar-left tx-nav-attach">
				<li class="tx-list tx-bar-left">
					<div unselectable="on" id="rm_tx_image" class="tx-image tx-btn-trans">
						<input type="file" size="30" name="ATT_FILE_blbd" class="ATT_FILE" style="height: 23px; display:none;" id="content"/>
						<a href="javascript:;"  title="사진" class="tx-text cmdFileUpload" >사진</a><!-- onclick="fn_cloudFileUpload()" -->
					</div>
				</li>			
			</ul> 
			<!-- 사이드바 / 우측영역 -->
		</div>
	</div>

	
	<div id="tx_toolbar_basic" class="tx-toolbar tx-toolbar-basic">
		<div class="tx-toolbar-boundary">
			<ul class="tx-bar tx-bar-left">
				<li class="tx-list" style="padding-left:3px;">
					<div id="tx_fontfamily" unselectable="on" class="tx-slt-70bg tx-fontfamily">
						<a href="javascript:;" title="글꼴">굴림</a>
					</div>
					<div id="tx_fontfamily_menu" class="tx-fontfamily-menu tx-menu" unselectable="on"></div>
				</li>
			</ul>
			<ul class="tx-bar tx-bar-left">
		 		<li class="tx-list">
					<div unselectable="on" class="tx-slt-42bg tx-fontsize" id="tx_fontsize">
						<a href="javascript:;" title="글자크기">9pt</a>
					</div>
					<div id="tx_fontsize_menu" class="tx-fontsize-menu tx-menu" unselectable="on"></div>
				</li>
			</ul>
			<ul class="tx-bar tx-bar-left tx-group-font"> 
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-lbg 	tx-bold" id="tx_bold">
						<a href="javascript:;" class="tx-icon" title="굵게 (Ctrl+B)">굵게</a>
					</div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-bg 	tx-underline" id="tx_underline">
						<a href="javascript:;" class="tx-icon" title="밑줄 (Ctrl+U)">밑줄</a>
					</div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-bg 	tx-italic" id="tx_italic">
						<a href="javascript:;" class="tx-icon" title="기울임 (Ctrl+I)">기울임</a>
					</div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-bg 	tx-strike" id="tx_strike">
						<a href="javascript:;" class="tx-icon" title="취소선 (Ctrl+D)">취소선</a>
					</div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-slt-tbg 	tx-forecolor" style="background-color:#5c7fb0;" id="tx_forecolor">
						<a href="javascript:;" class="tx-icon" title="글자색">글자색</a>
						<a href="javascript:;" class="tx-arrow" title="글자색 선택">글자색 선택</a>
					</div>
					<div id="tx_forecolor_menu" class="tx-menu tx-forecolor-menu tx-colorpallete" unselectable="on"></div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-slt-brbg 	tx-backcolor" style="background-color:#5c7fb0;" id="tx_backcolor">
						<a href="javascript:;" class="tx-icon" title="글자 배경색">글자 배경색</a>
						<a href="javascript:;" class="tx-arrow" title="글자 배경색 선택">글자 배경색 선택</a>
					</div>
					<div id="tx_backcolor_menu" class="tx-menu tx-backcolor-menu tx-colorpallete" unselectable="on"></div>
				</li>
			</ul>
			<ul class="tx-bar tx-bar-left tx-group-align"> 
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-lbg 	tx-alignleft" id="tx_alignleft">
						<a href="javascript:;" class="tx-icon" title="왼쪽정렬 (Ctrl+,)">왼쪽정렬</a>
					</div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-bg 	tx-aligncenter" id="tx_aligncenter">
						<a href="javascript:;" class="tx-icon" title="가운데정렬 (Ctrl+.)">가운데정렬</a>
					</div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-bg 	tx-alignright" id="tx_alignright">
						<a href="javascript:;" class="tx-icon" title="오른쪽정렬 (Ctrl+/)">오른쪽정렬</a>
					</div>
				</li>
				<li class="tx-list" style="display:none !important;">
					<div unselectable="on" class="		 tx-btn-rbg 	tx-alignfull" id="tx_alignfull">
						<a href="javascript:;" class="tx-icon" title="양쪽정렬">양쪽정렬</a>
					</div>
				</li>
			</ul>
			<ul class="tx-bar tx-bar-left tx-group-tab"> 
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-lbg 	tx-indent" id="tx_indent">
						<a href="javascript:;" title="들여쓰기 (Tab)" class="tx-icon">들여쓰기</a>
					</div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-rbg 	tx-outdent" id="tx_outdent">
						<a href="javascript:;" title="내어쓰기 (Shift+Tab)" class="tx-icon">내어쓰기</a>
					</div>
				</li>
			</ul>
			<ul class="tx-bar tx-bar-left tx-group-list">
				<li class="tx-list">
					<div unselectable="on" class="tx-slt-31lbg tx-lineheight" id="tx_lineheight">
						<a href="javascript:;" class="tx-icon" title="줄간격">줄간격</a>
						<a href="javascript:;" class="tx-arrow" title="줄간격">줄간격 선택</a>
					</div>
					<div id="tx_lineheight_menu" class="tx-lineheight-menu tx-menu" unselectable="on"></div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="tx-slt-31rbg tx-styledlist" id="tx_styledlist">
						<a href="javascript:;" class="tx-icon" title="리스트">리스트</a>
						<a href="javascript:;" class="tx-arrow" title="리스트">리스트 선택</a>
					</div>
					<div id="tx_styledlist_menu" class="tx-styledlist-menu tx-menu" unselectable="on"></div>
				</li>
			</ul>
			<ul class="tx-bar tx-bar-left tx-group-etc">
<!--  
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-lbg 	tx-emoticon" id="tx_emoticon">
						<a href="javascript:;" class="tx-icon" title="이모티콘">이모티콘</a>
					</div>
					<div id="tx_emoticon_menu" class="tx-emoticon-menu tx-menu" unselectable="on"></div>
				</li>
-->
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-lbg 	tx-link" id="tx_link">
						<a href="javascript:;" class="tx-icon" title="링크 (Ctrl+K)">링크</a>
					</div>
					<div id="tx_link_menu" class="tx-link-menu tx-menu"></div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-bg 	tx-specialchar" id="tx_specialchar">
						<a href="javascript:;" class="tx-icon" title="특수문자">특수문자</a>
					</div>
					<div id="tx_specialchar_menu" class="tx-specialchar-menu tx-menu"></div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-bg 	tx-table" id="tx_table">
						<a href="javascript:;" class="tx-icon" title="표만들기">표만들기</a>
					</div>
					<div id="tx_table_menu" class="tx-table-menu tx-menu" unselectable="on">
						<div class="tx-menu-inner">
							<div class="tx-menu-preview"></div>
							<div class="tx-menu-rowcol"></div>
							<div class="tx-menu-deco"></div>
							<div class="tx-menu-enter"></div>
						</div>
					</div>
				</li>
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-rbg 	tx-horizontalrule" id="tx_horizontalrule">
						<a href="javascript:;" class="tx-icon" title="구분선">구분선</a>
					</div>
					<div id="tx_horizontalrule_menu" class="tx-horizontalrule-menu tx-menu" unselectable="on"></div>
				</li>
			</ul>

			<ul class="tx-bar tx-bar-left tx-group-undo" style="display:none !important;"> 
				<li class="tx-list">
					<div unselectable="on" class="		 tx-btn-lbg 	tx-undo" id="tx_undo">
						<a href="javascript:;" class="tx-icon" title="실행취소 (Ctrl+Z)">실행취소</a>
					</div>
				</li>
			</ul> 
			<ul class="tx-bar tx-bar-right">
                <li class="tx-list">
                    <div unselectable="on" class="tx-btn-nlrbg tx-advanced" id="tx_advanced">
                        <a href="javascript:;" class="tx-icon" title="툴바 더보기">툴바 더보기</a>
                    </div>
                </li>

            </ul>
		</div>
	</div>
	<!-- 툴바 - 기본 끝 -->
	<!-- 툴바 - 더보기 시작 -->
    <div id="tx_toolbar_advanced" class="tx-toolbar tx-toolbar-advanced">
    	<div class="tx-toolbar-boundary">
	        <ul class="tx-bar tx-bar-left">
	            <li class="tx-list">
	                <div class="tx-tableedit-title"></div>
	            </li>
	        </ul>
	
	        <ul class="tx-bar tx-bar-left tx-group-align">
	            <li class="tx-list">
	                <div unselectable="on" class="tx-btn-lbg tx-mergecells" id="tx_mergecells">
	                    <a href="javascript:;" class="tx-icon2" title="병합">병합</a>
	                </div>
	                <div id="tx_mergecells_menu" class="tx-mergecells-menu tx-menu" unselectable="on"></div>
	            </li>
	            <li class="tx-list">
	                <div unselectable="on" class="tx-btn-bg tx-insertcells" id="tx_insertcells">
	                    <a href="javascript:;" class="tx-icon2" title="삽입">삽입</a>
	                </div>
	                <div id="tx_insertcells_menu" class="tx-insertcells-menu tx-menu" unselectable="on"></div>
	            </li>
	            <li class="tx-list">
	                <div unselectable="on" class="tx-btn-rbg tx-deletecells" id="tx_deletecells">
	                    <a href="javascript:;" class="tx-icon2" title="삭제">삭제</a>
	                </div>
	                <div id="tx_deletecells_menu" class="tx-deletecells-menu tx-menu" unselectable="on"></div>
	            </li>
	        </ul>
	
	        <ul class="tx-bar tx-bar-left tx-group-align">
	            <li class="tx-list">
	                <div id="tx_cellslinepreview" unselectable="on" class="tx-slt-70lbg tx-cellslinepreview">
	                    <a href="javascript:;" title="선 미리보기"></a>
	                </div>
	                <div id="tx_cellslinepreview_menu" class="tx-cellslinepreview-menu tx-menu"
	                     unselectable="on"></div>
	            </li>
	            <li class="tx-list">
	                <div id="tx_cellslinecolor" unselectable="on" class="tx-slt-tbg tx-cellslinecolor">
	                    <a href="javascript:;" class="tx-icon2" title="선색">선색</a>
	
	                    <div class="tx-colorpallete" unselectable="on"></div>
	                </div>
	                <div id="tx_cellslinecolor_menu" class="tx-cellslinecolor-menu tx-menu tx-colorpallete"
	                     unselectable="on"></div>
	            </li>
	            <li class="tx-list">
	                <div id="tx_cellslineheight" unselectable="on" class="tx-btn-bg tx-cellslineheight">
	                    <a href="javascript:;" class="tx-icon2" title="두께">두께</a>
	
	                </div>
	                <div id="tx_cellslineheight_menu" class="tx-cellslineheight-menu tx-menu"
	                     unselectable="on"></div>
	            </li>
	            <li class="tx-list">
	                <div id="tx_cellslinestyle" unselectable="on" class="tx-btn-bg tx-cellslinestyle">
	                    <a href="javascript:;" class="tx-icon2" title="스타일">스타일</a>
	                </div>
	                <div id="tx_cellslinestyle_menu" class="tx-cellslinestyle-menu tx-menu" unselectable="on"></div>
	            </li>
	            <li class="tx-list">
	                <div id="tx_cellsoutline" unselectable="on" class="tx-btn-rbg tx-cellsoutline">
	                    <a href="javascript:;" class="tx-icon2" title="테두리">테두리</a>
	
	                </div>
	                <div id="tx_cellsoutline_menu" class="tx-cellsoutline-menu tx-menu" unselectable="on"></div>
	            </li>
	        </ul>
	        <ul class="tx-bar tx-bar-left">
	            <li class="tx-list">
	                <div id="tx_tablebackcolor" unselectable="on" class="tx-btn-lrbg tx-tablebackcolor"
	                     style="background-color:#9aa5ea;">
	                    <a href="javascript:;" class="tx-icon2" title="테이블 배경색">테이블 배경색</a>
	                </div>
	                <div id="tx_tablebackcolor_menu" class="tx-tablebackcolor-menu tx-menu tx-colorpallete"
	                     unselectable="on"></div>
	            </li>
	        </ul>
	        <ul class="tx-bar tx-bar-left">
	            <li class="tx-list">
	                <div id="tx_tabletemplate" unselectable="on" class="tx-btn-lrbg tx-tabletemplate">
	                    <a href="javascript:;" class="tx-icon2" title="테이블 서식">테이블 서식</a>
	                </div>
	                <div id="tx_tabletemplate_menu" class="tx-tabletemplate-menu tx-menu tx-colorpallete"
	                     unselectable="on"></div>
	            </li>
	        </ul>
    	</div>
    </div>
    <!-- 툴바 - 더보기 끝 -->	
			
	<!-- 편집영역 시작 -->
	<!-- 에디터 Start -->
	<div id="tx_canvas" class="tx-canvas">
		<div id="tx_loading" class="tx-loading">
			<!-- <div><img src="../daumopeneditor/images/icon/editor/loading2.png" width="113" height="21" align="absmiddle"/>
			</div> -->
		</div>
		<div id="tx_canvas_wysiwyg_holder" class="tx-holder" style="display:block;">
			<iframe id="tx_canvas_wysiwyg" name="tx_canvas_wysiwyg" allowtransparency="true" frameborder="0" style="height:350px !important;"></iframe>
		</div>
		<div class="tx-source-deco">
			<div id="tx_canvas_source_holder" class="tx-holder">
				<textarea id="tx_canvas_source" rows="1" cols="30"></textarea>
			</div>
		</div>
		<div id="tx_canvas_text_holder" class="tx-holder">
			<textarea id="tx_canvas_text" rows="1" cols="30"></textarea>
		</div>	
	</div>
	<!-- 높이조절 Start -->
	<div id="tx_resizer" class="tx-resize-bar">
		<div class="tx-resize-bar-bg"></div>
		<img id="tx_resize_holder" src="/admin/daumopeneditor/images/icon/editor/skin/01/btn_drag01.gif" width="58" height="12" unselectable="on" alt="" />
	</div>

	<!-- 편집영역 끝 -->
	
	
	
	<!-- 첨부박스 시작 -->
	<!-- 파일첨부박스 Start -->
	<div id="tx_attach_div" class="tx-attach-div" >
		<div id="tx_attach_txt" class="tx-attach-txt">파일 첨부</div>
		<div id="tx_attach_box" class="tx-attach-box">
			<div class="tx-attach-box-inner">
				<div id="tx_attach_preview" class="tx-attach-preview"><p></p><img src="/admin/daumopeneditor/images/icon/editor/pn_preview.gif" width="147" height="108" unselectable="on"/>
				</div>
				<div class="tx-attach-main">
					<div id="tx_upload_progress" class="tx-upload-progress"><div>0%</div><p>파일을 업로드하는 중입니다.</p></div>
					<ul class="tx-attach-top">
						<li id="tx_attach_delete" class="tx-attach-delete"><a>전체삭제</a></li>
						<li id="tx_attach_size" class="tx-attach-size">
							파일: <span id="tx_attach_up_size" class="tx-attach-size-up"></span>/<span id="tx_attach_max_size"></span>
						</li>
						<li id="tx_attach_tools" class="tx-attach-tools">
						</li>
					</ul>
					<ul id="tx_attach_list" class="tx-attach-list"></ul>
				</div>
			</div>
		</div>
	</div>
	<!-- 첨부박스 끝 -->
	
</div>				
		
<script type="text/javascript">
function fn_cloudFileUpload(){
	fintech.common.winPop("frm",{"sizeW":"500","sizeH":"200","action":"/filesave_0001_04.act", "target" : "imageUpload"});
}
</script>
		
<script type="text/javascript">	
var _editorSun;	
	//Trex.Tool.Table.__DEFAULT_TABLE_PROPERTY_STR = "cellspacing=\"1\" cellpadding=\"0\" border=\"0\" style=\"border:none;border-collapse:collapse;\"";
	/*-------- 에디터 로드 시작 ----------*/
	var config = {
//	new Editor({
		txHost: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) http://xxx.xxx.com */
		txPath: '/admin/daumopeneditor/', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) /xxx/xxx/ */
		txService: 'sample', /* 수정필요없음. */
		txProject: 'sample', /* 수정필요없음. 프로젝트가 여러개일 경우만 수정한다. */
		initializedId: "", /* 대부분의 경우에 빈문자열 */
		wrapper: "tx_trex_container"+"", /* 에디터를 둘러싸고 있는 레이어 이름(에디터 컨테이너) */
		form: 'EditorForm'+"", /* 등록하기 위한 Form 이름 */
		txIconPath: "/admin/daumopeneditor/images/icon/editor/", /*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
		txDecoPath: "/admin/daumopeneditor/", /*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
		canvas: {
			styles: {
				
				color: "#000000", /* 기본 글자색 */
				fontFamily: "굴림", /* 기본 글자체 */
				fontSize: "9pt", /* 기본 글자크기 */
				backgroundColor: "#fff", /*기본 배경색 */
				lineHeight: "1.5", /*기본 줄간격 */
				padding: "8px" /* 위지윅 영역의 여백 */
				
			}
			, showGuideArea: false
		},
		sidebar: {
			attachbox: {
				show: true							/* 첨부파일박스 disabled */
			},
			attacher:{ 
				image:{ 
					features:{left:250,top:65,width:400,height:190,scrollbars:0}, //팝업창 사이즈 
					popPageUrl:'/view/jex/avatar/admin/include/image.jsp' //팝업창 주소 
				} 
			}
			
		},
		size: {
			//contentWidth: 800,	 				/* 지정된 본문영역의 넓이가 있을 경우에 설정 */
			//contentWidth: <%=contentWidth%>,	 				/* 지정된 본문영역의 넓이가 있을 경우에 설정 */
			contentHeight: 10
		},
		events: {
	        preventUnload: false					/* 페이지 벗어날 때 alert처리 */
	    },
		toolbar: {
			table: {
				tableWidth: 700
			}
		}

	};


    EditorJSLoader.ready(function(Editor) {
    	_editorSun = new Editor(config);
    	
    });
    
   
</script>