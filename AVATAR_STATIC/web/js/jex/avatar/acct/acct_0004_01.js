/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : acct_0004_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/acct
 * @author         : 박지은 (  )
 * @Description    : 계좌등록완료 화면
 * @History        : 20210121093849, 박지은
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	
	//확인버튼
	$("#c_enter").on("click",function(){
		fn_back();
	});
	
	//데이터 가져오기 버튼
	$("#a_enter").on("click",function(){
		fn_confirm();
	});
});

var _thisPage = {
		onload : function(){
			iWebAction("changeTitle",{"_title" : "은행데이터 가져오기","_type" : "4"});
			
			_thisPage.searchData();
		},
		searchData : function(){
			avatar.common.callJexAjax("acct_0004_01_r001","",_thisPage.searchCallback);
		},
		searchCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			
			var ACCT_LIST = eval(data.REC_ACCT_LIST);
			var rslt_msg = "";
			
			// 계좌 목록
			if(ACCT_LIST.length>0){
				var acctHtml = "";
				var acctTitHtml = "";
				var bfBankNm = "";
				var acct_dv = "";
				var succ_cnt = 0;
				var succYn = "N";
				
				$.each(ACCT_LIST, function(i,v){
					if(v.ACCT_DV == "01"){
						acct_dv = "입출금";
					}else if(v.ACCT_DV == "02"){
						acct_dv = "예적금";
					}else if(v.ACCT_DV == "03"){
						acct_dv = "대출금";
					}
					
					acctHtml += "<div class=\"card\">";
					acctHtml += "	<h3>";
					acctHtml += "		<span class=\"tx_cate\">["+acct_dv+"]</span>";
					acctHtml += "		<span class=\"tx_cateNum\">"+v.FNNC_RPSN_INFM+"</span>";
					acctHtml += "	</h3>";
					acctHtml += "	<div class=\"right\">";
					// 등록 성공
					if(v.REG_YN == "Y"){
						acctHtml += "		<span class=\"tx_succ\">성공</span>";
						succ_cnt++;
						succYn = "Y";
					}
					// 등록 실패
					else{
						acctHtml += "		<span class=\"tx_fail2\">실패</span>";
					}
					acctHtml += "	</div>";
					acctHtml += "</div>";
					
					if(bfBankNm == v.BANK_NM){
						if($("ul:last").attr("dv-BANK_NM") == v.BANK_NM){
							$(".sub:last").append(acctHtml);
							$(".cnt:last").text(Number($(".cnt:last").text())+1);
							acctHtml = "";
						}
					}else if( bfBankNm != v.BANK_NM || i == (ACCT_LIST.length-1)){
						acctTitHtml +="<div class=\"impBankData_lst\">";
						acctTitHtml +="	<ul dv-BANK_NM='"+v.BANK_NM+"'>";
						acctTitHtml +="		<li>";
						acctTitHtml +="			<div class=\"tit\">";
						acctTitHtml +="				<h2>";
						acctTitHtml +=" 				<span>["+v.BANK_NM+"]</span> 총 <em class=\"cnt\">1</em>계좌";
						acctTitHtml +=" 			</h2>";
						acctTitHtml +="			</div>";
						acctTitHtml +="			<div class=\"sub\">";
						acctTitHtml += acctHtml;
						acctTitHtml +="			</div>";
						acctTitHtml +="		</li>";
						acctTitHtml +="	</ul>";
						acctTitHtml +="</div>";
						$(".pdt12").append(acctTitHtml);
						acctHtml = "";
						acctTitHtml = "";
					}
					
					bfBankNm = v.BANK_NM;
				});
				
				// 전체성공
				if(ACCT_LIST.length == succ_cnt){
					//rslt_msg = "<p>계좌 등록이 <span class=\"c_357EE7\">완료</span>되었습니다.</p>";
					$("#succ_dv").show();
					$("#a_enter").show();
				}
				// 전체 실패
				else if(succYn == "N"){
					rslt_msg = "<p>계좌 등록이 <span class=\"c_793FFB\">실패</span>되었습니다.</p>";
					$("#fail_dv").show();
					$("#c_enter").show();
				}
				// 일부 실패
				else{
					rslt_msg = "<p>계좌 등록이 <span class=\"c_793FFB\">일부 실패</span>하였습니다.</p>";
					$("#succ_dv").show();
					$("#a_enter").show();
				}
			}else{
				rslt_msg = "<p>계좌 등록이 <span class=\"c_793FFB\">실패</span>되었습니다.</p>";
				$("#fail_dv").show();
				$("#c_enter").show();
			}
			$("#rslt_msg").html(rslt_msg);
		}
}

function fn_confirm(){
	//location.href = "acct_0004_02.act";
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}

/*
//계좌거래내역 실시간 조회
function fn_realTimeSearch(){
	iWebAction("showIndicator");
	
	var jexAjax = jex.createAjaxUtil("acct_0004_02_c001");
	
	jexAjax.execute(function(data){
		iWebAction("hideIndicator");
		location.href = "acct_0004_02.act";
	});
}
*/

//백버튼
function fn_back(){
	// 연결된 계좌 화면으로 이동
	location.href = "acct_0003_01.act";
}