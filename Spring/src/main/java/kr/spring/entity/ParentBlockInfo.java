package kr.spring.entity;

//부모 차단 페이지 
public class ParentBlockInfo {

 // 차단 식별자 
 private int pbIdx;

 // 사용자 이메일 
 private String userEmail;

 // 차단 URL 
 private String pbUrl;

 // 등록 날짜 
 private String createdAt;

 public int getPbIdx() {
     return pbIdx;
 }

 public void setPbIdx(int pbIdx) {
     this.pbIdx = pbIdx;
 }

 public String getUserEmail() {
     return userEmail;
 }

 public void setUserEmail(String userEmail) {
     this.userEmail = userEmail;
 }

 public String getPbUrl() {
     return pbUrl;
 }

 public void setPbUrl(String pbUrl) {
     this.pbUrl = pbUrl;
 }

 public String getCreatedAt() {
     return createdAt;
 }

 public void setCreatedAt(String createdAt) {
     this.createdAt = createdAt;
 }

 // parentBlockInfo 모델 복사
 public void CopyData(ParentBlockInfo param)
 {
     this.pbIdx = param.getPbIdx();
     this.userEmail = param.getUserEmail();
     this.pbUrl = param.getPbUrl();
     this.createdAt = param.getCreatedAt();
 }
}