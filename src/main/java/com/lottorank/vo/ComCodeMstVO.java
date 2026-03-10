package com.lottorank.vo;

public class ComCodeMstVO {

    private String  codeGrpId;
    private String  codeGrpNm;
    private String  useYn;
    private Integer sortOrd;
    private String  remark;
    private String  createTs;
    private String  updateTs;

    public String  getCodeGrpId()               { return codeGrpId; }
    public void    setCodeGrpId(String v)        { this.codeGrpId = v; }

    public String  getCodeGrpNm()               { return codeGrpNm; }
    public void    setCodeGrpNm(String v)        { this.codeGrpNm = v; }

    public String  getUseYn()                   { return useYn; }
    public void    setUseYn(String v)            { this.useYn = v; }

    public Integer getSortOrd()                 { return sortOrd; }
    public void    setSortOrd(Integer v)         { this.sortOrd = v; }

    public String  getRemark()                  { return remark; }
    public void    setRemark(String v)           { this.remark = v; }

    public String  getCreateTs()                { return createTs; }
    public void    setCreateTs(String v)         { this.createTs = v; }

    public String  getUpdateTs()                { return updateTs; }
    public void    setUpdateTs(String v)         { this.updateTs = v; }
}
