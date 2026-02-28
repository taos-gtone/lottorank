package com.lottorank.mapper;

import com.lottorank.vo.MemPredNumVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PredictMapper {

    /** 해당 회차의 회원 예측 번호 조회 */
    MemPredNumVO findByRoundAndMember(@Param("roundNo") int roundNo,
                                     @Param("memberNo") long memberNo);

    /** 예측 번호 저장 */
    int insertPredNum(MemPredNumVO vo);
}
