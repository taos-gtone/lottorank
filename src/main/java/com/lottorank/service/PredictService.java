package com.lottorank.service;

import com.lottorank.vo.MemPredNumVO;

public interface PredictService {

    /** 해당 회차의 회원 예측 번호 조회 (없으면 null) */
    MemPredNumVO getPrediction(int roundNo, long memberNo);

    /** 예측 번호 저장 (이미 존재하면 false 반환) */
    boolean submitPrediction(int roundNo, long memberNo, int predNum);
}
