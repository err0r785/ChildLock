document.addEventListener("DOMContentLoaded", () => {
    // ✅ 저장된 userEmail 값을 hidden input에 채워 넣기
    chrome.storage.local.get("userEmail", (data) => {
        if (data.userEmail) {
            const userEmailInput = document.getElementById("userEmailInput");
            if (userEmailInput) {
                userEmailInput.value = data.userEmail;
                console.log("userEmail 자동 입력됨:", data.userEmail);
            }
        } else {
            console.warn("userEmail이 chrome.storage.local에 존재하지 않습니다.");
        }
    });

    const feedbackForm = document.getElementById("feedback");
    if (feedbackForm) {
        feedbackForm.addEventListener("submit", (e) => {
            e.preventDefault();

            const formData = new FormData(feedbackForm);
            const jsonData = {};
            formData.forEach((value, key) => {
                jsonData[key] = value;
            });

            fetch("http://localhost:8081/childlock/userinfo/update", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(jsonData)
            })
            .then(response => response.json())
            .then(data => {
                console.log("서버 응답:", data);
            })
            .catch(error => {
                console.error("POST 요청 에러:", error);
            });
        });
    }
});
