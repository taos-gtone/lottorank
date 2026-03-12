package com.lottorank.vo;

public class SysConfigVO {

    /** 시스템 운영 여부 (Y/N) */
    private String sysOperYn;

    /** 시스템 점검 시작 요일 (1=월 ~ 7=일) */
    private Integer sysMntSttDay;

    /** 시스템 점검 시작 시각 */
    private String sysMntSttTime;

    /** 시스템 점검 종료 요일 (1=월 ~ 7=일) */
    private Integer sysMntEndDay;

    /** 시스템 점검 종료 시각 */
    private String sysMntEndTime;

    /** 예측 불가 시작 요일 (1=월 ~ 7=일) */
    private Integer predBanSttDay;

    /** 예측 불가 시작 시각 */
    private String predBanSttTime;

    /** 예측 불가 종료 요일 (1=월 ~ 7=일) */
    private Integer predBanEndDay;

    /** 예측 불가 종료 시각 */
    private String predBanEndTime;

    /** 수정 시각 */
    private String updDt;

    public String getSysOperYn()               { return sysOperYn; }
    public void   setSysOperYn(String v)       { this.sysOperYn = v; }

    public Integer getSysMntSttDay()           { return sysMntSttDay; }
    public void    setSysMntSttDay(Integer v)  { this.sysMntSttDay = v; }

    public String getSysMntSttTime()           { return sysMntSttTime; }
    public void   setSysMntSttTime(String v)   { this.sysMntSttTime = v; }

    public Integer getSysMntEndDay()           { return sysMntEndDay; }
    public void    setSysMntEndDay(Integer v)  { this.sysMntEndDay = v; }

    public String getSysMntEndTime()           { return sysMntEndTime; }
    public void   setSysMntEndTime(String v)   { this.sysMntEndTime = v; }

    public Integer getPredBanSttDay()          { return predBanSttDay; }
    public void    setPredBanSttDay(Integer v) { this.predBanSttDay = v; }

    public String getPredBanSttTime()          { return predBanSttTime; }
    public void   setPredBanSttTime(String v)  { this.predBanSttTime = v; }

    public Integer getPredBanEndDay()          { return predBanEndDay; }
    public void    setPredBanEndDay(Integer v) { this.predBanEndDay = v; }

    public String getPredBanEndTime()          { return predBanEndTime; }
    public void   setPredBanEndTime(String v)  { this.predBanEndTime = v; }

    public String getUpdDt()                   { return updDt; }
    public void   setUpdDt(String v)           { this.updDt = v; }
}
