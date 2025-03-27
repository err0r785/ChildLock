<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>

@font-face {
    font-family: 'EliceDigitalBaeum-Bd';
    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_elice@1.0/EliceDigitalBaeum-Bd.woff2') format('woff2');
    font-weight: normal;
    font-style: normal;
}

*,
*::after,
*::before {
  box-sizing: border-box; /* Compass @include box-sizing 대신 사용 */
}

html{
  background: #000;
  font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
}

head {
  display: block;
  position: relative;
  width: 200px;
  margin: 7% auto 0;
  animation: shvr 0.2s infinite;
}

head::after {
  content: "";
  width: 20px;
  height: 20px;
  background: #000;
  position: absolute;
  top: 30px;
  left: 25px;
  border-radius: 50%;
  box-shadow: 125px 0 0 #000;
  animation: eye 2.5s infinite;
}

meta {
  position: relative;
  display: inline-block;
  background: #fff;
  width: 75px;
  height: 80px;
  border-radius: 50% / 45px 45px 45% 45%; /* Sass @include 제거 */
  transform: rotate(45deg); /* @include rotate 제거 */
}

meta::after {
  content: "";
  position: absolute;
  border-bottom: 2px solid #fff;
  width: 70px;
  height: 50px;
  left: 0px;
  bottom: -10px;
  border-radius: 50%;
}

meta::before {
  bottom: auto;
  top: -100px;
  transform: rotate(45deg);
  left: 0;
}

meta:nth-of-type(2) {
  float: right;
  transform: rotate(-45deg);
}

meta:nth-of-type(2)::after {
  left: 5px;
}

meta:nth-of-type(3) {
  display: none;
}

body {
  margin-top: 100px;
  text-align: center;
  color: #fff;
}

body::before {
  font-family: 'EliceDigitalBaeum-Bd';
  content: "이 페이지에서 위험이 발견되었어요..ㄷㄷ";
  font-size: 60px;
  font-weight: 800;
  display: block;
  margin-bottom: 10px;
}

.text1 {
  font-family: 'EliceDigitalBaeum-Bd';
  color: #ff0000;
  font-size: 40px;
  display: inline-block;
  overflow: hidden;
  animation: blink 0.5s step-start infinite; /* 두 개의 애니메이션 적용 */
  margin-top: 0px;
  font-weight: 600;
}

@keyframes marquee {
  from {
    transform: translateX(100%);
  }
  to {
    transform: translateX(-100%);
  }
}


@keyframes blink {
  50% {
    opacity: 0;
  }
}

.text{
    margin-top: -20px;
}

.text2{
    font-family: 'EliceDigitalBaeum-Bd';
    font-size: 38px;
}

.text3{
    font-family: 'EliceDigitalBaeum-Bd';
    font-size: 38px;
    margin-top: -30px;
}

.text4{
    font-family: 'EliceDigitalBaeum-Bd';
    font-size: 38px;
    margin-top: px;
}

@keyframes eye {
  0%,
  30%,
  55%,
  90%,
  100% {
    transform: translate(0, 0);
  }
  10%,
  25% {
    transform: translate(0, 20px);
  }
  65% {
    transform: translate(-20px, 0);
  }
  80% {
    transform: translate(20px, 0);
  }
}

@keyframes shvr {
  0% {
    transform: translateX(1px);
  }
  50% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-1px);
  }
}

@keyframes text-show {
  to {
    text-indent: -373px;
  }
}

.button-container {
  display: flex; /* 👉 버튼을 가로로 정렬 */
  justify-content: center; /* 👉 가운데 정렬 (필요시 변경 가능) */
  gap: 150px; /* 👉 버튼 사이 간격 설정 */
  margin-top: 80px;
  margin-left: ; /* 필요하면 위치 조정 */
}

.button1, .button2 {
  font-family: 'EliceDigitalBaeum-Bd';
  display: flex;
  height: 2.5em;
  width: 250px;
  align-items: center;
  justify-content: center; /* 텍스트 중앙 정렬 */
  background-color: #ffffff;
  border-radius: 8px;
  letter-spacing: 1px;
  transition: all 0.2s linear;
  cursor: pointer;
  border: none;
  background: #fff;
  padding-left: 0px;
  padding-right: 10px;
  font-size: 25px;
  font-weight: bold;
  margin-top: -20px;
}

.button2{
  font-size: 25px
}

.button1 > svg, .button2 > svg {
  margin-right: 5px;
  margin-left: 5px;
  font-size: 20px;
  transition: all 0.4s ease-in;
}

.button1:hover > svg, .button2:hover > svg {
  font-size: 1.5em;
  transform: translateX(-5px);
}

.button1:hover, .button2:hover {
  box-shadow: 9px 9px 33px #d1d1d1, -9px -9px 33px #ffffff;
  transform: translateY(-1px);
}

    </style>
</head>
<body>

    <p class="text1">악성 코드... 피싱... 개인 정보 유출...???? hmmm</p>
    <div class="text">
        <p class="text2">이 사이트는 악성 코드, 피싱, 개인정보 유출</p>
        <p class="text3">위험이 있을 수 있습니다!!</p>
        <p class="text4">그래도 방문 하시겠습니까??</p>
    </div>
<div class="button-container">
    <button class="button1">
        <svg height="16" width="16" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 1024 1024"><path d="M874.690416 495.52477c0 11.2973-9.168824 20.466124-20.466124 20.466124l-604.773963 0 188.083679 188.083679c7.992021 7.992021 7.992021 20.947078 0 28.939099-4.001127 3.990894-9.240455 5.996574-14.46955 5.996574-5.239328 0-10.478655-1.995447-14.479783-5.996574l-223.00912-223.00912c-3.837398-3.837398-5.996574-9.046027-5.996574-14.46955 0-5.433756 2.159176-10.632151 5.996574-14.46955l223.019353-223.029586c7.992021-7.992021 20.957311-7.992021 28.949332 0 7.992021 8.002254 7.992021 20.957311 0 28.949332l-188.073446 188.073446 604.753497 0C865.521592 475.058646 874.690416 484.217237 874.690416 495.52477z"></path></svg>
        <span>이전 페이지 이동</span>
    </button>
    <button class="button2">
        <svg height="16" width="16" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 1024 1024"><path d="M874.690416 495.52477c0 11.2973-9.168824 20.466124-20.466124 20.466124l-604.773963 0 188.083679 188.083679c7.992021 7.992021 7.992021 20.947078 0 28.939099-4.001127 3.990894-9.240455 5.996574-14.46955 5.996574-5.239328 0-10.478655-1.995447-14.479783-5.996574l-223.00912-223.00912c-3.837398-3.837398-5.996574-9.046027-5.996574-14.46955 0-5.433756 2.159176-10.632151 5.996574-14.46955l223.019353-223.029586c7.992021-7.992021 20.957311-7.992021 28.949332 0 7.992021 8.002254 7.992021 20.957311 0 28.949332l-188.073446 188.073446 604.753497 0C865.521592 475.058646 874.690416 484.217237 874.690416 495.52477z"></path></svg>
        <span>무시하고 이동</span>
    </button>
</div>
</body>
</html>