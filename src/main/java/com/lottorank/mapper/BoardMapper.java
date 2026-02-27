package com.lottorank.mapper;

import com.lottorank.vo.BoardCommentVO;
import com.lottorank.vo.BoardPostVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {

    /* ── 목록 & 카운트 ── */
    List<BoardPostVO> selectPostList(
            @Param("boardGbnCd")    String  boardGbnCd,
            @Param("searchType")    String  searchType,
            @Param("searchKeyword") String  searchKeyword,
            @Param("offset")        int     offset,
            @Param("pageSize")      int     pageSize);

    int selectPostCount(
            @Param("boardGbnCd")    String boardGbnCd,
            @Param("searchType")    String searchType,
            @Param("searchKeyword") String searchKeyword);

    /* ── 단건 조회 ── */
    BoardPostVO selectPost(@Param("postNo") long postNo);

    /* ── 조회수 증가 ── */
    void updateViewCnt(@Param("postNo") long postNo);

    /* ── 등록 ── */
    void insertPost(BoardPostVO post);

    /* ── 수정 ── */
    void updatePost(BoardPostVO post);

    /* ── 삭제 (소프트) ── */
    void deletePost(
            @Param("postNo")    long   postNo,
            @Param("memberNo")  long   memberNo);

    /* ── 댓글 목록 ── */
    List<BoardCommentVO> selectCommentList(@Param("postNo") long postNo);

    /* ── 댓글 등록 ── */
    void insertComment(BoardCommentVO comment);

    /* ── 댓글 삭제 (소프트) ── */
    void deleteComment(
            @Param("commentNo") long commentNo,
            @Param("memberNo")  long memberNo);

    /* ── 댓글 수 동기화 ── */
    void syncCommentCnt(@Param("postNo") long postNo);

    /* ── 게시글 반응 (추천/비추천) ── */
    String selectMyReaction(
            @Param("postNo")   long postNo,
            @Param("memberNo") long memberNo);

    void insertReaction(
            @Param("postNo")        long   postNo,
            @Param("memberNo")      long   memberNo,
            @Param("reactionTypCd") String reactionTypCd);

    void deleteReaction(
            @Param("postNo")   long postNo,
            @Param("memberNo") long memberNo);

    void syncReactionCnt(@Param("postNo") long postNo);

    /* ── 댓글 단건 ── */
    BoardCommentVO selectComment(@Param("commentNo") long commentNo);

    /* ── 댓글 반응 (추천/비추천) ── */
    String selectMyCommentReaction(
            @Param("commentNo") long commentNo,
            @Param("memberNo")  long memberNo);

    List<Map<String, Object>> selectMyCommentReactionList(
            @Param("postNo")   long postNo,
            @Param("memberNo") long memberNo);

    void insertCommentReaction(
            @Param("commentNo")     long   commentNo,
            @Param("memberNo")      long   memberNo,
            @Param("reactionTypCd") String reactionTypCd);

    void deleteCommentReaction(
            @Param("commentNo") long commentNo,
            @Param("memberNo")  long memberNo);

    void syncCommentReactionCnt(@Param("commentNo") long commentNo);
}
