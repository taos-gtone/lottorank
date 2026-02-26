package com.lottorank.vo;

public class MemberInfoChgHistVO {

    private long   memberNo;
    private String memInfoChgFldCd; // PW / EMAIL_ID / EMAIL_ADDR / MOBILE_NO
    private String beforeVal;       // 변경 전 값 (nullable)
    private String afterVal;        // 변경 후 값 (nullable)
    private String chgIp;           // 변경 요청 IP

    public long getMemberNo() { return memberNo; }
    public void setMemberNo(long memberNo) { this.memberNo = memberNo; }

    public String getMemInfoChgFldCd() { return memInfoChgFldCd; }
    public void setMemInfoChgFldCd(String memInfoChgFldCd) { this.memInfoChgFldCd = memInfoChgFldCd; }

    public String getBeforeVal() { return beforeVal; }
    public void setBeforeVal(String beforeVal) { this.beforeVal = beforeVal; }

    public String getAfterVal() { return afterVal; }
    public void setAfterVal(String afterVal) { this.afterVal = afterVal; }

    public String getChgIp() { return chgIp; }
    public void setChgIp(String chgIp) { this.chgIp = chgIp; }
}
