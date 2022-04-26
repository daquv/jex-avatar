package com.avatar.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import com.avatar.comm.AESUtils;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.KISA_SEED_CBC_Util;
import com.avatar.comm.SvcDateUtil;

import jex.enums.JexLANG;
import jex.exception.JexBIZException;
import jex.json.JSONObject;
import jex.sys.JexSystemConfig;
import jex.util.StringUtil;
import jex.web.exception.JexWebBIZException;
import jex.web.ext.WebRequest;
import jex.web.ext.WebResponse;
import jex.web.servlet.JexServlet;


/***
 * 수금박사3.0 모바일 대상 API
 * @author 문태호
 *
 */
public class GateWay extends JexServlet {

    public static final String SUCCESS                   = "0000"; // 성공
    public static final String UNDEFINE_ERROR            = "E_1000"; // 알수 없는 오류
    public static final String RECEIVE_DATA_FORMAT_ERROR = "E_1001"; // 수신 자료 포멧 오류
    public static final String API_SVC_NOT_ALLOWED       = "E_1002"; // API 인증 오류.
    public static final String API_SVC_ID_NOT_FOUND      = "E_1003"; // API_SVC_ID 찾지 못함
    public static final String SERVICE_NOT_FOUND         = "E_1004"; // JEX SERVICE를 찾지 못함

    public static final String SUCCESS_MSG               = "정상 처리되었습니다.";
    public static final String UNDEFINE_ERROR_MSG        = "처리중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.";
    public static final String API_SVC_NOT_ALLOWED_MSG   = "공통부 필수입력 항목 누락. 인증되지 않은 요청입니다.";
    public static final String API_SVC_ID_NOT_FOUND_MSG  = "공통부 필수입력 항목 누락. API 서비스 ID를 확인하여 주십시오.";
    public static final String SERVICE_NOT_FOUND_MSG     = "API 서비스를 찾을 수 없습니다.";

    /**
     *
     */
    private static final long serialVersionUID = -3153726252110201567L;

