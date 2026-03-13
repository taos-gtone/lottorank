package com.lottorank.mapper;

import com.lottorank.vo.AdminLoginHistVO;
import com.lottorank.vo.AdminLoginInfoVO;
import com.lottorank.vo.AdminMemPredVO;
import com.lottorank.vo.BoardPostVO;
import com.lottorank.vo.MemRankAllVO;
import com.lottorank.vo.MemRank5RoundVO;
import com.lottorank.vo.ComCodeDtlVO;
import com.lottorank.vo.ComCodeMstVO;
import com.lottorank.vo.LoginHistVO;
import com.lottorank.vo.MemberVO;
import com.lottorank.vo.SysConfigVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminMapper {

    /** admin_id로 관리자 정보 조회 */
    AdminLoginInfoVO selectAdminById(@Param("adminId") String adminId);

    /** 로그인 이력 등록 */
    void insertLoginHist(AdminLoginHistVO hist);

    /** 최종 로그인 시각 갱신 */
    void updateLastLoginAt(@Param("adminId") String adminId);

    /** 관리자 전용 댓글 삭제 (member_no 무관) */
    void deleteCommentByAdmin(@Param("commentNo") long commentNo);

    /** 게시글 댓글 수 동기화 */
    void syncCommentCnt(@Param("postNo") long postNo);

    /** 게시글 승인여부 토글 (N↔Y) + 승인일시 갱신 */
    void togglePostApprovalYn(@Param("postNo") long postNo);

    /** 댓글 승인여부 토글 (N↔Y) + 승인일시 갱신 */
    void toggleCommentApprovalYn(@Param("commentNo") long commentNo);

    /** 댓글 승인여부 조회 */
    String selectCommentApprovalYn(@Param("commentNo") long commentNo);

    /** 승인 게시글 필터 - 목록 */
    List<BoardPostVO> selectAdminBoardListApproved(
            @Param("boardGbnCd")    String boardGbnCd,
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword,
            @Param("offset")        int    offset,
            @Param("pageSize")      int    pageSize);

    /** 승인 게시글 필터 - 건수 */
    int selectAdminBoardCountApproved(
            @Param("boardGbnCd")    String boardGbnCd,
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword);

    /** 미승인 게시글/댓글 필터 - 목록 */
    List<BoardPostVO> selectAdminBoardListUnapproved(
            @Param("boardGbnCd")    String boardGbnCd,
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword,
            @Param("offset")        int    offset,
            @Param("pageSize")      int    pageSize);

    /** 미승인 게시글/댓글 필터 - 건수 */
    int selectAdminBoardCountUnapproved(
            @Param("boardGbnCd")    String boardGbnCd,
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword);

    /** 공지사항 목록 (삭제글 포함, filterMode: all/normal/unapproved_comment) */
    List<BoardPostVO> selectAdminNoticeList(
            @Param("boardGbnCd")    String boardGbnCd,
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword,
            @Param("filterMode")    String filterMode,
            @Param("offset")        int    offset,
            @Param("pageSize")      int    pageSize);

    /** 공지사항 건수 (삭제글 포함, filterMode: all/normal/unapproved_comment) */
    int selectAdminNoticeCount(
            @Param("boardGbnCd")    String boardGbnCd,
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword,
            @Param("filterMode")    String filterMode);

    /** 공지사항 단건 조회 (삭제글 포함, 관리자용) */
    BoardPostVO selectAdminNoticePost(@Param("postNo") long postNo);

    /** 공지사항 삭제여부 토글 (N→Y / Y→N) */
    void toggleNoticeDelYn(@Param("postNo") long postNo);

    /** 게시글 즉시 승인 (approval_yn='Y', approval_at=NOW()) */
    void approvePost(@Param("postNo") long postNo);

    /** 관리자 비밀번호 변경 */
    void updateAdminPassword(@Param("adminId") String adminId,
                             @Param("adminPw") String adminPw);

    /** 로그인 이력 목록 조회 (최신순, 페이징) */
    List<AdminLoginHistVO> selectLoginHistList(
            @Param("offset")   int offset,
            @Param("pageSize") int pageSize);

    /** 로그인 이력 전체 건수 */
    int selectLoginHistCount();

    /** 회원 목록 조회 (등록시간 내림차순) */
    List<MemberVO> selectMemberList(
            @Param("offset")   int offset,
            @Param("pageSize") int pageSize);

    /** 회원 전체 건수 */
    int selectMemberCount();

    /** 회원 로그인 이력 목록 (최신순, 페이징, 검색) */
    List<LoginHistVO> selectMemLoginHistList(
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword,
            @Param("offset")        int    offset,
            @Param("pageSize")      int    pageSize);

    /** 회원 로그인 이력 전체 건수 */
    int selectMemLoginHistCount(
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword);

    /** LTT_ROUND_RESULT 최대 회차 조회 */
    int selectMaxRoundNo();

    /** 회원 예측번호 목록 (회차+회원 검색, 페이징) */
    List<AdminMemPredVO> selectMemPredNumList(
            @Param("roundNo")       Integer roundNo,
            @Param("searchType")    String  searchType,
            @Param("searchKeyword") String  searchKeyword,
            @Param("offset")        int     offset,
            @Param("pageSize")      int     pageSize);

    /** 회원 예측번호 전체 건수 */
    int selectMemPredNumCount(
            @Param("roundNo")       Integer roundNo,
            @Param("searchType")    String  searchType,
            @Param("searchKeyword") String  searchKeyword);

    /** 회원 전체기간 랭킹 목록 (특정 회차 기준) */
    List<MemRankAllVO> selectAdminAllRankingList(
            @Param("roundNo") int roundNo,
            @Param("offset")  int offset,
            @Param("size")    int size);

    /** 회원 전체기간 랭킹 건수 */
    int selectAdminAllRankingCount(@Param("roundNo") int roundNo);

    /** 회원 최근5주 랭킹 목록 (특정 회차 기준) */
    List<MemRank5RoundVO> selectAdminRecent5RankingList(
            @Param("roundNo") int roundNo,
            @Param("offset")  int offset,
            @Param("size")    int size);

    /** 회원 최근5주 랭킹 건수 */
    int selectAdminRecent5RankingCount(@Param("roundNo") int roundNo);

    /** 회원 기본 정보 조회 (memberNo 기준) */
    MemberVO selectAdminMemBasicInfo(@Param("memberNo") long memberNo);

    /** 특정 회원의 전체기간 랭킹 이력 목록 (전 회차, 최신순, 페이징) */
    List<MemRankAllVO> selectAdminMemAllRankingHist(
            @Param("memberNo") long memberNo,
            @Param("offset")   int  offset,
            @Param("size")     int  size);

    /** 특정 회원의 전체기간 랭킹 이력 건수 */
    int selectAdminMemAllRankingHistCount(@Param("memberNo") long memberNo);

    /** 특정 회원의 최근5주 랭킹 이력 목록 (전 회차, 최신순, 페이징) */
    List<MemRank5RoundVO> selectAdminMemRecent5RankingHist(
            @Param("memberNo") long memberNo,
            @Param("offset")   int  offset,
            @Param("size")     int  size);

    /** 특정 회원의 최근5주 랭킹 이력 건수 */
    int selectAdminMemRecent5RankingHistCount(@Param("memberNo") long memberNo);

    /* ═══════════════ 공통 코드 관리 ═══════════════ */

    /** 코드그룹 전체 목록 (정렬순서 오름차순) */
    List<ComCodeMstVO> selectCodeMstList();

    /** 코드그룹 단건 조회 */
    ComCodeMstVO selectCodeMstById(@Param("codeGrpId") String codeGrpId);

    /** 코드그룹 ID 중복 체크 */
    int selectCodeMstIdExists(@Param("codeGrpId") String codeGrpId);

    /** 코드그룹 등록 */
    void insertCodeMst(ComCodeMstVO vo);

    /** 코드그룹 수정 */
    void updateCodeMst(ComCodeMstVO vo);

    /** 코드그룹 삭제 */
    void deleteCodeMst(@Param("codeGrpId") String codeGrpId);

    /** 코드 상세 목록 (정렬순서 오름차순) */
    List<ComCodeDtlVO> selectCodeDtlList(@Param("codeGrpId") String codeGrpId);

    /** 코드 ID 중복 체크 */
    int selectCodeDtlIdExists(@Param("codeGrpId") String codeGrpId,
                              @Param("codeId")    String codeId);

    /** 코드 상세 등록 */
    void insertCodeDtl(ComCodeDtlVO vo);

    /** 코드 상세 수정 */
    void updateCodeDtl(ComCodeDtlVO vo);

    /** 코드 상세 단건 삭제 */
    void deleteCodeDtl(@Param("codeGrpId") String codeGrpId,
                       @Param("codeId")    String codeId);

    /** 코드 그룹 하위 전체 삭제 */
    void deleteCodeDtlByGrp(@Param("codeGrpId") String codeGrpId);

    /* ═══════════════ 시스템 환경설정 ═══════════════ */

    /** 시스템 설정 조회 (단일 row) */
    SysConfigVO selectSysConfig();

    /** 시스템 설정 수정 */
    void updateSysConfig(SysConfigVO vo);
}
