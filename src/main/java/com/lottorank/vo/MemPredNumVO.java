package com.lottorank.vo;

import java.util.Date;

public class MemPredNumVO {

    private int    roundNo;
    private long   memberNo;
    private int    predNum;
    private String hitYn;
    private Date   submitAt;
    private Date   createTs;
    private Date   updateTs;

    public int getRoundNo()           { return roundNo; }
    public void setRoundNo(int v)     { this.roundNo = v; }

    public long getMemberNo()         { return memberNo; }
    public void setMemberNo(long v)   { this.memberNo = v; }

    public int getPredNum()           { return predNum; }
    public void setPredNum(int v)     { this.predNum = v; }

    public String getHitYn()          { return hitYn; }
    public void setHitYn(String v)    { this.hitYn = v; }

    public Date getSubmitAt()         { return submitAt; }
    public void setSubmitAt(Date v)   { this.submitAt = v; }

    public Date getCreateTs()         { return createTs; }
    public void setCreateTs(Date v)   { this.createTs = v; }

    public Date getUpdateTs()         { return updateTs; }
    public void setUpdateTs(Date v)   { this.updateTs = v; }
}
