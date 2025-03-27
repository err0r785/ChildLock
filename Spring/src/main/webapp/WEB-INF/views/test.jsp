<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 50px;
        }
        input {
            padding: 10px;
            width: 300px;
            margin-bottom: 10px;
        }
        button {
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .result {
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
            color: green;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>
    <h2>🔍 URL 분석 테스트</h2>

    <form action="analyze" method="post">
        <input type="text" name="url" placeholder="URL을 입력하세요" required>
        <br>
        <a><button type="submit">확인</button></a>
    </form>

   <%
    String result = (String)request.getAttribute("url");
%>
<p class="result">✅ 분석 결과: <strong><%= result %></strong></p>
<a href="naver.com">ㅁㅁㅁㅁㅁ</a>
</body>
</html>