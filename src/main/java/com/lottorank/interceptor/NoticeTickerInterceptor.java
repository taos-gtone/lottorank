package com.lottorank.interceptor;

import com.lottorank.mapper.BoardMapper;
import com.lottorank.vo.BoardPostVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Collections;
import java.util.List;

/**
 * 모든 일반 페이지 요청에 공지사항 최신 3건 제목을 request 속성으로 주입.
 * util-bar.jsp 의 util-ticker 가 해당 데이터를 사용한다.
 */
@Component("noticeTickerInterceptor")
public class NoticeTickerInterceptor implements HandlerInterceptor {

    @Autowired
    private BoardMapper boardMapper;

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) {
        try {
            List<BoardPostVO> notices = boardMapper.selectRecentNotices(3);
            request.setAttribute("tickerNotices", notices != null ? notices : Collections.emptyList());
        } catch (Exception ignored) {
            request.setAttribute("tickerNotices", Collections.emptyList());
        }
        return true;
    }
}
