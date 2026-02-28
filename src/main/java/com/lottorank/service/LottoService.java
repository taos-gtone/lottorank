package com.lottorank.service;

import com.lottorank.vo.LottoRoundResult;

import java.util.List;

public interface LottoService {
    LottoRoundResult getLatestResult();
    List<LottoRoundResult> getResultList(int page, int pageSize, Integer year, Integer round, String sortCol, String sortDir);
    int getTotalCount(Integer year, Integer round);
}