    @Override
    public void jexService(WebRequest request, WebResponse response) throws IOException, ServletException {
    	
    	/****************************************
         * 응답부 Character Set
         ****************************************/
        response.setContentType("text/json; charset=UTF-8");


        /****************************************
         * local 변수 선언
         ****************************************/
        String strApiCrtsKey         = "";
        String strApiSvcId           = "";
        String strEncYn          	 = "";
        String strJSONData           = "";

        JSONObject jReqParam         = null; // 전문 요청 파라미터
        JSONObject mReqComm          = null; // 전문 요청 공통부
        Map<String, Object> mReqData = null; // 전문 요청 개별부
        JSONObject jRspParam         = null; // 전문 응답 파라미터

        Map<String, Object> mActionData = null; // API 요청 데이타

        PrintWriter out              = response.getWriter();


        Enumeration<?> headerNames = request.getHeaderNames();
        BizLogUtil.debug(this, "Request Header ========================================");
        while(headerNames.hasMoreElements()) {
            String hname = (String)headerNames.nextElement();
            String hvalue = request.getHeader(hname);
            if(hvalue==null) hvalue = "";
            BizLogUtil.debug(this, "Request Header : "+hname+"="+hvalue);
        }
        BizLogUtil.debug(this, "Request Header ========================================");

        BizLogUtil.debug(this,"");
        BizLogUtil.debug(this,"user-getRemoteAddr=" +request.getRemoteAddr());


        /****************************************
         * 문자열 전문 취득
         ****************************************/
        if(request.getMethod().equals("GET")){
        	//BizLogUtil.debug(this,"GET InputJSONData ::: "+StringUtil.null2void(request.getParameter("JSONData")));
            strJSONData = java.net.URLDecoder.decode(StringUtil.null2void(request.getParameter("JSONData")).replaceAll("%(?![0-9a-fA-F]{2})", "%25"), "UTF-8");
        } else {
        	StringBuilder stringBuilder = new StringBuilder();
            BufferedReader bufferedReader = null;

            try {
                InputStream inputStream = request.getInputStream();
                if (inputStream != null) {
                    bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
                    char[] charBuffer = new char[128];
                    int bytesRead = -1;
                    while ( (bytesRead = bufferedReader.read(charBuffer)) > 0 ) {
                        stringBuilder.append(charBuffer, 0, bytesRead);
                    }
                }
            } catch (IOException ex) {
                throw ex;
            } finally {
                if (bufferedReader != null) {
                    try {
                        bufferedReader.close();
                    } catch (IOException ex) {
                        throw ex;
                    }
                }
            }

            BizLogUtil.debug(this,"POST InputJSONData :::"+stringBuilder.toString().replaceAll("JSONData=", ""));
            strJSONData = java.net.URLDecoder.decode(stringBuilder.toString().replaceAll("JSONData=", "").replaceAll("%(?![0-9a-fA-F]{2})", "%25"), "UTF-8");
//            strJSONData = java.net.URLDecoder.decode(stringBuilder.toString().replaceAll("JSONData=", "").replaceAll("%(?![0-9a-fA-F]{2})", "%25").replaceAll("\\+", "%2B"), "UTF-8");
        }
        strJSONData = strJSONData.replaceAll("\"null\"", "\"\"");

        //strJSONData = java.net.URLEncoder.encode(strJSONData, "UTF-8");

        BizLogUtil.debug(this,"Method="+request.getMethod());
        BizLogUtil.debug(this,"JSONData="+strJSONData);

        /****************************************
         * JSONData 문자열 오류 체크
         ****************************************/
        if ("".equals(strJSONData)) {
            sendRespErrorData(request, out, RECEIVE_DATA_FORMAT_ERROR, "JSONData 파라미터가 누락되었습니다.", "", strApiSvcId);
            return;
        }


        /****************************************
         * JSONData 오류 체크
         ****************************************/
        jReqParam = JSONObject.fromObject(strJSONData);
        if (jReqParam.isEmpty()) {
            sendRespErrorData(request, out, RECEIVE_DATA_FORMAT_ERROR, "송신한 데이터의 JSON변환 중 오류가 발생하였습니다.", "", strApiSvcId);
            return;
        }

        /****************************************
         * API 인증키 검증
         ****************************************/
        strApiCrtsKey = StringUtil.null2void(jReqParam.getString("CNTS_CRTS_KEY"));

        if(!strApiCrtsKey.equals(JexSystemConfig.get("ServerInfo/api", "CNTS_CRTS_KEY"))){
            sendRespErrorData(request, out, API_SVC_NOT_ALLOWED, API_SVC_NOT_ALLOWED_MSG, "", strApiSvcId);
            return;
        }


        /****************************************
         * API ID 추출
         ****************************************/
        strApiSvcId  = StringUtil.null2void(jReqParam.getString("TRAN_NO"));

        /****************************************
         * API ID 검증
         ****************************************/
        if ("".equals(strApiSvcId)) {
            sendRespErrorData(request, out, API_SVC_ID_NOT_FOUND, API_SVC_ID_NOT_FOUND_MSG, "", strApiSvcId);
            return;
        } else if(!strApiSvcId.startsWith("APP")){
            sendRespErrorData(request, out, API_SVC_ID_NOT_FOUND, API_SVC_ID_NOT_FOUND_MSG, "", strApiSvcId);
            return;
        }
        BizLogUtil.debug(this,"API ID 검증 완료.");

        /****************************************
         * 서비스 context 초기화
         ****************************************/
        try {
            initContext(strApiSvcId, request, response, JexLANG.DF);
        } catch (Exception e) {
            e.printStackTrace();
            sendRespErrorData(request, out, SERVICE_NOT_FOUND, SERVICE_NOT_FOUND_MSG, e.toString(), strApiSvcId);
            return;
        }
        BizLogUtil.debug(this,"Context 초기화 완료.");


        /****************************************
         * API 요청 개별부 추출
         ****************************************/
        // 암호화 여부 확인해서 복호화
    	strEncYn = StringUtil.null2void((String)jReqParam.get("ENC_YN"), "N");

    	if(!"N".equals(strEncYn)){
    		BizLogUtil.debug(this,"암호화 처리. ");

    		mReqData = reqDecrypt(jReqParam.get("REQ_DATA").toString());

    		if(mReqData == null){
    			BizLogUtil.debug(this,"Exception : mApiTrnReqData  복호화중 오류가 발생하였습니다." );
	    		sendRespErrorData(request, out, "SOER1013", "복호화중 오류가 발생하였습니다.", "", strApiSvcId);
	    		return;
    		}
    		BizLogUtil.debug(this,"mReqData완료 데이터 :" +mReqData.toString());
    	}else {
    		BizLogUtil.debug(this,"암호화 처리 안함. ");
    		mReqData = (Map<String, Object>) jReqParam.get("REQ_DATA");
    	}

        /****************************************
         * API 응답 파라미터 생성
         ****************************************/
        jRspParam = new JSONObject();

        /****************************************
         * 전문 호출
         ****************************************/
        try {
            // API 요청 개별부 설정
            mActionData = mReqData;

            // API 요청 공통부 설정
            mReqComm = new JSONObject();
            mReqComm.put("TRAN_NO"        , strApiSvcId		);
            mReqComm.put("DEVICE_INST_ID" , StringUtil.null2void(jReqParam.getString("DEVICE_INST_ID"))	);
            mReqComm.put("ENC_YN"	      , StringUtil.null2void(jReqParam.getString("ENC_YN"))	    );
            
            mActionData.put("MOBL_COMM", mReqComm.toJSONString());

            BizLogUtil.debug(this,"mActionData :: "+mActionData.toString());
            
            // API 호출
            JSONObject jRspData = performJsonAction(strApiSvcId, mActionData, request, response);

            // API 공통부 설정
            jRspParam.put("TRAN_NO" 	, strApiSvcId		);
            jRspParam.put("RESP_DATE" 	, SvcDateUtil.getInstance().getDate()		);
            jRspParam.put("RESP_TIME" 	, SvcDateUtil.getInstance().getShortTimeString()		);

            // 응답 파라미터 설정
            if(jRspData.getJSONObject("attribute")==null){

            	/*
            	if("".equals(StringUtil.null2void(jRspData.getString("RSLT_CD")))) {
            		jRspParam.put("RSLT_CD" 	, SUCCESS		);
                    jRspParam.put("RSLT_MSG"	, SUCCESS_MSG	);
            	}else {
            		jRspParam.put("RSLT_CD" 	, jRspData.getString("RSLT_CD"));
                   	jRspParam.put("RSLT_MSG"	, jRspData.getString("RSLT_MSG"));
            	}
            	*/
            	// 통신이 정상일 경우에 성공 메시지
            	if( "".equals(StringUtil.null2void(jRspData.getString("RSLT_CD"))) ) {
            		jRspParam.put("RSLT_CD" 	, SUCCESS		);
                    jRspParam.put("RSLT_MSG"	, SUCCESS_MSG	);
            	}else {
            		jRspParam.put("RSLT_CD" 	, StringUtil.null2void(jRspData.getString("RSLT_CD"))	);
                    jRspParam.put("RSLT_MSG"	, StringUtil.null2void(jRspData.getString("RSLT_MSG"))	);
            	}


                jRspParam.put("RESP_DATA", jRspData);

                //jRspParam.put("RSLT_CD" 	, SUCCESS		);
                //jRspParam.put("RSLT_MSG"	, SUCCESS_MSG	);
                //jRspParam.put("RESP_DATA"	, jRspData		);
            } else {

                JSONObject attr = jRspData.getJSONObject("attribute");

                if(attr.getString("_ERROR_CODE_").startsWith("S") || attr.getString("_ERROR_CODE_").equals("Session Disconnect")){
					jRspParam.put("RSLT_CD" 	, attr.getString("_ERROR_CODE_")     );
					jRspParam.put("RSLT_MSG"	, attr.getString("_ERROR_MESSAGE_")  );
					jRspParam.put("RESP_DATA"	, null	);
				} else {
					jRspParam.put("RSLT_CD" 	, UNDEFINE_ERROR		);
					jRspParam.put("RSLT_MSG"	, UNDEFINE_ERROR_MSG	);
					jRspParam.put("RESP_DATA"	, null	);
				}
            }

            // 응답 전송
            sendRespData(request, out, jRspParam.toString(), strApiSvcId);

        } catch (JexBIZException je) {
            BizLogUtil.error(this, je);
            sendRespErrorData(request, out, je.getCode(), je.getMessage(), je.toString(), strApiSvcId);
        } catch (JexWebBIZException jwe) {
            BizLogUtil.error(this, jwe);
            sendRespErrorData(request, out, jwe.getCode(), jwe.getMessage(), jwe.toString(), strApiSvcId);
        } catch (Error e) {
            BizLogUtil.error(this, e);
            sendRespErrorData(request, out, UNDEFINE_ERROR, UNDEFINE_ERROR_MSG, e.toString(), strApiSvcId);
        } catch (Throwable e) {
            BizLogUtil.error(this, e);
            if (e instanceof JexBIZException) {
                sendRespErrorData(request, out, ((JexBIZException) e).getCode(), ((JexBIZException) e).getMessage(), e.toString(), strApiSvcId);
            } else if (e instanceof ServletException) {
                if (((ServletException) e.getCause()).getCause() instanceof JexBIZException) {
                    JexBIZException je = (JexBIZException) ((ServletException) e.getCause()).getCause();
                    sendRespErrorData(request, out, je.getCode(), je.getMessage(), je.toString(), strApiSvcId);
                } else {
                    sendRespErrorData(request, out, UNDEFINE_ERROR, UNDEFINE_ERROR_MSG, e.toString(), strApiSvcId);
                }
            } else {
                sendRespErrorData(request, out, UNDEFINE_ERROR, UNDEFINE_ERROR_MSG, e.toString(), strApiSvcId);
            }
        } finally {
        }
    }


