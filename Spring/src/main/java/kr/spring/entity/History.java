package kr.spring.entity;

import java.net.MalformedURLException;
import java.net.URL;

//사용자 기록 
public class History {

	// URL 식별자
	private int hisIdx;

	// URL 주소
	private String hisUrl;

	// 사용자 이메일
	private String userEmail;

	// 등록날짜
	private String createdAt;

	private String title;

	public int getHisIdx() {
		return hisIdx;
	}

	public void setHisIdx(int hisIdx) {
		this.hisIdx = hisIdx;
	}

	public String getHisUrl() {
		return hisUrl;
	}

	public void setHisUrl(String hisUrl) {
		this.hisUrl = hisUrl;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	// history 모델 복사
	public void CopyData(History param) {
		this.hisIdx = param.getHisIdx();
		this.hisUrl = param.getHisUrl();
		this.userEmail = param.getUserEmail();
		this.createdAt = param.getCreatedAt();
	}

	public String getShortUrl() {
		try {
			URL url = new URL(this.hisUrl);
			String domain = url.getHost();
			String path = url.getPath();
			String query = url.getQuery();

			String fullPath = domain + path;
			if (query != null && !query.isEmpty()) {
				fullPath += "?" + query;
			}

			if (fullPath.length() > 40) {
				return fullPath.substring(0, 40) + "...";
			}
			return fullPath;

		} catch (MalformedURLException e) {
			// URL이 비정상일 경우 원래 URL 일부만 잘라서 반환
			return hisUrl.length() > 40 ? hisUrl.substring(0, 40) + "..." : hisUrl;
		}
	}
}