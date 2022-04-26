<%//@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>KCB 휴대폰 본인확인 서비스 임베디드형 일반인증 샘플 1</title>
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
	<form name="form1" action="phone_normal2.jsp" method="post">
		<table>
			<tr>
				<td colspan="2"><strong> - KCB 휴대폰 본인확인 서비스 임베디드형 일반인증</strong></td>
			</tr>
			<tr>
				<td>성명</td>
				<td>
					<input type="text" name="NAME" maxlength="20" size="20" value="">
				</td>
			</tr>
			<tr>
				<td>생년월일</td>
				<td>
					<input type="text" name="BIRTHDAY" maxlength="8" size="10" value=""> (예:'19700101')
				</td>
			</tr>
			<tr>
				<td>성별</td>
				<td>
					<input type="radio" name="SEX_CD" value="M" checked>남
					<input type="radio" name="SEX_CD" value="F">여
			</tr>
			<tr>
				<td>내외국인구분</td>
				<td>
					<input type="radio" name="NTV_FRNR_CD" value="L" checked>내국인
					<input type="radio" name="NTV_FRNR_CD" value="F">외국인
			</tr>
			<tr>
				<td>휴대폰</td>
				<td>
					<select name="TEL_COM_CD">
						<option value="01">SKT</option>
						<option value="02">KT</option>
						<option value="03">LGU+</option>
						<option value="04">알뜰폰SKT</option>
						<option value="05">알뜰폰KT</option>
						<option value="06">알뜰폰LGU+</option>
					</select>
					<input type="text" name="TEL_NO" maxlength="11" size="15" value=""> ('-'없이 입력)
				</td>
			</tr>
			<tr>
				<td>인증요청사유코드</td>
				<td>
					<select name="RQST_CAUS_CD">
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
				<td>회원사코드</td>
				<td>
					<input type="text" name="CP_CD" maxlength="12" size="16" value="V22530000014">
				</td>
			</tr>
			<tr>
				<td>AppHash문자열(옵션)</td>
				<td>
					<input type="text" name="APP_HASH_STR" maxlength="15" size="16" value="">
				</td>
			</tr>
			<tr>
				<td>개인정보 수집/이용/취급위탁 동의</td>
				<td>
					<input type="checkbox" name="AGREE1" value="Y">
				</td>
			</tr>
			<tr>
				<td>고유식별정보처리 동의 </td>
				<td>
					<input type="checkbox" name="AGREE2" value="Y">
				</td>
			</tr>
			<tr>
				<td>본인확인서비스 이용약관 </td>
				<td>
					<input type="checkbox" name="AGREE3" value="Y">
				</td>
			</tr>
			<tr>
				<td>통신사 이용약관 동의</td>
				<td>
					<input type="checkbox" name="AGREE4" value="Y">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="button" value="확인" onClick="jsSubmit();"></td>
			</tr>
		</table>
	</form>
</body>
</html>
