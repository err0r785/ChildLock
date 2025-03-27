package kr.spring.entity;

//자신 차단 페이지 
public class SelfBlockInfo {

 // 차단 식별자 
 private int sbIdx;

 // 사용자 이메일 
 private String userEmail;

 // 차단 URL 
 private String sbUrl;

 // 등록 날짜 
 private String createdAt;

 public int getSbIdx() {
     return sbIdx;
 }

 public void setSbIdx(int sbIdx) {
     this.sbIdx = sbIdx;
 }

 public String getUserEmail() {
     return userEmail;
 }

 public void setUserEmail(String userEmail) {
     this.userEmail = userEmail;
 }

 public String getSbUrl() {
     return sbUrl;
 }

 public void setSbUrl(String sbUrl) {
     this.sbUrl = sbUrl;
 }

 public String getCreatedAt() {
     return createdAt;
 }

 public void setCreatedAt(String createdAt) {
     this.createdAt = createdAt;
 }

 // selfBlockInfo 모델 복사
 public void CopyData(SelfBlockInfo param)
 {
     this.sbIdx = param.getSbIdx();
     this.userEmail = param.getUserEmail();
     this.sbUrl = param.getSbUrl();
     this.createdAt = param.getCreatedAt();
 }
}