package com.lottorank.service;

import com.lottorank.vo.BoardCommentVO;
import com.lottorank.vo.BoardPostVO;

import java.util.List;
import java.util.Map;

public interface BoardService {

    List<BoardPostVO> getPostList(String boardGbnCd, String searchType, String searchKeyword, int page, int pageSize);

    int getPostCount(String boardGbnCd, String searchType, String searchKeyword);

    BoardPostVO getPost(long postNo);

    void increaseViewCnt(long postNo);

    long writePost(BoardPostVO post);

    void editPost(BoardPostVO post);

    void deletePost(long postNo, long memberNo);

    List<BoardCommentVO> getCommentList(long postNo);

    void writeComment(BoardCommentVO comment);

    void deleteComment(long commentNo, long memberNo, long postNo);

    /** 게시글 추천/비추천 토글. reactionTypCd: "1"=추천, "2"=비추천 */
    Map<String, Object> toggleReaction(long postNo, long memberNo, String reactionTypCd);

    /** 현재 로그인 회원의 게시글 반응 조회 ("1", "2", null) */
    String getMyReaction(long postNo, long memberNo);

    /** 댓글 추천/비추천 토글 */
    Map<String, Object> toggleCommentReaction(long commentNo, long memberNo, String reactionTypCd);

    /** 해당 게시글의 내 댓글 반응 전체 조회 (commentNo → reactionTypCd) */
    Map<Long, String> getMyCommentReactions(long postNo, long memberNo);
}
