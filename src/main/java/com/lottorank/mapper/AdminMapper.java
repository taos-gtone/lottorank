package com.lottorank.mapper;

import com.lottorank.vo.AdminLoginHistVO;
import com.lottorank.vo.AdminLoginInfoVO;
import com.lottorank.vo.BoardPostVO;
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
}
