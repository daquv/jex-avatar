<%//@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>KCB 휴대폰 본인확인 서비스 임베디드형 간편인증 샘플 1</title>
<script>
<!--
	function jsSubmit(){	
		var form1 = document.form1;
		form1.submit();
	}
//-->
</script>
</head>
<body>
	<form NAME="form1" action="phone_simple2.jsp" method="post">
		<table>
			<tr>
				<td colspan="2"><strong> - KCB 휴대폰 본인확인 서비스 임베디드형 간편인증</strong></td>
			</tr>
			<tr>
				<td>성명</td>
				<td>
					<input type="text" NAME="NAME" maxlength="20" size="20" value="">
				</td>
			</tr>
			<tr>
				<td>휴대폰</td>
				<td>
					<select NAME="TEL_COM_CD">
						<option value="01">SKT</option>
						<option value="02">KT</option>
						<option value="03">LGU+</option>
						<option value="05">알뜰폰KT</option>
						<option value="06">알뜰폰LGU+</option>
					</select>
					<input type="text" NAME="TEL_NO" maxlength="11" size="15" value=""> ('-'없이 입력)
				</td>
			</tr>
			<tr>
				<td>회원사코드</td>
				<td>
					<input type="text" NAME="CP_CD" maxlength="12" size="16" value="V22530000014">
				</td>
			</tr>
			<tr>
				<td>인증요청사유코드</td>
				<td>
					<select NAME="RQST_CAUS_CD">
						<option value="00">회원가입</option>
						<option value="01">성인인증</option>
						<option value="02">회원정보수정</option>
						<option value="03">비밀번호찾기</option>
						<option value="04">상품구매</option>
						<option value="99">기타</option>
						<option value="EC">EC</option>
					</select>
				</td>
			</tr>			
			<tr>
				<td>개인정보 수집/이용/취급위탁 동의</td>
				<td>
					<input type="checkbox" NAME="AGREE1" value="Y">
				</td>
			</tr>
			<tr>
				<td>고유식별정보처리 동의 </td>
				<td>
					<input type="checkbox" NAME="AGREE2" value="Y">
				</td>
			</tr>
			<tr>
				<td>본인확인서비스 이용약관 </td>
				<td>
					<input type="checkbox" NAME="AGREE3" value="Y">
				</td>
			</tr>
			<tr>
				<td>통신사 이용약관 동의</td>
				<td>
					<input type="checkbox" NAME="AGREE4" value="Y">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="button" value="확인" onClick="jsSubmit();"></td>
			</tr>
		</table>
	</form>
</body>
</html>
