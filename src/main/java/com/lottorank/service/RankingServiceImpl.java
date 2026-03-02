package com.lottorank.service;

import com.lottorank.mapper.RankingMapper;
import com.lottorank.vo.MemRankAllVO;
import com.lottorank.vo.MemRank5RoundVO;
import com.lottorank.vo.PredRankingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RankingServiceImpl implements RankingService {

    @Autowired
    private RankingMapper rankingMapper;

    @Override
    public List<MemRankAllVO> getAllRanking() {
        return rankingMapper.selectAllRanking();
    }

    @Override
    public List<MemRank5RoundVO> getRecent5Ranking() {
        return rankingMapper.selectRecent5Ranking();
    }

    @Override
    public List<MemRankAllVO> getMyAllRankingHistory(long memberNo) {
        return rankingMapper.selectMyAllRankingHistory(memberNo);
    }

    @Override
    public List<MemRank5RoundVO> getMyRecent5RankingHistory(long memberNo) {
        return rankingMapper.selectMyRecent5RankingHistory(memberNo);
    }

    @Override
    public MemRankAllVO getMyLatestAllRanking(long memberNo) {
        return rankingMapper.selectMyLatestAllRanking(memberNo);
    }

    @Override
    public int countPredForNextRound() {
        return rankingMapper.countPredForNextRound();
    }

    @Override
    public List<PredRankingVO> getPredForNextRound(int page, int size, String sortCol, String sortDir) {
        int offset = (page - 1) * size;
        return rankingMapper.selectPredForNextRound(offset, size, sortCol, sortDir);
    }

    @Override
    public int getNextPredRoundNo() {
        return rankingMapper.selectNextPredRoundNo();
    }

    @Override
    public int countAllRankingList() {
        return rankingMapper.countAllRankingList();
    }

    @Override
    public List<MemRankAllVO> getAllRankingList(int page, int size, String sortCol, String sortDir) {
        int offset = (page - 1) * size;
        return rankingMapper.selectAllRankingList(offset, size, sortCol, sortDir);
    }

    @Override
    public int countRecent5RankingList() {
        return rankingMapper.countRecent5RankingList();
    }

    @Override
    public List<MemRank5RoundVO> getRecent5RankingList(int page, int size) {
        int offset = (page - 1) * size;
        return rankingMapper.selectRecent5RankingList(offset, size);
    }

    @Override
    public int getLatestRoundNo() {
        return rankingMapper.selectLatestRoundNo();
    }
}
