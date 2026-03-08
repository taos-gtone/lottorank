package com.lottorank.admin.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 관리자 인증 인터셉터
 * - adminUser 세션이 없으면 로그인 페이지로 리다이렉트
 * (URL 접두사 /lottorank/admin 으로 라우팅 제한은 RequestMapping에서 담당)
 */
public class AdminAuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            return true;
        }
        response.sendRedirect("/lottorank/admin/login");
        return false;
    }
}
