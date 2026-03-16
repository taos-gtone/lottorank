package com.lottorank.mapper;

import com.lottorank.vo.GoldPredListVO;
import com.lottorank.vo.IntgConsecMemberVO;
import com.lottorank.vo.IntgPredNumVO;
import com.lottorank.vo.MemPredNumVO;
import com.lottorank.vo.PredHistVO;
import com.lottorank.vo.WinNumStatVO;
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

    /** 골드 - 회차별 예측번호 목록 (페이징, 정렬) */
    List<GoldPredListVO> selectGoldPredList(@Param("roundNo") int roundNo,
                                            @Param("pageSize") int pageSize,
                                            @Param("offset") int offset,
                                            @Param("sortOrder") String sortOrder);

    /** 골드 - 회차별 예측번호 목록 (최근 5주 랭킹순, 페이징, 정렬) */
    List<GoldPredListVO> selectGoldPredList5Round(@Param("roundNo")   int    roundNo,
                                                  @Param("pageSize")  int    pageSize,
                                                  @Param("offset")    int    offset,
                                                  @Param("sortOrder") String sortOrder);

    /** 골드 - 회차별 예측번호 건수 */
    int selectGoldPredCount(@Param("roundNo") int roundNo);

    /** 골드 예측통합 - 다음 회차(max+1) 예측 제출 회원수 */
    int selectNextRoundPredMemberCount();

    /** 골드 예측통합 - 조건별 번호 집계 (번호, 인원수, 순위목록) */
    List<IntgPredNumVO> selectIntgPredNumList(@Param("rankDir")  String rankDir,
                                              @Param("rankVal")  double rankVal,
                                              @Param("rankUnit") String rankUnit);

    /** 당첨번호 탭 - 최근 N회차 번호별 출현 통계 (출현한 번호, 출현횟수, 출현회차 목록) */
    List<WinNumStatVO> selectWinNumMostList(@Param("roundCnt")     int     roundCnt,
                                            @Param("includeBonus") boolean includeBonus);

    /** 당첨번호 탭 - 최근 N회차 미출현 번호 + 연속 미출현 횟수 */
    List<WinNumStatVO> selectWinNumLeastList(@Param("roundCnt")     int     roundCnt,
                                             @Param("includeBonus") boolean includeBonus);

    /** 당첨번호 탭 - 최근 N회차 출현률/미출현률 기준 번호 조회 */
    List<WinNumStatVO> selectWinNumByRate(@Param("roundCnt")     int     roundCnt,
                                          @Param("includeBonus") boolean includeBonus,
                                          @Param("appearType")   String  appearType,
                                          @Param("rate")         double  rate);

    /** 골드 예측통합 - 최근 N회차 연속 적중/미적중 회원이 선택한 번호 집계 */
    List<IntgPredNumVO> selectIntgPredNumByConsec(@Param("roundCnt")   int    roundCnt,
                                                  @Param("hitYn")      String hitYn,
                                                  @Param("maxNoSub")   int    maxNoSub);

    /** 골드 예측통합 - 최근 N회차 적중률/미적중률 조건 회원이 선택한 번호 집계 */
    List<IntgPredNumVO> selectIntgPredNumByRate(@Param("roundCnt")  int    roundCnt,
                                                @Param("hitType")   String hitType,
                                                @Param("rate")      double rate,
                                                @Param("maxNoSub")  int    maxNoSub);

    /** 골드 예측통합 - 최근 N회차 연속 적중/미적중 회원 목록 (회원별 상세) */
    List<IntgConsecMemberVO> selectIntgConsecMemberList(@Param("roundCnt")  int    roundCnt,
                                                        @Param("hitYn")     String hitYn,
                                                        @Param("maxNoSub")  int    maxNoSub);
}
