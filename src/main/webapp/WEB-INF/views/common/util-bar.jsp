<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.lottorank.vo.BoardPostVO, java.util.List" %>
  <%
    String _uLoginUser = (String) session.getAttribute("loginUser");
    boolean _uLoggedIn = (_uLoginUser != null);

    @SuppressWarnings("unchecked")
    List<BoardPostVO> _tickerNotices = (List<BoardPostVO>) request.getAttribute("tickerNotices");
  %>
  <!-- ===========================
       상단 유틸리티 바
  =========================== -->
  <div class="util-bar">
    <div class="wrap wrap-util-inner">
      <div class="util-inner">
        <div class="util-notice">
          <div class="util-notice-icon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="15" height="15">
              <path d="M5.25 8.25a6.75 6.75 0 0 1 13.5 0v.75c0 2.123.8 4.057 2.118 5.52a.75.75 0 0 1-.297 1.206c-1.544.57-3.16.99-4.831 1.243a3.75 3.75 0 1 1-7.48 0 24.585 24.585 0 0 1-4.831-1.244.75.75 0 0 1-.298-1.205A8.217 8.217 0 0 0 5.25 9v-.75Z"/>
            </svg>
          </div>
          <div class="util-ticker">
            <% if (_tickerNotices != null && !_tickerNotices.isEmpty()) { %>
            <div class="ticker-track" id="tickerTrack">
              <% for (BoardPostVO _tn : _tickerNotices) { %>
              <span class="ticker-item">
                <a href="/notice/view/<%= _tn.getPostNo() %>" class="ticker-link">
                  <%= org.springframework.web.util.HtmlUtils.htmlEscape(_tn.getTitle()) %>
                </a>
              </span>
              <% } %>
            </div>
            <% } else { %>
            <div class="ticker-track">
              <span class="ticker-item">로또랭크에 오신 것을 환영합니다.</span>
            </div>
            <% } %>
          </div>
        </div>
        <div class="util-links">
          <% if (!_uLoggedIn) { %>
          <a href="/member/login" class="util-auth-link">로그인</a>
          <a href="/member/join" class="util-auth-link">회원가입</a>
          <% } %>
          <% if (_uLoggedIn) { %>
          <a href="/member/mypage">마이페이지</a>
          <% } else { %>
          <a href="/member/login?redirect=/member/mypage">마이페이지</a>
          <% } %>
          <a href="#" class="util-gold">🏆 골드회원 간편결제</a>
          <a href="${pageContext.request.contextPath}/sitemap" style="margin-left:8px;">≡ 전체메뉴</a>
        </div>
      </div>
    </div>
  </div>
  <script>
    (function () {
      var track = document.getElementById('tickerTrack');
      if (!track) return;
      var origItems = track.querySelectorAll('.ticker-item');
      if (origItems.length <= 1) return;

      /* 마지막에 첫 번째 아이템 클론 추가 → 무한 위로 롤링 */
      track.appendChild(origItems[0].cloneNode(true));

      var count   = origItems.length;          /* 원본 개수 */
      var current = 0;
      var itemH   = origItems[0].offsetHeight || 20;

      setInterval(function () {
        current++;
        track.style.transition = 'transform 0.5s cubic-bezier(0.4, 0, 0.2, 1)';
        track.style.transform  = 'translateY(-' + (current * itemH) + 'px)';

        /* 클론(첫 번째 복사본)까지 이동하면 전환 후 원래 위치로 순간 이동 */
        if (current === count) {
          setTimeout(function () {
            track.style.transition = 'none';
            track.style.transform  = 'translateY(0)';
            current = 0;
          }, 520);
        }
      }, 4000);
    })();
  </script>
