package com.lottorank.vo;

public class ComCodeDtlVO {

    private String  codeGrpId;
    private String  codeId;
    private String  codeNm;
    private String  codeNmEn;
    private String  useYn;
    private Integer sortOrd;
    private String  etcVal1;
    private String  etcVal2;
    private String  remark;
    private String  createTs;
    private String  updateTs;

    public String  getCodeGrpId()               { return codeGrpId; }
    public void    setCodeGrpId(String v)        { this.codeGrpId = v; }

    public String  getCodeId()                  { return codeId; }
    public void    setCodeId(String v)           { this.codeId = v; }

    public String  getCodeNm()                  { return codeNm; }
    public void    setCodeNm(String v)           { this.codeNm = v; }

    public String  getCodeNmEn()                { return codeNmEn; }
    public void    setCodeNmEn(String v)         { this.codeNmEn = v; }

    public String  getUseYn()                   { return useYn; }
    public void    setUseYn(String v)            { this.useYn = v; }

    public Integer getSortOrd()                 { return sortOrd; }
    public void    setSortOrd(Integer v)         { this.sortOrd = v; }

    public String  getEtcVal1()                 { return etcVal1; }
    public void    setEtcVal1(String v)          { this.etcVal1 = v; }

    public String  getEtcVal2()                 { return etcVal2; }
    public void    setEtcVal2(String v)          { this.etcVal2 = v; }

    public String  getRemark()                  { return remark; }
    public void    setRemark(String v)           { this.remark = v; }

    public String  getCreateTs()                { return createTs; }
    public void    setCreateTs(String v)         { this.createTs = v; }

    public String  getUpdateTs()                { return updateTs; }
    public void    setUpdateTs(String v)         { this.updateTs = v; }
}
