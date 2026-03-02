package com.lottorank.mapper;

import com.lottorank.vo.MemPredNumVO;
import com.lottorank.vo.PredHistVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PredictMapper {

    /** 해당 회차의 회원 예측 번호 조회 */
    MemPredNumVO findByRoundAndMember(@Param("roundNo") int roundNo,
                                     @Param("memberNo") long memberNo);

    /** 예측 번호 저장 */
    int insertPredNum(MemPredNumVO vo);

    /** 회원의 전체 예측 이력 조회 (전 회차 LEFT JOIN, 최신순) */
    List<PredHistVO> findMyPredHistory(@Param("memberNo") long memberNo);
}
