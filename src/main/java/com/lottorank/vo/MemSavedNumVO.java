package com.lottorank.vo;

public class MemSavedNumVO {

    private int    roundNo;
    private long   memberNo;
    private int    numSetNo;
    private int    num1;
    private int    num2;
    private int    num3;
    private int    num4;
    private int    num5;
    private int    num6;
    private String memo;
    private String hitYn;

    public int getRoundNo()           { return roundNo; }
    public void setRoundNo(int v)     { this.roundNo = v; }

    public long getMemberNo()         { return memberNo; }
    public void setMemberNo(long v)   { this.memberNo = v; }

    public int getNumSetNo()          { return numSetNo; }
    public void setNumSetNo(int v)    { this.numSetNo = v; }

    public int getNum1()              { return num1; }
    public void setNum1(int v)        { this.num1 = v; }

    public int getNum2()              { return num2; }
    public void setNum2(int v)        { this.num2 = v; }

    public int getNum3()              { return num3; }
    public void setNum3(int v)        { this.num3 = v; }

    public int getNum4()              { return num4; }
    public void setNum4(int v)        { this.num4 = v; }

    public int getNum5()              { return num5; }
    public void setNum5(int v)        { this.num5 = v; }

    public int getNum6()              { return num6; }
    public void setNum6(int v)        { this.num6 = v; }

    public String getMemo()           { return memo; }
    public void setMemo(String v)     { this.memo = v; }

    public String getHitYn()          { return hitYn; }
    public void setHitYn(String v)    { this.hitYn = v; }
}
