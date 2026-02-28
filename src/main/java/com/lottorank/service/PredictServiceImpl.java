package com.lottorank.service;

import com.lottorank.mapper.PredictMapper;
import com.lottorank.vo.MemPredNumVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PredictServiceImpl implements PredictService {

    @Autowired
    private PredictMapper predictMapper;

    @Override
    public MemPredNumVO getPrediction(int roundNo, long memberNo) {
        return predictMapper.findByRoundAndMember(roundNo, memberNo);
    }

    @Override
    public boolean submitPrediction(int roundNo, long memberNo, int predNum) {
        if (predictMapper.findByRoundAndMember(roundNo, memberNo) != null) {
            return false; // 이미 제출됨
        }
        MemPredNumVO vo = new MemPredNumVO();
        vo.setRoundNo(roundNo);
        vo.setMemberNo(memberNo);
        vo.setPredNum(predNum);
        predictMapper.insertPredNum(vo);
        return true;
    }
}
