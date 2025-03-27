package kr.spring.entity;

public class FeedbackInfo {

    // 피드백 식별자 
    private int fbIdx;

    // 사용자 이메일 
    private String userEmail;

    // 피드백 URL 
    private String fbUrl;

    // 수정 유형 
    private String fbType;

    // 수정 사유 
    private String fbExplanation;

    // 등록 날짜 
    private String createdAt;

    public int getFbIdx() {
        return fbIdx;
    }

    public void setFbIdx(int fbIdx) {
        this.fbIdx = fbIdx;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getFbUrl() {
        return fbUrl;
    }

    public void setFbUrl(String fbUrl) {
        this.fbUrl = fbUrl;
    }

    public String getFbType() {
        return fbType;
    }

    public void setFbType(String fbType) {
        this.fbType = fbType;
    }

    public String getFbExplanation() {
        return fbExplanation;
    }

    public void setFbExplanation(String fbExplanation) {
        this.fbExplanation = fbExplanation;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    // feedbackInfo 모델 복사
    public void CopyData(FeedbackInfo param)
    {
        this.fbIdx = param.getFbIdx();
        this.userEmail = param.getUserEmail();
        this.fbUrl = param.getFbUrl();
        this.fbType = param.getFbType();
        this.fbExplanation = param.getFbExplanation();
        this.createdAt = param.getCreatedAt();
    }
}