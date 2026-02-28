package com.lottorank.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 로그인 사용자가 페이지를 이동할 때마다 세션 만료 시각을 10분으로 자동 갱신.
 * - 아무것도 안 하고 가만히 있으면 타이머가 줄어들고
 * - 페이지를 이동하면 10분으로 리셋됨.
 */
public class SessionRefreshInterceptor implements HandlerInterceptor {

    private static final long SESSION_DURATION_MS = 600_000L; // 10분

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) {

        HttpSession session = request.getSession(false);
        if (session == null) return true;

        String loginUser = (String) session.getAttribute("loginUser");
        if (loginUser == null) return true;

        // AJAX 요청은 타이머 리셋에서 제외 (fetch/XHR 호출)
        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) return true;

        // 페이지 이동 시 세션 만료 시각 10분으로 갱신
        long expiry = System.currentTimeMillis() + SESSION_DURATION_MS;
        session.setMaxInactiveInterval(600);
        session.setAttribute("sessionExpiry", expiry);

        return true;
    }
}
