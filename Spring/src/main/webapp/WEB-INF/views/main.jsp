<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>🔍 URL 분석 테스트</h2>

    <form action="analyze" method="post">
        <input type="text" name="url" placeholder="URL을 입력하세요" required>
        <button type="submit">확인</button>
    </form>

    <% 
   		ArrayList<String> result = (ArrayList<String>) request.getAttribute("result");
        if (result != null) { 
    %>
        <p>✅ 분석 결과: <strong><%= result.get(0) %></strong></p>
    <% } %>
</body>
</html>