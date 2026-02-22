package com.lottorank.service;

import com.lottorank.mapper.LottoMapper;
import com.lottorank.vo.LottoRoundResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LottoServiceImpl implements LottoService {

    @Autowired
    private LottoMapper lottoMapper;

    @Override
    public LottoRoundResult getLatestResult() {
        return lottoMapper.selectLatestResult();
    }

    @Override
    public List<LottoRoundResult> getResultList(int page, int pageSize, Integer year, Integer round) {
        int offset = (page - 1) * pageSize;
        return lottoMapper.selectResultList(offset, pageSize, year, round);
    }

    @Override
    public int getTotalCount(Integer year, Integer round) {
        return lottoMapper.selectResultCount(year, round);
    }
}
