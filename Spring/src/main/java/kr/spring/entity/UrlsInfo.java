package kr.spring.entity;

public class UrlsInfo {

    // URL 식별자 
    private int urlIdx;

    // URL 주소 
    private String urlLink;

    // URL 유형 
    private String urlType;

    public int getUrlIdx() {
        return urlIdx;
    }

    public void setUrlIdx(int urlIdx) {
        this.urlIdx = urlIdx;
    }

    public String getUrlLink() {
        return urlLink;
    }

    public void setUrlLink(String urlLink) {
        this.urlLink = urlLink;
    }

    public String getUrlType() {
        return urlType;
    }

    public void setUrlType(String urlType) {
        this.urlType = urlType;
    }

    // urlsInfo 모델 복사
    public void CopyData(UrlsInfo param)
    {
        this.urlIdx = param.getUrlIdx();
        this.urlLink = param.getUrlLink();
        this.urlType = param.getUrlType();
    }
}