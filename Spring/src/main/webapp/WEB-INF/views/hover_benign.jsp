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
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: rgba(0, 0, 0, 0.2);
        }
        .alert-box {
            background: rgb(235, 233, 233);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 400px;
            position: relative;
            opacity: 0.9;
        }
        .close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
            font-size: 16px;
        }
        .alert-icon {
            font-size: 35px;
            color: green;
            margin-bottom: 10px;
        }
        .alert-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
            color: green;
        }
        .url {
            color: blue;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .message {
            font-size: 14px;
            color: #333;
            margin-bottom: 15px;
        }
        .progress-container {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            color: #666;
            margin-top: 10px;
        }
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #ddd;
            border-radius: 5px;
            overflow: hidden;
            position: relative;
        }
        .progress-fill {
            height: 100%;
            width: 0%;
            background: green;
            border-radius: 5px;
            transition: width 0.5s ease-in-out, background-color 0.5s ease-in-out;
        }
        .buttons {
            display: flex;
            justify-content: center;
            margin-top: 10px;
        }
        .btn {
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 12px;
            background: #4CAF50;
            color: white;
        }
        .btn:hover {
            background: #45a049;
        }
    </style>
</head>
<body>
<div class="alert-box">
        <div class="close-btn">✖</div>
        <div class="alert-icon">🟢</div>
        <div class="alert-title">안전한 페이지</div>
        <div class="url">주소: <br><strong><%= request.getAttribute("url") %></strong></div>
        <hr style="box-shadow: 0px 0px 1px 0px;">
        <div class="message">
            이 사이트는 안전한 것으로 확인되었습니다.<br>
            안심하고 이용하셔도 좋습니다.
        </div>
        <div class="progress-container">
            <span><strong id="risk-label" style="color: rgb(247, 43, 43);">위험도</strong> <span id="risk-percentage">75%</span></span>
            <div class="progress-bar">
                <div class="progress-fill" id="progress-fill"></div>
            </div>
        </div>
        
        <script>
            function updateProgressBar(riskPercentage) {
                const progressFill = document.getElementById("progress-fill");
                const riskLabel = document.getElementById("risk-label");
                const riskText = document.getElementById("risk-percentage");
        
                // 위험도 텍스트 업데이트
                riskText.textContent = riskPercentage + "%";
        
                // 진행 바 너비 업데이트
                progressFill.style.width = riskPercentage + "%";
        
                // 색상 변경 로직
                if (riskPercentage <= 30) {
                    progressFill.style.backgroundColor = "green";
                    riskLabel.style.color = "green";
                } else if (riskPercentage <= 60) {
                    progressFill.style.backgroundColor = "orange";
                    riskLabel.style.color = "orange";
                } else {
                    progressFill.style.backgroundColor = "red";
                    riskLabel.style.color = "red";
                }
            }
        
            // 초기 위험도 설정 (원하는 값으로 변경 가능)
            updateProgressBar(10);
        </script>
        <div class="buttons">
            <button class="btn">계속하기</button>
        </div>
    </div>
</body>
</html>