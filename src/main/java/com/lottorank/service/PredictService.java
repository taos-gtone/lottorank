package com.lottorank.service;

import com.lottorank.vo.MemPredNumVO;
import com.lottorank.vo.PredHistVO;

import java.util.List;

public interface PredictService {

    /** 해당 회차의 회원 예측 번호 조회 (없으면 null) */
    MemPredNumVO getPrediction(int roundNo, long memberNo);

    /** 예측 번호 저장 (이미 존재하면 false 반환) */
    boolean submitPrediction(int roundNo, long memberNo, int predNum);

    /** 회원의 전체 예측 이력 조회 (전 회차, 미예측 포함) */
    List<PredHistVO> getMyPredHistory(long memberNo);
}
