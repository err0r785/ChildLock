document.addEventListener("DOMContentLoaded", () => {
    // 현재 URL에서 쿼리 파라미터로 원래 방문하려던 URL을 가져오기
    function getQueryParam(param) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(param);
    }

    // "무시하고 이동" 버튼 클릭 시 실행될 함수
    document.querySelector(".button2").addEventListener("click", function () {
        const targetUrl = getQueryParam("targetUrl");
        if (targetUrl) {
            window.location.href = targetUrl; // 원래 가려던 페이지로 이동
        } else {
            alert("이동할 URL을 찾을 수 없습니다."); // 예외 처리
        }
    });

    // "이전 페이지 이동" 버튼 클릭 시 뒤로 가기
    document.querySelector(".button1").addEventListener("click", function () {
        window.history.back();
    });
});