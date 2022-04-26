package com.avatar.comm;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;

import kr.co.coocon.sasapi.cert.CertManager3;

public class CertUtils {

	public static boolean verifyPassword(String cert_data, String cert_pwd) {

		boolean bResult = false;

		//base64 인코딩된 개인키 파일(signPri.key)
        //String priKey = "MIIFEDAaBggqgxqMmkQBDzAOBAhAYHdzDZfIVAICCAAEggTw2+XvTd6GXx1lHPQLTvNyaW6Noih5nZD7sxyVGKxU4GpfglS3cE7y6sITHD5jxhf18oj9dmNszOAtJJ64b1JPN8zUmzGE1m0hlJ90cWjhqJYXpq/63Iz8BVg+ZJ3oWpcx1oQjwxf4k26zsEThV3i7pIUZV1w5G39KYlsdabz5LTq5xAaaswdfXB254sHth8k/Zvey+Tfb5RHMEl6Fu9dotv91MVcpmx/kQJCVKlNmSkezC+0jOk9x0MVRCp61ULJUEw2G+s8hFu8VVcMfqbt1g2ymx/U2JoD+rHZZGGq1wD+CP7FMCwFlEEEofGhjsmo1wQX6eTKAYizRUbmmNykIzd574QD2VxXlVNZkR9hu27eWzWIHtVftTAYrQv/uooqHrdTn6Lf/5r4Cu8g6DSlN+Nr5YibNt6dtCrvzZPPNezvmmQNshyHqrnQNqkvgEri3QS7sVtQOqqmYVdX1xNdw9HRAEeh5bTrthPilsV55U3GXqSa6NWhBCx7oWI072kgqoIRUdLrHMTRADHG5rtSRYimME95kFRODw3v6h/2AmQQ7MhTnY5sQatKl/0TdhbUntgZA6wfwRKyUCLvxpOmXydqHekr09V9IzneGrq7ygskO5B3522tEV+XWz947TlcZTsuGgCrb23mu6sbCLGU7z5hoGsI+scb7wbObjVkxeP4rX1F3CzQIAkT9OWG6uhL8kn2AQsA5GTvWThwLd40gHC00q15EYXnx1SFhikn9ssjQHu1UvNROmZI8g3nNIAW5j+gZMxMuRukVPkF6gQClypVliNw7ogoFFoXqQL5kHWWaAzf9N0ItBxFFDJouSXW+qVKtmUPgdUpDMPHbU/C2Rdhdkz1FtQVlH9ZpEuXShhs0MmG1lIrE5WTK7dCVfkI4wMV01Bp3ADcCsSLyjJOcOFDuIDSPvDl8TT0/QvxH3DgTUTvbNT2QEQt4JEBwe8/6HesdVjf472B6sJNaUUPz8lmBgfZuO1McrHSd4qwinJ6cm9ULNllavrsxxeWW9EFBkRx7BHGjQnDgfq2USPisMDJvPqabemPAqGTCREmoPzIjJYUiGXiCHomeOtSoc73bjdc6v/3bHz+Vpmvr9vSfDgsmyRx0MIqaZlDdBQ0UpjKuBNzZYLPjPalzTCSRRaB2B5E1bkiWsApLb8MvN3+D5PqMzadWej1CCT/Dfq98xXYpKGre1RY/9RhtmCdhUQHKkiucpah5++cCQnjPJZ/hjnCl/oBgwVcChierBbi1ufkyMc02fcaORopjQNdgSsnH0GzD54A+OU7hbeW0JFL3fq6gU0ifMizpsdp87xqU2N+BbD1V8TxOL3p7I6mg6KdJDmMuvK8lQNZLpnTsVjHjOBBQB/6AO8FjaclZ3v5KlPhLPhljZIjoKIUsiUE5lxU9XXGmcyP5j9y4urE7OfJWhlRJ841jOXX9USSYF6HwY4GGQAV871SdkhdGFt2AXfCgGzfvfkbAKlZeyo6GLx1MXimU2LlNF1psmxy2CCaljki/S/6Y1Kr9j+odb1Y7eaqmmv/3Y+4+AzEHlbpuDrWrpoqgcxQFikm4J+xyYtbneb7jswp8QBrQ9KhD9wJrbF0Zn0LnB1kMFtEkA3E5W7wFiXanF7qblNr571Q2nkLjCU4n42168yXuQEQiyCecoWBxPSFehj/+PXYi5KC7V2lCIg==";
		String priKey = CommUtil.getCertPriKeyBase64(cert_data);
        //비밀번호 검증만 하시기때문에 공개키는 공백만 아니게 설정해주시면 됩니다.
        String pubKey = "pubKey";

        //json 형식으로 데이터 만들기
        JSONObject obj = new JSONObject();
        obj.put("개인키파일", priKey);
        obj.put("인증서파일", pubKey);

        CertManager3 cm = new CertManager3();

        try {
            //인증서 파일 정보 내부에 설정(true: 성공, false:실패)
            if(cm.findCert(obj.toJSONString())) {
                System.out.println("인증서 파일 설정 완료");
                bResult = true;
            } else {
                System.out.println("인증서 파일 설정 실패");
                bResult = false;
            }

            //내부에 설정된 개인키파일과 비밀번호로 검증(true: 성공, false:실패)
            if(cm.verifyPassword(cert_pwd)) {
                System.out.println("인증서 비밀번호 검증 완료");
                bResult = true;
            } else {
                System.out.println("인증서 비밀번호 검증 실패");
                bResult = false;
            }

        } catch (ParseException e) {
            e.printStackTrace();
            bResult = false;
        }

        return bResult;
	}
}
