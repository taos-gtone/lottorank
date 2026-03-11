package com.lottorank.vo;

public class SysConfigVO {

    /** 시스템 운영 여부 (Y/N) */
    private String sysOperYn;

    /** 운영 정지 요일 (1=월 ~ 7=일) */
    private Integer sysStopDay;

    /** 운영 정지 시각 */
    private String sysStopTime;

    /** 수정 시각 */
    private String updDt;

    public String getSysOperYn()              { return sysOperYn; }
    public void   setSysOperYn(String v)      { this.sysOperYn = v; }

    public Integer getSysStopDay()            { return sysStopDay; }
    public void    setSysStopDay(Integer v)   { this.sysStopDay = v; }

    public String getSysStopTime()            { return sysStopTime; }
    public void   setSysStopTime(String v)    { this.sysStopTime = v; }

    public String getUpdDt()                  { return updDt; }
    public void   setUpdDt(String v)          { this.updDt = v; }
}
