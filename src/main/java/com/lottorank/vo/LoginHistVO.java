package com.lottorank.vo;

public class LoginHistVO {

    private Long   memberNo;     // nullable — 계정 없을 경우 null
    private String userId;
    private String loginTypCd;   // I:아이디, N:네이버, K:카카오
    private String loginRsltCd;  // S:성공, F:실패
    private String failRsnCd;    // nullable — 실패사유코드 C005
    private String loginIp;
    private String sessionId;    // nullable — 실패 시 null
    private String userAgent;    // nullable

    public Long   getMemberNo()    { return memberNo; }
    public void   setMemberNo(Long memberNo)     { this.memberNo = memberNo; }

    public String getUserId()      { return userId; }
    public void   setUserId(String userId)       { this.userId = userId; }

    public String getLoginTypCd()  { return loginTypCd; }
    public void   setLoginTypCd(String loginTypCd) { this.loginTypCd = loginTypCd; }

    public String getLoginRsltCd() { return loginRsltCd; }
    public void   setLoginRsltCd(String loginRsltCd) { this.loginRsltCd = loginRsltCd; }

    public String getFailRsnCd()   { return failRsnCd; }
    public void   setFailRsnCd(String failRsnCd) { this.failRsnCd = failRsnCd; }

    public String getLoginIp()     { return loginIp; }
    public void   setLoginIp(String loginIp)     { this.loginIp = loginIp; }

    public String getSessionId()   { return sessionId; }
    public void   setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getUserAgent()   { return userAgent; }
    public void   setUserAgent(String userAgent) { this.userAgent = userAgent; }
}
