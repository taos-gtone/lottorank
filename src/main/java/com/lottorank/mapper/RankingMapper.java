package com.lottorank.mapper;

import com.lottorank.vo.MemRankAllVO;
import com.lottorank.vo.MemRank5RoundVO;
import com.lottorank.vo.PredRankingVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface RankingMapper {

    /** 최신 회차 기준 전체 랭킹 상위 6명 조회 */
    List<MemRankAllVO> selectAllRanking();

    /** 최신 회차 기준 최근 5주 랭킹 상위 6명 조회 */
    List<MemRank5RoundVO> selectRecent5Ranking();

    /** 특정 회원의 전체 랭킹 이력 조회 (전 회차, 최신순) */
    List<MemRankAllVO> selectMyAllRankingHistory(@Param("memberNo") long memberNo);

    /** 특정 회원의 최근 5주 랭킹 이력 조회 (전 회차, 최신순) */
    List<MemRank5RoundVO> selectMyRecent5RankingHistory(@Param("memberNo") long memberNo);

    /** 특정 회원의 최신 전체 랭킹 1건 조회 (히어로 미니 통계용) */
    MemRankAllVO selectMyLatestAllRanking(@Param("memberNo") long memberNo);

    /** 다음 예측 회차 제출 인원 수 */
    int countPredForNextRound();

    /** 다음 예측 회차 제출 목록 (정렬·페이징) */
    List<PredRankingVO> selectPredForNextRound(@Param("offset")  int offset,
                                               @Param("size")    int size,
                                               @Param("sortCol") String sortCol,
                                               @Param("sortDir") String sortDir);

    /** 다음 예측 회차 번호 조회 */
    int selectNextPredRoundNo();

    /* ── 회원 랭킹 목록 (전체기간) ── */
    int countAllRankingList();
    List<MemRankAllVO> selectAllRankingList(@Param("offset")  int    offset,
                                            @Param("size")    int    size,
                                            @Param("sortCol") String sortCol,
                                            @Param("sortDir") String sortDir);

    /* ── 회원 랭킹 목록 (최근 5주) ── */
    int countRecent5RankingList();
    List<MemRank5RoundVO> selectRecent5RankingList(@Param("offset") int offset,
                                                   @Param("size")   int size);

    /** 최신 회차 번호 조회 (랭킹 기준 회차 표시용) */
    int selectLatestRoundNo();
}
