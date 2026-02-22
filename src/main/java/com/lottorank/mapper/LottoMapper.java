package com.lottorank.mapper;

import com.lottorank.vo.LottoRoundResult;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LottoMapper {
    LottoRoundResult selectLatestResult();

    List<LottoRoundResult> selectResultList(
            @Param("offset")   int offset,
            @Param("pageSize") int pageSize,
            @Param("year")     Integer year,
            @Param("round")    Integer round);

    int selectResultCount(
            @Param("year")  Integer year,
            @Param("round") Integer round);
}
