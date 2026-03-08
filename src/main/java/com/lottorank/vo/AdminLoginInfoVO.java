package com.lottorank.vo;

import java.time.LocalDateTime;

public class AdminLoginInfoVO {
    private String        adminId;
    private String        adminPw;
    private String        admEmailId;
    private String        admEmailAddr;
    private LocalDateTime lastLoginAt;
    private LocalDateTime createTs;
    private LocalDateTime updateTs;

    public String        getAdminId()      { return adminId; }
    public String        getAdminPw()      { return adminPw; }
    public String        getAdmEmailId()   { return admEmailId; }
    public String        getAdmEmailAddr() { return admEmailAddr; }
    public LocalDateTime getLastLoginAt()  { return lastLoginAt; }
    public LocalDateTime getCreateTs()     { return createTs; }
    public LocalDateTime getUpdateTs()     { return updateTs; }

    public void setAdminId(String adminId)           { this.adminId = adminId; }
    public void setAdminPw(String adminPw)           { this.adminPw = adminPw; }
    public void setAdmEmailId(String admEmailId)     { this.admEmailId = admEmailId; }
    public void setAdmEmailAddr(String admEmailAddr) { this.admEmailAddr = admEmailAddr; }
    public void setLastLoginAt(LocalDateTime v)      { this.lastLoginAt = v; }
    public void setCreateTs(LocalDateTime v)         { this.createTs = v; }
    public void setUpdateTs(LocalDateTime v)         { this.updateTs = v; }
}
