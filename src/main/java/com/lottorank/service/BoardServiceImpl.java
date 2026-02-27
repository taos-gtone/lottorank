package com.lottorank.service;

import com.lottorank.mapper.BoardMapper;
import com.lottorank.vo.BoardCommentVO;
import com.lottorank.vo.BoardPostVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardMapper boardMapper;

    @Override
    public List<BoardPostVO> getPostList(String boardGbnCd, String searchType,
                                         String searchKeyword, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return boardMapper.selectPostList(boardGbnCd, searchType, searchKeyword, offset, pageSize);
    }

    @Override
    public int getPostCount(String boardGbnCd, String searchType, String searchKeyword) {
        return boardMapper.selectPostCount(boardGbnCd, searchType, searchKeyword);
    }

    @Override
    public BoardPostVO getPost(long postNo) {
        return boardMapper.selectPost(postNo);
    }

    @Override
    public void increaseViewCnt(long postNo) {
        boardMapper.updateViewCnt(postNo);
    }

    @Override
    public long writePost(BoardPostVO post) {
        boardMapper.insertPost(post);
        return post.getPostNo();
    }

    @Override
    public void editPost(BoardPostVO post) {
        boardMapper.updatePost(post);
    }

    @Override
    public void deletePost(long postNo, long memberNo) {
        boardMapper.deletePost(postNo, memberNo);
    }

    @Override
    public List<BoardCommentVO> getCommentList(long postNo) {
        return boardMapper.selectCommentList(postNo);
    }

    @Override
    public void writeComment(BoardCommentVO comment) {
        boardMapper.insertComment(comment);
        boardMapper.syncCommentCnt(comment.getPostNo());
    }

    @Override
    public void deleteComment(long commentNo, long memberNo, long postNo) {
        boardMapper.deleteComment(commentNo, memberNo);
        boardMapper.syncCommentCnt(postNo);
    }

    @Override
    public String getMyReaction(long postNo, long memberNo) {
        return boardMapper.selectMyReaction(postNo, memberNo);
    }

    @Override
    public Map<String, Object> toggleReaction(long postNo, long memberNo, String reactionTypCd) {
        String existing = boardMapper.selectMyReaction(postNo, memberNo);
        if (existing == null) {
            boardMapper.insertReaction(postNo, memberNo, reactionTypCd);
        } else if (existing.equals(reactionTypCd)) {
            boardMapper.deleteReaction(postNo, memberNo);
        } else {
            boardMapper.insertReaction(postNo, memberNo, reactionTypCd);
        }
        boardMapper.syncReactionCnt(postNo);

        BoardPostVO post  = boardMapper.selectPost(postNo);
        String myReaction = boardMapper.selectMyReaction(postNo, memberNo);

        Map<String, Object> result = new HashMap<>();
        result.put("myReaction",   myReaction);
        result.put("likeCount",    post != null ? post.getLikeCnt()    : 0);
        result.put("dislikeCount", post != null ? post.getDislikeCnt() : 0);
        return result;
    }

    @Override
    public Map<String, Object> toggleCommentReaction(long commentNo, long memberNo, String reactionTypCd) {
        String existing = boardMapper.selectMyCommentReaction(commentNo, memberNo);
        if (existing == null) {
            boardMapper.insertCommentReaction(commentNo, memberNo, reactionTypCd);
        } else if (existing.equals(reactionTypCd)) {
            boardMapper.deleteCommentReaction(commentNo, memberNo);
        } else {
            boardMapper.insertCommentReaction(commentNo, memberNo, reactionTypCd);
        }
        boardMapper.syncCommentReactionCnt(commentNo);

        BoardCommentVO comment = boardMapper.selectComment(commentNo);
        String myReaction      = boardMapper.selectMyCommentReaction(commentNo, memberNo);

        Map<String, Object> result = new HashMap<>();
        result.put("myReaction",   myReaction);
        result.put("likeCount",    comment != null ? comment.getLikeCnt()    : 0);
        result.put("dislikeCount", comment != null ? comment.getDislikeCnt() : 0);
        return result;
    }

    @Override
    public Map<Long, String> getMyCommentReactions(long postNo, long memberNo) {
        List<Map<String, Object>> list = boardMapper.selectMyCommentReactionList(postNo, memberNo);
        Map<Long, String> result = new HashMap<>();
        for (Map<String, Object> row : list) {
            Object cno  = row.get("commentNo");
            Object rtyp = row.get("reactionTypCd");
            if (cno != null && rtyp != null) {
                result.put(((Number) cno).longValue(), rtyp.toString());
            }
        }
        return result;
    }
}