    // 복호화
    public JSONObject reqDecrypt(String reqStr){
    	// TODO : 테스트데이터
    	//reqStr = "OuZryEfpMs0b142bfa52c44a506bf794ebc78ff0a5cf4a5b438d15f94dfec5788abb5dd04104da80dca3c4be334494891f09e625e8337cd7451bb9a6910ac0ed9a02d8afe9f2a5d239f499b5881fcfde1902c279d5d2af8ba1396e2bbfb13bbb690429fc25bbbd24c8bda0dc07e9d82f3609d59b8dbd74f3ada458feac41243140b22774321caf4c0b5b1d3f622abf2667f3c78b173ef69e4079c3a04fcbac9bfd22caaeabfde8713048ae39d87160a743e9e5d6c1a917a95467c3bbc19cbe64f4e937555979acf3e360ab158bbbf33cffaf7a214269492f57d6649a9f211e7405849cf82365136d56c6164cbd0e6f7e1d5186f46961b8a753010faf017b30d335e383c805b7ab15e306aa69f762f28882e7a9b808deb018735c059d4cb06c95d00dc074bbf5a1134ed7cff4c4902d741a2c89d840f7847660604942b7684bd032445b1e51867d1ea219e0067b989b9df9c44ace68ca819516a792615a2e4d26871e8de6eb0d7b5f61abb1931df24326023e9ba3dc17b27cecbf8fbc54ce539add1f4a4567c3162b9e7aaaa83864b146e9ed0932f78f5d53fbb75b4ec95626c9e9a815e2fc90db2243d9dd18a557a31363763669142398911b281ee8be2c741a213a00da1913f67906242d201c7fae3b1bab076baa7c0f393aaf8d12af437f2e3aa5659a10bc2b82f51ed674cfe9cceaa76ff04cf5edb651bfa9d85461af76081780ccff595a09464d400e8a418f869b505de3e291f7713ccc25bfa6c1242d587e461b4212495ed097664d4f228abfa556daa4981632c7c2cbb401a0964fc57d190a93434175ecd774c488dcd0e9d2ca787d0c9d17cdaa54ebe6263870fa87d91cf14f761d43e36e68162aa15d1edd943a84b260d11a2b30801e3450b77814c09388795cc7f4b233102cef6f8c87ed93981616df78aa78ee88e343e23ae449407458b699b98c722522f84e21012b2d893ea0978318fada46a28a59bc357ee4eafb66753dba16dcd1d31e4555dfc79e4d90316df7b5acdd1b8a2c4e8ef90241b86b062fd1175f712efeb13da7fb6f1f04cfb6e68a4ff2044aa2a24d08d76ec8df4f49388c762238e7d6a5eca93282a768c409bdcd60cf6ed9ecab6b2136e473654e9414d06f28dc8da2adad49c043fb5e52a16da348d6bf050a4752eae8db0d3685ce4d19e5ed682036dcbe8c529364b68789e1ae481513dbf80f6559c999e43f47930cfbae945c3da2bf0b629350b2c8c5c3f1c0d06020e87b534a639244615868ff90a170814469d25838ce76181680cc637b7a39d1600c344a6fd9261cac38ffaebd8ca543b166654d7b50eab4e3f155e65575492ba2649135f7e012abf211e2488755da16d1d03b929b138682efa823bf65e53b422f10066398a3c2a02b8a5ed86ff352ee6646bdea1e9ae1a34e30f0491f61a190580ece2da0d3e427d7f9bb904e1a5b2b94ef9181c8be5ebea9bd3301ebaf10fbdec8e6120bd0c1de4cdbc1647705b78062e64efa5d1ad0fae8d2c72655237b9b7245895d52f8e994904db12baa22782fd3e85927f7f37fc0c5c87968064ca44f1cf274df36bc1c3e050d89839bfe2b6417bf60786bea54d745dc46359b064b2f2995fbc11526e72e51561ab7f8455477b3d2a54f901c48eee1a341f1b863623d8cd334878060344213c495a7497a4e589d0d0b479302cc2e9e88955e989ee49cde8093cb774c4eb510f4872e852281f5b6a0e14fc7840505a91dac0d52a8d388e0fdb04b8bcff8238d136276b1caa0662f3645e9810bf418fb00a354cf6bbc673b5b606f60b231a6e6e5673e4a040ebebc5e2ea3822fb394bacbbe054b5c77f06eeb92e30e6064438cdc6471e2d6c7e20ac4fc354c688afa344dd1e6a8f545f48a9372c6765ec1dd73e74e80651ba25a4cc4cc1fe9cf52116c9ba247cd71ce5bfeec03c6832b76fccb26fb48633e307712865e98249c9c2b7e4907fa0aa6feac5d144e4c32b9657a37f5c0c968efd50cc5c9cab2a33022e12e452bfc2b6b80b5100574cd62a3f6b6d9386ede8bdca6471fd46ce0a83edbf6289503412d4d2ec6bd6b6904524b215d0051d3ff70235216252cb30f8a51aa1f3eb14818a4db9bc5be55ebf70f4169afd851b972cb6354bdbb7b0fae3389f6e0539d3b9f85dde92479c145fd0e47f43bce3b0c86d87ad447a9d28828b991bcb9513e70f9f0887a3f730d4430634c7d1bf6d6508b0fe3953ff72800fad73719065337fa0feeeb5e737da5931f2a082706349f3bf45c1f94db58923736bcc762ae421d23143fd0b28fd6addced5b0749d301cdddd073e41e7eb4c3b7cc46d51b8c49617be964f677a1f18fbae614b3291ace9d1b2b9309bbc8fc90986ac4ba80ef8a78f918bcb042fd2b29f4897c486c734c9dc304c0f65bcfebc14371dac0e7dc767abb451d3bc7cfb3f5524c17ea1f1baa95e414cedf3eb2cd0a4a70ebb2cf1fed04d49a7ddb899c9130433aeef6a586221304e9f0ecc23232963fed7e63287bcff5f53331a16fbe4d8b74dc39bdf7c4cdaab3c9b218552e7f5872379e121219aa73ca3de725d23751e9f5d12b6a64b150cdc0b18b0ae5e1c93938fdbd55d45d961fd8fbcfd0b48e2577e71d4443859f187b51b95c41827f074a747e62fea4e9d360cbf750cbd2a63ad1c8f746b4d8c7d00c70627bf79bbe35e153db874fab95eaae5fa39d0673b3ca3ab37d3ffd4f5382aa5f6abb65ffe63da6a0e127a16a382224a64c92cbdd35d4b7d292aa0101f3b93548afa2b88fdb435d913df665c1ef4c89bb863b256ecf9796fbff73d5ee323e4b7003561c618c62da2e285c5b33b39afe1345a5b0bef6869e1788414ee2b8ca331affd651e5f01ce9180f934fabc69cddea601006792a28b4aebce7885a29a627f9d76000a5b73e761ed32b550f2e8bc067eca6918eeca484427e585e68bbbca9c51ec76d6eca0386f8a714436aa8a90c8553ba4eaff33bf019701e95fe6bc745e259abbb69cf7b70daaddebfb76708f5531d1f74e8ff25f0d68246111da61b77f0db20e6f748d921f65f8f69f3f83696101051417e1949a9a77e1116c8d48f0563c9246ee63e5471e5982797bbfe8d6279ff8b0036195bf8e8cff33794bac6a1516a2a20773bf09933eb1b7160a85087316e0288c9b35b83b2d0b951477a7dcd1c5606e858fd51cccf6bce039910a07b066a79b9e862474a10e1e6c9f2380cea388c58e172d874076fcd5897a474f104b11cea399670548e5707e3f0dfa4d5f7902c9d7ba579c0eb2d00e03abd0c892f6c4e9a91b2411cea81975c2f70b05c47415dbc0cd044b657762be2fd028aa366a8482e7aa03abd3cbff59dabd54aa98974f6a80acfad36ce9685e4adf6173f88be5220e5871b710da00752e25bdf720a50e4286cedac29183cb9b7ac20bb107d6d1f8292369f8509b2e4263379932dcd67dd2bea7abdaf893b2dbc9a07d77ff4beeba9efa21eaa0acdc6dac7ac97de124500a88df147593c67163e756c87fa87c2b27365014a0983446d4349aae176cde6aaf2335162a397a774ab58ed2938fefd4ef612f177d8f6a0c76c191423f711f8558d9d8cc32bf7f4677466fe0964956cb4b5def6a78e8ec08ac3c3ad6e4771a785319dc717aa4011f2eec8277bb5c32bc06254a842b66c3cecf9f7aa85d7339edb918a15afe5c5c778a920235eed4620695e4d99caf9145123ecce25aed93603c0f87c6b1499d6e0098509cf059307b02dc8be322223f2d574c76fdc82e211e72c76a845b41ea0fb4c8ca8428a2d4719fda29fd4ce63d24fa0d0f57afbcc48cc82f747f3389f64aafd3a9202e8d30014fb0270f0a0ce958781d73c07e7650783c8bf2d05265ef96e9d185847b1d6e9411cd6bbe701ea1a98eb93473bb75c7046f39a038a338c065aed4f8cec1a98ddec0de68018bf3612f38dc882f7037e9f4a2f3f6559df3fd12dc1ead8302c2f7b45bfd1dc02638a1b5a3003df19e42b955256e6a01a9bfb1c94bfebc873c5189b4b273392ecd681d1a01acd194c88d0285715279cb4f68a3041ca2f30dc8cc6a1f65571d8caa5ef229d612093a205a67b862d0338494281c84352dc8e351c5ea4413054dd0d4fb621e44dbdad367b78bcc58a3d9b41eb0306596e50a88ade3890af18dd0c70c49563255adada51c72abe89f44be9a309e2d1a48ba9f89380682f7cb17dcc747fafa72b5e684491508ecc18f5fa455346a63ae5b61839dfd67465a1f7565899b165a1a10fb137c7097cb1c149304017c305e47dcee133d5db2aea290002ed575ed14a62fc445dc8bedfbee5b30f5037f0c63485cad6f7a4d42352535eae273c23471886f60961cf2064157a6b3256a72d5fd723aa1272ff2b68667d86da1c03d4689a82a4867d367c3d0818591cacf5158bbc2ca595892e9484d3e5d75a46dbb2a411680abdd6abd8c8abc18f208a038b19440b79b007cf37ba2de59fa47799c5c5a9437c6d8ab71bfed6dea79eaca88a8c41f1e7cdfca4326997e5a7f94fc1774d71ee3d4fd99d3ff42d13965eefd434c739972cb5447eec4f556b243841622b7daaed6be875c86356383a44026aa286ca0d30dc7bcc1794055a88dab541ab16906f3b1c2ad00b800b29f17972558f776f7f2cfa6f81049b41e871f9b4b0a2351b99069a3abbaa90f28e3a9656e2bf62120e45e3f9c540df2ffac29302c5d03cd879af465fa576be684562fc05cfb0ed86648cdbc81bcd73c5d4bdb89e5e6bf765286413bd5a5eb85afb99b49690ce361bbc9d8bdeabbd286944809f9cb7d36f6d7fde92634088c1453853983e42eb203fb64efd9097c6cfcfa9eda83a1d0e1574348f06fc175a5fee32ee96fa1aa0b2d3c84e6cec2edab96fd6ab766059e62c90160aef5f95d470430c613bfa8ef6d26beb1e1c04d06e3253d52aed0b79c38fe882f5f9fe30e8a7f3446107bce23acc7df4c30b31cb1c70a472a98b9b63df5141d983fe39130eae84dc49a0198587b991e3ca0c469ce29bef0293c290fefd41c811d82c710267e13ea304376cc49ce9ef7d6d60221078db9e3e4016a788dc1bfde6a729b6607ec7d91aa03dc1cae41beaa4317fd973d60e4315074d9259fc104065f50c15c6b653706a1732a14c8f335d73e7d4cffcaaccb59fc873fe459ad2ac2778bba07f09b24319d75c6414ef53f8318f4fe4a36f97daa1b8c11a9991f113eee23f7aeef8cbe8714da0ddde04d83a57bc6a1bbd0c08c72e6edd5354547c196663c41c45cf0e8ef356f40186d67acca9ac39a4f7d8b75f2a9e151ba4b0b791a25df3043c4a9c152c0335d61f823e87d09dc549325e2361f4d32888bf133c9d748627ec08b6d5e53c3009dce48686f68e534131aac7736bb6f43f82554734309124e0a1d215242444b28bf61b649ae6caa9d78283998d6bee2300cb55e5704a0792c679597666db0e77c4d16e8e1ab3e7c27b4836d000a747e707a1bf8e8e5e5c4cf2e1eeb870dd62bd078db29649894619627826437438f50ffa2263fca223e8b1b45321c5b45400c48c12e986f27d7fe167beeb1b3de353c4ad72bc26105329bbfdd7b4cad08f90f3ef229306ee82fe9220a998a17deda02bc5d5b12ef83a4e371a5500f8c7eb92107e8c05855834d055c8d009c063b4acf362615bbd2863a7eabc1a7ee69ad4fa0e834f532ecb6a2b7be1a7e5b8b229900b44225fd0992017d4168e76361a00146c24f39960f0babefa0ba80405a1c850d5a3ac4bac68957f0db8c2e96ee7170e2b3938f24dde695cfc89e974c8f0246cdf7a262efda22b075dfe638aa0635eb4b3851e0d34e06647e092293a3a2f2902018b03381bfe43070ee5f4d99878c9db2917e61e7a3fc1c1587f8b42492d2174aec81efe3eb80d2055bce7c83de9135aa5a163860cc1ac1a03f5115a401c4487ad2d2852578a9e3121a1cd999dc9cab8ce079cfb22556bc0bbaecbcad6e52995284246e41e77d48d6c54493e088d870f46189ea044666ca30206fad0b61cbbd40dbc5ddf96b18efe90a20fcc06e21237fdb5da00c8871b83a0ecdcd507a84daf273ed717138ce481f85789626ce12298570ea0edbcbe49a4c8e0ce03a8a3ecd652b5bf1dc702831f9d37e84e68335978cbaf65c5eb2ce890ed15eb33e101e40f9e5dcfe4f96e7bb69b5710c5c8f8942313f049213b6e0768d63c832a0128486c032a932c464df702ee8a1e546d465bfbfdad54ca3c8b3783feb869b7d1f7a58577d28c817da0729bf1d4544cb952229125b5d82fa770ff3d0f78849846bbdfe08b8bf04f1fa6f6a53c6aac5580117e3efef50655b62b9d4764ece4210193775bcfd0eda8a1c5fbf732b725081594b598159f208c76b3770709062b35ccd281525e2542d08f5603e92ed62eabe7222dcca06389e1c932b8f350558fd2e6a3c0cb8f312186ac6cf092d066c8da8cb9a31fa6583660f5e76e89844b4e19f0f25136c2c9890bf62a1f37948e9c61ce3e818903b46ff55842027837475f8712897b8aa2013a91224625439b887b427de7ec92e3b5a9ba9de4479245ce7cf1297a5262b6f5a0a0f1d256c809f7b40d6fc933c28b4f6de7e9e409f06da3c43322b6b127f701e4bba28d8b30cf4a826407da932d32fde00ca7c97bc2a5e534324d8f2fb85e3b7d889da2109211e0c3436f70bd9fafbd754dd04a2beff5b2a9a2a05bd499592b01a653bb6891493898f793dc25665794e2d4558c02cafbbea8eff06dea008185cfd9cc0d31a9af77dc2f6047fae9bd5af0db76f9eb7872ac0fa46cc40d1630d40e65892b09bb98f3e4a8c8f6bb7e417bece9eeef323831fca65ad29061cba27c6e6dedca4046324c605e934bf683948536afb569095cc8c5eb9ee7cf3843fda34e48693ebb6b3cb24619c9268d4186e085f7499e39dc2559d89e3f054511f2799e032794acb06e406fba00d3dd62f9976ba977571f3feb2e0d70bd30d99c1b4d8c7f7da7ecbb73ab4da3f74c29ae6293d3af74159c9ca5a040667a855c64fa7b2aee2fd8c38768161c37e4102b76e0beda3db7314c611dc8818c2e51e181b56df895d75c08dac8e533bd8a790977c0ece295e388bc905ca237e83e1e2b0aebdc6133e848b0e41c556997cf69467fe1e42382fcb901f8414966883df90faa3f017ff59060dbb8ae10341978b5786856de81ec689b9482c7a9484bae5810bdb1dc55016163af105abf21be2e6ce79fd42833be2b11aee51ae97e77f269572ea60742f2af3ea5bd831b768b1e0c31937d227312d1b3ef6284ab38dafd1e2f4156a2dbc4b3f764a19de1b1aa0aa484b5058fe9f1834f41cab70c694b8227ec84d181df911f9a1923ab8e530388f0a6a1fff2a208b85ab5c1163d80c059a8997c11a86ce404d7e81c04eb4608be38394494d24dff9980b29e62509c35648a14f9d035f16a93c28cf12a4743c09e35e7e2422eb1a47f1d04814439630f0c04b58d69eec0016046a1a2770fc06db51a0e0464915d26dcbad203c5514991679dda95a6b076ec892f8b153293beae06e1b33d69b043817216bab7e330d25c5c2e1197c9e698e40abf51a1fea3f963c42f8d9b36fa64e2faeca9ed6842d6292eb57725a219acce47e13762d161c276838068d4b7bba8bd859e5e843bbb219aa541acbf2d4ae530b07a165a1d071d576e930890c0f5a4707633b42ce2e468fad78a1df5d6ea72ee7d8d12eb6bfca23008140f5e2a3c573503418f80b7541b100b49938936a3ecd294be35ee796cc089baafec1253dd00da0088caaae037733e4a4e258d9b60622068920bed9ac906a7361ac501eeb9010b79da2143c7039cf3a592b49e6e0b186aff2c9d52807a83818d37dc76292cb9ad573850b98b00224fb8d567796d05366c6b8c33182dd051029a09f8bb198151a1705b5cf4f9378e7f746f2435fd44ee006722a8b2c4625396dec66238c3f6b6a6de2a5099ec07d822305657e864399f2d6f63cc1495f9d36bc501dc41b334be89087b54e5d7c2454963b9ad78f7b637a16a15bc11d9fec21f0fcecf191aa2f52b53d481e9ddd1dc60999a55647a9e52de4293e0f62c463c0ec1790c2d03ede4eab0410afd05cdf92e4f2c381c61b6110caa3bde651888d668617481caf5065514ca2159f0aea4b3bb7fad004020d272afef2a65ad288ee1d1bd32fa406a22b6e0993ceb9735e203c1483e20145fbfb2e526626c936886ff677e204fa5c39e0eeb611bbd38d03e1551ee1a1152786c80d0c9a45515a781dceb07ca993b71abea1b454266dfa30069d27edb33c228691202bf77e1a29b7b75fc1bdd7ee4b334cf69cf9ebdd36cc5151465084bd585ec4f68011bf1963658e78ccd8e926fc41f196f6c4630a25940bc707692825eb631c046c015f40dd8f7fedf5bd6a9708175b69972273757a763f39b6dcbb2c2e4c6fd136867a056fbedc1d67468a55acfead02dce645d43b7f150550fcd54614ef65d2566c77f7c22374e08d3cd0597393927e1e03339ba1e1cec795b596a3539d286a37fcb645f007c11718678dafe5dcc539bb772a4fdcf98b069d4db3d56532fa9db08afb8cd326aacc088d23a1aac59aa6a19d60e575bd8a62306fb115caf12ecf41bccbaf524cbec85988a7569aea3240b29acd7c91274dfe90e6e1a640285d30629aa2f61d13b8d220b581a2b6a47784a6ae23a8be958a271581a69964b9122aaef5c490dbff85f07d23e6ab4740c18612318aa3b3f6fbdaa996a27215c5f961bd8cfea64f3e1f2913c22df5da6628f7194c0666ce985c2dc9faf76d1386a38680def3ec03e26385fc3c1078f8bd6db9f9cd6e6faebec6fea3d86a85df4a21bfca91fff96e823e8fd560750d83b399f4268334eb9b5f56559a0a714a0b08116db3c0b2689a1c06843e5712a57126d38fe54b3f33e865d0617bd7428a8d8a244e3a4e0302f382bdfd6f2dfc136ddf39f341da";
    	JSONObject jData = new JSONObject();

    	String key 		= reqStr.substring( 0, 10);
    	String encCode 	= reqStr.substring(10, 11);
    	String data 	= reqStr.substring(11);

    	BizLogUtil.debug(this,"reqDecrypt key  :: " + key );
    	BizLogUtil.debug(this,"reqDecrypt encCode  :: " + encCode );
    	BizLogUtil.debug(this,"reqDecrypt data :: " + data );

    	String jDataStr = "";

		try {

			// encCode = > 0:SEED, 1:AES
			if( "0".equals(encCode) ){
				jDataStr = KISA_SEED_CBC_Util.decrypt(data, key);
			}else if( "1".equals(encCode) ){
				jDataStr = AESUtils.decrypt(data, key);
			}else{
				BizLogUtil.debug(this,"reqDecrypt encCode 오류    encCode :: " + encCode );
				return null;
			}
			BizLogUtil.debug(this,"reqDecrypt jDataStr1 :: " + jDataStr );
			//jData = (JSONObject)_parser.parser(StringUtil.null2void(jDataStr));
			jData = JSONObject.fromObject(StringUtil.null2void(jDataStr));

			BizLogUtil.debug(this,"reqDecrypt jDataStr2 :: " + jData.toString() );
		} catch (Exception e) {
			// TODO Auto-generated catch block
			jData = null;
			e.printStackTrace();
			BizLogUtil.debug(this,"=====================================================" );
			BizLogUtil.debug(this," reqDecrypt Exception : reqDecrypt JSON변환 중 오류가 발생하였습니다." );
			BizLogUtil.debug(this,"e.getMessage()  : " + e.getMessage() );
			BizLogUtil.debug(this,"=====================================================" );
		}

    	return jData;
    }

    private void sendRespData(HttpServletRequest request, PrintWriter out, String data, String ApiSvcId) throws Throwable {

        //LOG.debug("=== ["+ApiSvcId+"]Response Data ==============================================");
        //LOG.debug(data);
        //LOG.debug("==============================================================================");

        //out.println(java.net.URLEncoder.encode(data, "UTF-8"));
        BizLogUtil.debug(this,"[RETRUNDATA]"+data);
        out.println(data);
    }

    private void sendRespErrorData(HttpServletRequest request, PrintWriter out, String id, String message, String debugMessage, String ApiSvcId) throws IOException {

        JSONObject jRspParam = new JSONObject();

        // 응답 파라미터 셋팅
        jRspParam.put("RSLT_CD" , id);      // 결과코드
        jRspParam.put("RSLT_MSG", message); // 결과메시지
        jRspParam.put("RESP_DATA", null);

        BizLogUtil.debug(this, "=== ["+ApiSvcId+"]Response Error Data ========================================");
        BizLogUtil.debug(this, jRspParam.toString());
        BizLogUtil.debug(this, "==============================================================================");

        //out.println(java.net.URLEncoder.encode(jRspParam.toString(), "UTF-8"));
        out.println(jRspParam.toString());
    }

}
