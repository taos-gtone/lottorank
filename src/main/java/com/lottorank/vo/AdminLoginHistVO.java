package com.lottorank.vo;

import java.time.LocalDateTime;

public class AdminLoginHistVO {
    private long          loginHistNo;
    private String        adminId;
    private String        loginRsltCd;   // C004: "S"=성공, "F"=실패
    private String        failRsnCd;     // C005: "01"=비밀번호불일치, "02"=없는계정, "03"=계정비활성
    private String        loginIp;
    private String        userAgent;
    private LocalDateTime loginAt;
    private LocalDateTime logoutAt;

    public long          getLoginHistNo() { return loginHistNo; }
    public String        getAdminId()     { return adminId; }
    public String        getLoginRsltCd() { return loginRsltCd; }
    public String        getFailRsnCd()   { return failRsnCd; }
    public String        getLoginIp()     { return loginIp; }
    public String        getUserAgent()   { return userAgent; }
    public LocalDateTime getLoginAt()     { return loginAt; }
    public LocalDateTime getLogoutAt()    { return logoutAt; }

    public void setLoginHistNo(long v)         { this.loginHistNo = v; }
    public void setAdminId(String v)           { this.adminId = v; }
    public void setLoginRsltCd(String v)       { this.loginRsltCd = v; }
    public void setFailRsnCd(String v)         { this.failRsnCd = v; }
    public void setLoginIp(String v)           { this.loginIp = v; }
    public void setUserAgent(String v)         { this.userAgent = v; }
    public void setLoginAt(LocalDateTime v)    { this.loginAt = v; }
    public void setLogoutAt(LocalDateTime v)   { this.logoutAt = v; }
}
