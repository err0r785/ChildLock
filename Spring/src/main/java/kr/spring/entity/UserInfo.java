package kr.spring.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "user_info") // MySQL 테이블명 지정
public class UserInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Primary Key 자동 증가
    private Long id;

    @Column(nullable = false, unique = true) // NOT NULL & UNIQUE 제약 조건 추가
    private String userEmail;

    @Column(nullable = false) // NOT NULL 제약 조건 추가
    private String userName;

    @Column
    private String parentEmail;

    // 🔹 기본 생성자 (JPA를 위해 필수)
    public UserInfo() {}

    // 🔹 사용자 정보 저장을 위한 생성자 추가
    public UserInfo(String userEmail, String userName, String parentEmail) {
        this.userEmail = userEmail;
        this.userName = userName;
        this.parentEmail = parentEmail;
    }

    // 🔹 Getter & Setter
    public Long getId() {
        return id;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getParentEmail() {
        return parentEmail;
    }

    public void setParentEmail(String parentEmail) {
        this.parentEmail = parentEmail;
    }
}
