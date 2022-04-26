package com.avatar.batch;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.exception.JexTransactionRollbackException;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.simplebatch.AbstractSimpleBatchTask;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;

import com.avatar.api.mgnt.BizmApiMgnt;
import com.avatar.comm.BizLogUtil;

/**
 * 배치 > 미등록계정 > 알림톡발송
 *
 */
public class UnregInfoTalkSend extends AbstractSimpleBatchTask {

    @Override
    public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

    	System.out.println("UnregInfoTalkSend 배치 실행");
        BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();


        idoCon.beginTransaction();

        try {
        	// 가입일 +7, +28일 된 정보미등록 고객
            JexData idoIn1 = util.createIDOData("CUST_LDGR_R036");
            JexDataList<JexData> custLdgrList = idoCon.executeList(idoIn1);

            if (DomainUtil.isError(custLdgrList))
                throw new JexTransactionRollbackException(custLdgrList);


            for(JexData custLdgr : custLdgrList) {
            	BizLogUtil.info(this, "UnregInfoTalkSend", "가입일+7/+28경과 고객 : "+custLdgr.toJSONString());
            	
            	// 계정별 등록여부 조회
                JexData idoIn2 = util.createIDOData("CARD_INFM_R013");
                idoIn2.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
                JexDataList<JexData> regInfoList = idoCon.executeList(idoIn2);

                if (DomainUtil.isError(regInfoList)) continue;
                
                String acctYn = "Y";   
                String taxYn = "Y";   
                String crefYn = "Y";   
                String cardYn = "Y";   
                
                for(JexData regInfo : regInfoList) {
                	BizLogUtil.info(this, "UnregInfoTalkSend", "계정 등록 목록: "+regInfo.toJSONString());
                	
                	// 계좌 미등록인 경우
                	if(regInfo.getString("GB").equals("ACCT") 
                		&& regInfo.getString("LINK_YN").equals("N")) {
                		acctYn = "N";
                	}
                	// 홈택스 미등록인 경우
                	else if(regInfo.getString("GB").equals("TAX") 
                        && regInfo.getString("LINK_YN").equals("N")) {
                        taxYn = "N";
                    }
                	// 여신 미등록인 경우
                	else if(regInfo.getString("GB").equals("CREF") 
                        && regInfo.getString("LINK_YN").equals("N")) {
                		crefYn = "N";
                    }
                	// 법인카드 미등록인 경우
                	else if(regInfo.getString("GB").equals("CARD") 
                		&& regInfo.getString("LINK_YN").equals("N")) {
                    	cardYn = "N";
                    }
                }
                
                // 전체 등록한 사용자
                if(acctYn.equals("Y") && taxYn.equals("Y") && crefYn.equals("Y") && cardYn.equals("Y")) {
                }else {
                	String clph_no = StringUtil.null2void(custLdgr.getString("CLPH_NO"));
                	String cust_nm = StringUtil.null2void(custLdgr.getString("CUST_NM"));
                	
                	// 발송 템플릿 ID
                    String tmplId = "";
                    
                    // 발송 템플릿 메시지
                    String msg = "";
                    
                    // 전체 미등록
                    if(acctYn.equals("N") && taxYn.equals("N") && crefYn.equals("N") && cardYn.equals("N")) {
                    	tmplId = "askavatar_002_xxxx";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 모든 기관을 연결하지 않으셨네요\n\n";
        				msg += "아바타가 더 많은 답변을 하도록\n";
        				msg += "\"데이터 연결해줘\"라고 말해보세요.\n";
        				msg += "연동된 데이터를 기반으로 다양하게 질문할 수 있습니다.\n\n";
        				msg += "❎ 미연결\n";
        				msg += "은행, 홈택스, 여신금융협회, 카드사\n\n";
        				msg += "데이터 연결 후 이렇게 물어보세요.\n\n";
        				msg += "“어제 입출금 내역은?”\n";
        				msg += "“바타상사 세금계산서 매출은?”\n";
        				msg += "“이번달 카드매출 얼마야?”\n";
        				msg += "”이번주에 비씨카드 얼마썼어?”";        				
                    }
                    // 은행O, 홈택스X, 여신X, 카드사X
                    else if(acctYn.equals("Y") && taxYn.equals("N") && crefYn.equals("N") && cardYn.equals("N")) {
                    	tmplId = "askavatar_002_oxxx";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "은행\n\n";
        				msg += "❎ 미연결\n";
        				msg += "홈택스, 여신금융협회, 카드사\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"어제 세금계산서 매출은?\"\n";
        				msg += "\"지난달 카드매출은?\"\n";
        				msg += "\"이번주에 비씨카드 얼마썼어?\"";        
                    }
                    // 은행X, 홈택스O, 여신X, 카드사X
                    else if(acctYn.equals("N") && taxYn.equals("Y") && crefYn.equals("N") && cardYn.equals("N")) {
                    	tmplId = "askavatar_002_xoxx";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "홈택스\n\n";
        				msg += "❎ 미연결\n";
        				msg += "은행, 여신금융협회, 카드사\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"00은행 통장 잔액은?\"\n";
        				msg += "\"카드매출 입금 예정액은?\"\n";
        				msg += "\"저번주에 ㅇㅇ카드 얼마 썼어?\"";
                    }
                    // 은행X, 홈택스X, 여신O, 카드사X
                    else if(acctYn.equals("N") && taxYn.equals("N") && crefYn.equals("Y") && cardYn.equals("N")) {
                    	tmplId = "askavatar_002_xxox";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "여신금융협회\n\n";
        				msg += "❎ 미연결\n";
        				msg += "은행, 홈택스, 카드사\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"지난달 자금 현황은?\"\n";
        				msg += "\"매출 세금계산서 발행했어?\"\n";
        				msg += "\"00카드 한도 얼마야?\"";
                    }
                    // 은행X, 홈택스X, 여신X, 카드사O
                    else if(acctYn.equals("N") && taxYn.equals("N") && crefYn.equals("N") && cardYn.equals("Y")) {
                    	tmplId = "askavatar_002_xxxo";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "카드사\n\n";
        				msg += "❎ 미연결\n";
        				msg += "은행, 홈택스, 여신금융협회\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"00은행 입출금 내역은?\"\n";
        				msg += "\"매입 현금영수증은?\"\n";
        				msg += "\"상반기 카드 매출은?\"";
                    }
                    // 은행O, 홈택스O, 여신X, 카드사X
                    else if(acctYn.equals("Y") && taxYn.equals("Y") && crefYn.equals("N") && cardYn.equals("N")) {
                    	tmplId = "askavatar_002_ooxx";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "은행, 홈택스\n\n";
        				msg += "❎ 미연결\n";
        				msg += "여신금융협회, 카드사\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"카드매출 입금 예정액은?\"\n";
        				msg += "\"지난주 카드 매출은?\"\n";
        				msg += "\"00카드 한도는?\"";
                    }
                    // 은행O, 홈택스X, 여신O, 카드사X
                    else if(acctYn.equals("Y") && taxYn.equals("N") && crefYn.equals("Y") && cardYn.equals("N")) {
                    	tmplId = "askavatar_002_oxox";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "은행, 여신금융협회\n\n";
        				msg += "❎ 미연결\n";
        				msg += "홈택스, 카드사\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"00거래처 주소는?\"\n";
        				msg += "\"어제 매출 세금계산서는?\"\n";
        				msg += "\"이번주 카드 사용 내역 보여줘.\"";
                    }
                    // 은행O, 홈택스X, 여신X, 카드사O
                    else if(acctYn.equals("Y") && taxYn.equals("N") && crefYn.equals("N") && cardYn.equals("Y")) {
                    	tmplId = "askavatar_002_oxxo";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "은행, 카드사\n\n";
        				msg += "❎ 미연결\n";
        				msg += "홈택스, 여신금융협회\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"이번달 매출 얼마야?\"\n";
        				msg += "\"상반기 카드 매출 내역은?\"\n";
        				msg += "\"저번달 거래처 000 매출액 보여줘.\"";
                    }
                    // 은행X, 홈택스O, 여신O, 카드사X
                    else if(acctYn.equals("N") && taxYn.equals("Y") && crefYn.equals("Y") && cardYn.equals("N")) {
                    	tmplId = "askavatar_002_xoox";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "홈택스, 여신금융협회\n\n";
        				msg += "❎ 미연결\n";
        				msg += "은행, 카드사\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"00은행 잔액 보여줘\"\n";
        				msg += "\"4월 입출금 내역은?\"\n";
        				msg += "\"00카드 사용 내역은?\"";
                    }
                    // 은행X, 홈택스O, 여신X, 카드사O
                    else if(acctYn.equals("N") && taxYn.equals("Y") && crefYn.equals("N") && cardYn.equals("Y")) {
                    	tmplId = "askavatar_002_xoxo";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "홈택스, 카드사\n\n";
        				msg += "❎ 미연결\n";
        				msg += "은행, 여신금융협회\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"00은행 잔액 보여줘\"\n";
        				msg += "\"금융자산 현황은?\"\n";
        				msg += "\"이번달 카드 매출액은?\"";
                    }
                    // 은행X, 홈택스X, 여신O, 카드사O
                    else if(acctYn.equals("N") && taxYn.equals("N") && crefYn.equals("Y") && cardYn.equals("Y")) {
                    	tmplId = "askavatar_002_xxoo";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "여신금융협회, 카드사\n\n";
        				msg += "❎ 미연결\n";
        				msg += "은행, 홈택스\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"00은행 잔액 보여줘\"\n";
        				msg += "\"매출 세금계산서 발행했어?\"\n";
        				msg += "\"세액 내역은?\"";
                    }
                    // 은행O, 홈택스O, 여신O, 카드사X
                    else if(acctYn.equals("Y") && taxYn.equals("Y") && crefYn.equals("Y") && cardYn.equals("N")) {
                    	tmplId = "askavatar_002_ooox";        				
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "은행, 홈택스, 여신금융협회\n\n";
        				msg += "❎ 미연결\n";
        				msg += "카드사\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"작년 카드 사용 내역은?\"\n";
        				msg += "\"00카드 한도는?\"\n";
        				msg += "\"00카드로 얼마나 샀어?\"";
                    }
                    // 은행X, 홈택스O, 여신O, 카드사O
                    else if(acctYn.equals("N") && taxYn.equals("Y") && crefYn.equals("Y") && cardYn.equals("Y")) {
                    	tmplId = "askavatar_002_xooo";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "홈택스, 여신금융협회, 카드사\n\n";
        				msg += "❎ 미연결\n";
        				msg += "은행\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"00은행 통장 잔액은?\"\n";
        				msg += "\"어제 입출금 내역은?\"\n";
        				msg += "\"금융자산 현황은?\"";
        				
                    }
                    // 은행O, 홈택스X, 여신O, 카드사O
                    else if(acctYn.equals("Y") && taxYn.equals("N") && crefYn.equals("Y") && cardYn.equals("Y")) {
                    	tmplId = "askavatar_002_oxoo";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "은행, 여신금융협회, 카드사\n\n";
        				msg += "❎ 미연결\n";
        				msg += "홈택스\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"매출 세금계산서 발행했어?\"\n";
        				msg += "\"00상사 주소는?\"\n";
        				msg += "\"이번달 현금영수증 매입은?\"";
                    }
                    // 은행O, 홈택스O, 여신X, 카드사O
                    else if(acctYn.equals("Y") && taxYn.equals("Y") && crefYn.equals("N") && cardYn.equals("Y")) {
                    	tmplId = "askavatar_002_ooxo";
        				msg += "안녕하세요, "+cust_nm+"님\n";
        				msg += "음성인식 AI비서 에스크아바타입니다.\n";
        				msg += "아직 연결하지 않은 기관이 있네요.\n\n";
        				msg += "⭕ 연결완료\n";
        				msg += "은행, 홈택스, 카드사\n\n";
        				msg += "❎ 미연결\n";
        				msg += "여신금융협회\n\n";
        				msg += "기관데이터를 더 연결하면 똑똑해진 아바타가 다음의 질문에 대답해줍니다.\n\n";
        				msg += "\"00카드 매출액은?\"\n";
        				msg += "\"카드매출 입금 예정액은?\"\n";
        				msg += "\"어제 카드 매출액 얼마야?\"";
                    }
                    
                    BizLogUtil.info(this, "UnregInfoTalkSend", "발송 템플릿: "+tmplId);
                	
                    JSONObject button1 = new JSONObject();
    		        button1.put("name"    			, "자세히 보러가기👉");
    		        button1.put("type"      		, "WL");
    		        button1.put("url_mobile"    	, "http://pf.kakao.com/_xhPjUK/83607021");
    		        button1.put("url_pc"      		, "http://pf.kakao.com/_xhPjUK/83607021");
    		        
                    JSONObject button2 = new JSONObject();
    		        button2.put("name"    			, "에스크아바타 열기👉");
    		        button2.put("type"      		, "AL");
    		        button2.put("scheme_android"    , "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
    		        button2.put("scheme_ios"      	, "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
    		        
    		        BizmApiMgnt.apiJoinSendMsgVer3(clph_no, msg, tmplId, button1, button2);
                }
            }
            
        } catch(Throwable e) {
            BizLogUtil.error(this, "execute", e);

        }

        idoCon.endTransaction();

        return null;
    }
}
