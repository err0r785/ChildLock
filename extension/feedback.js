document.addEventListener("DOMContentLoaded", () => {

    const feedbackForm = document.getElementById("feedback");
    const userEmailInput = document.getElementById("userEmailInput");

    // 페이지 로딩 시, 저장된 userEmail 값을 숨겨진 input에 넣기
    chrome.storage.local.get("userEmail", (data) => {
        if (data.userEmail) {
            document.getElementById("userEmailInput").value = data.userEmail;
        }
    });

    // 폼의 submit 이벤트에 대한 리스너 추가
    if (feedbackForm) {
        feedbackForm.addEventListener("submit", (e) => {
            e.preventDefault();
            // 폼 데이터를 JSON 객체로 변환
            const formData = new FormData(feedbackForm);
            const jsonData = {};
            formData.forEach((value, key) => {
                jsonData[key] = value;
            });

            fetch("http://localhost:8081/childlock/userinfo/feedback", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(jsonData)
            })
                .then(response => {
                    console.log("응답 상태:", response.status);
                    return response.text().then(text => {
                        try {
                            return JSON.parse(text);
                        } catch (err) {
                            console.error("응답 파싱 에러:", err, text);
                            throw err;
                        }
                    });
                })
                .then(data => {
                    console.log("서버 응답:", data);

                    // ✅ 입력 폼 초기화
                    feedbackForm.reset();

                    // ✅ radio 체크박스도 수동 해제 (일부 브라우저에서 reset으로는 안 될 수 있음)
                    const radios = document.querySelectorAll('input[name="fbType"]');
                    radios.forEach(radio => radio.checked = false);

                    // ✅ userEmail은 다시 넣어줘야 함
                    chrome.storage.local.get("userEmail", (data) => {
                        if (data.userEmail) {
                            document.getElementById("userEmailInput").value = data.userEmail;
                        }
                    });
                })
                .catch(error => {
                    console.error("POST 요청 에러:", error);
                });
        });
    }
});
