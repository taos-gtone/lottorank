package com.lottorank.service;

import com.lottorank.vo.MemRankAllVO;
import com.lottorank.vo.MemRank5RoundVO;
import com.lottorank.vo.PredRankingVO;

import java.util.List;

public interface RankingService {
    List<MemRankAllVO> getAllRanking();
    List<MemRank5RoundVO> getRecent5Ranking();
    List<MemRankAllVO> getMyAllRankingHistory(long memberNo);
    List<MemRank5RoundVO> getMyRecent5RankingHistory(long memberNo);

    /** 특정 회원의 최신 전체 랭킹 1건 (히어로 미니 통계용) */
    MemRankAllVO getMyLatestAllRanking(long memberNo);

    /** 다음 예측 회차 제출 인원 수 */
    int countPredForNextRound();

    /** 다음 예측 회차 제출 목록 (전체기간 랭킹순, 정렬·페이징) */
    List<PredRankingVO> getPredForNextRound(int page, int size, String sortCol, String sortDir);

    /** 다음 예측 회차 제출 목록 (최근 5주 랭킹순, 정렬·페이징) */
    List<PredRankingVO> getPredForNextRound5Round(int page, int size, String sortCol, String sortDir);

    /** 다음 예측 회차 번호 */
    int getNextPredRoundNo();

    /* ── 회원 랭킹 목록 페이징 ── */
    int countAllRankingList();
    List<MemRankAllVO> getAllRankingList(int page, int size, String sortCol, String sortDir);
    int countRecent5RankingList();
    List<MemRank5RoundVO> getRecent5RankingList(int page, int size);
    int getLatestRoundNo();
}
