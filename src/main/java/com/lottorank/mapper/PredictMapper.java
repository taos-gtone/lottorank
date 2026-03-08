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

    /** 특정 회차의 전체 예측 참여 인원 수 */
    int countByRound(@Param("roundNo") int roundNo);

    /** 최신 회차(max round) 전체 적중률 (소수점 1자리, 0~100) */
    Double getLastRoundHitRate();

    /** 회원의 전체 예측 이력 조회 (전 회차 LEFT JOIN, 최신순) */
    List<PredHistVO> findMyPredHistory(@Param("memberNo") long memberNo);
}
