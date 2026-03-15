package com.lottorank.mapper;

import com.lottorank.vo.LottoRoundResult;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LottoMapper {
    LottoRoundResult selectLatestResult();

    List<LottoRoundResult> selectChartData(@Param("rounds") int rounds);

    List<LottoRoundResult> selectAllChartData();

    List<LottoRoundResult> selectResultList(
            @Param("offset")   int offset,
            @Param("pageSize") int pageSize,
            @Param("year")     Integer year,
            @Param("round")    Integer round,
            @Param("sortCol")  String sortCol,
            @Param("sortDir")  String sortDir);

    int selectResultCount(
            @Param("year")  Integer year,
            @Param("round") Integer round);
}
