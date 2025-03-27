document.addEventListener("DOMContentLoaded", function () {
    const myVideoElement = document.getElementById("my-video");

    if (myVideoElement && typeof videojs !== 'undefined') {
        var player = videojs(myVideoElement, {
            autoplay: true,  // ✅ 자동 재생
            loop: true,      // ✅ 반복 재생
            muted: true,     // ✅ 음소거 (자동재생 허용)
        });

        console.log("🎥 Video.js 플레이어가 성공적으로 로드되었습니다.");
    } else {
        console.warn("⚠️ videojs 또는 my-video 요소를 찾을 수 없습니다.");
    }

    // ✅ "돌아가기" 버튼 동작
    const backButton = document.getElementById("backBtn");
    if (backButton) {
        backButton.addEventListener("click", function () {
            if (window.history.length > 1) {
                window.history.back();
            } else {
                window.location.href = "https://www.google.com";
            }
        });
    }
});
