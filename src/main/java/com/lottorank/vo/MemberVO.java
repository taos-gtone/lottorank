package com.lottorank.vo;

public class MemberVO {

    private long   memberNo;
    private String userId;
    private String userPw;
    private String userName;
    private String nickname;
    private String emailId;
    private String emailAddr;
    private String birthDate;
    private String genderCd;   // gender → gender_cd
    private String regIp;
    private int    acctStsCd;  // status → acct_sts_cd
    private String regLoginTypCd; // I:아이디, N:네이버, K:카카오
    private String socialId;      // 소셜 로그인 고유 ID (네이버/카카오 등)

    public long getMemberNo() { return memberNo; }
    public void setMemberNo(long memberNo) { this.memberNo = memberNo; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserPw() { return userPw; }
    public void setUserPw(String userPw) { this.userPw = userPw; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getEmailId() { return emailId; }
    public void setEmailId(String emailId) { this.emailId = emailId; }

    public String getEmailAddr() { return emailAddr; }
    public void setEmailAddr(String emailAddr) { this.emailAddr = emailAddr; }

    public String getBirthDate() { return birthDate; }
    public void setBirthDate(String birthDate) { this.birthDate = birthDate; }

    public String getGenderCd() { return genderCd; }
    public void setGenderCd(String genderCd) { this.genderCd = genderCd; }

    public String getRegIp() { return regIp; }
    public void setRegIp(String regIp) { this.regIp = regIp; }

    public int getAcctStsCd() { return acctStsCd; }
    public void setAcctStsCd(int acctStsCd) { this.acctStsCd = acctStsCd; }

    public String getRegLoginTypCd() { return regLoginTypCd; }
    public void setRegLoginTypCd(String regLoginTypCd) { this.regLoginTypCd = regLoginTypCd; }

    public String getSocialId() { return socialId; }
    public void setSocialId(String socialId) { this.socialId = socialId; }
}
