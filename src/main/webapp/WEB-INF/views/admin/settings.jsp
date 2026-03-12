<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.lottorank.vo.SysConfigVO" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%
  String _activeNavSection = "settings";
  SysConfigVO cfg = (SysConfigVO) request.getAttribute("config");

  String  sysOperYn     = (cfg != null && cfg.getSysOperYn()     != null) ? cfg.getSysOperYn()     : "Y";
  Integer sysMntSttDay  = (cfg != null && cfg.getSysMntSttDay()  != null) ? cfg.getSysMntSttDay()  : 6;
  String  sysMntSttTime = (cfg != null && cfg.getSysMntSttTime() != null) ? cfg.getSysMntSttTime() : "20:30";
  Integer sysMntEndDay  = (cfg != null && cfg.getSysMntEndDay()  != null) ? cfg.getSysMntEndDay()  : 7;
  String  sysMntEndTime = (cfg != null && cfg.getSysMntEndTime() != null) ? cfg.getSysMntEndTime() : "00:00";
  Integer predBanSttDay = (cfg != null && cfg.getPredBanSttDay() != null) ? cfg.getPredBanSttDay() : 6;
  String  predBanSttTime= (cfg != null && cfg.getPredBanSttTime()!= null) ? cfg.getPredBanSttTime(): "19:00";
  Integer predBanEndDay = (cfg != null && cfg.getPredBanEndDay() != null) ? cfg.getPredBanEndDay() : 7;
  String  predBanEndTime= (cfg != null && cfg.getPredBanEndTime()!= null) ? cfg.getPredBanEndTime(): "00:00";
  String  updDt         = (cfg != null && cfg.getUpdDt()         != null) ? cfg.getUpdDt()         : "-";

  String[] dayNames = {"", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"};
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>환경설정 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
    .adm-content {
      max-width: 760px;
      margin: 0 auto;
      padding: 28px 24px;
    }
    .page-hd {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      margin-bottom: 28px;
    }
    .page-hd-title { font-size: 1.25rem; font-weight: 900; color: var(--g8); }
    .page-hd-sub   { font-size: 0.84rem; color: var(--g5); margin-top: 3px; }

    .cfg-card {
      background: #fff;
      border: 1px solid var(--line);
      border-radius: 10px;
      overflow: hidden;
      margin-bottom: 20px;
    }
    .cfg-card-hd {
      padding: 14px 20px;
      background: #f9fafb;
      border-bottom: 1px solid var(--line);
      font-size: 0.9rem;
      font-weight: 800;
      color: var(--g8);
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .cfg-body { padding: 20px; display: flex; flex-direction: column; gap: 16px; }

    /* 행 레이아웃 */
    .cfg-row {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }
    .cfg-label {
      width: 90px;
      flex-shrink: 0;
      font-size: 0.85rem;
      font-weight: 700;
      color: var(--g7);
    }
    .cfg-field { display: flex; align-items: center; gap: 8px; flex: 1; flex-wrap: wrap; }

    /* from~to 구분선 */
    .range-sep {
      font-size: 0.85rem;
      color: var(--g5);
      font-weight: 600;
      padding: 0 4px;
    }

    /* 토글 스위치 */
    .toggle-wrap { display: flex; align-items: center; gap: 12px; }
    .toggle-switch {
      position: relative;
      display: inline-block;
      width: 52px;
      height: 28px;
    }
    .toggle-switch input { opacity: 0; width: 0; height: 0; }
    .toggle-slider {
      position: absolute;
      inset: 0;
      background: #d1d5db;
      border-radius: 28px;
      cursor: pointer;
      transition: background 0.25s;
    }
    .toggle-slider::before {
      content: '';
      position: absolute;
      width: 20px; height: 20px;
      left: 4px; top: 4px;
      background: #fff;
      border-radius: 50%;
      transition: transform 0.25s;
      box-shadow: 0 1px 3px rgba(0,0,0,0.2);
    }
    .toggle-switch input:checked + .toggle-slider { background: var(--primary); }
    .toggle-switch input:checked + .toggle-slider::before { transform: translateX(24px); }
    .toggle-text {
      font-size: 0.9rem;
      font-weight: 700;
      color: var(--g6);
    }
    .toggle-text.on  { color: var(--primary); }
    .toggle-text.off { color: var(--danger); }

    /* 선택/입력 */
    .cfg-select, .cfg-input {
      padding: 8px 10px;
      border: 1.5px solid var(--line);
      border-radius: 7px;
      font-size: 0.88rem;
      font-family: inherit;
      color: var(--g8);
      background: #fff;
      transition: border-color 0.18s, box-shadow 0.18s;
    }
    .cfg-select:focus, .cfg-input:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(59,130,246,0.12);
    }
    .cfg-select { min-width: 110px; }
    .cfg-input  { width: 130px; }

    /* 저장 버튼 */
    .btn-save {
      padding: 11px 32px;
      background: var(--primary);
      color: #fff;
      border: none;
      border-radius: 7px;
      font-size: 0.95rem;
      font-weight: 800;
      cursor: pointer;
      font-family: inherit;
      transition: background 0.18s, transform 0.1s;
    }
    .btn-save:hover  { background: var(--primary-h); }
    .btn-save:active { transform: translateY(1px); }

    /* 수정시간 */
    .upd-info {
      font-size: 0.82rem;
      color: var(--g5);
      margin-top: 4px;
    }

    /* 토스트 */
    .toast {
      position: fixed;
      bottom: 32px; left: 50%;
      transform: translateX(-50%) translateY(20px);
      background: var(--g8);
      color: #fff;
      padding: 12px 24px;
      border-radius: 8px;
      font-size: 0.9rem;
      font-weight: 600;
      opacity: 0;
      transition: opacity 0.25s, transform 0.25s;
      pointer-events: none;
      z-index: 999;
      white-space: nowrap;
    }
    .toast.show {
      opacity: 1;
      transform: translateX(-50%) translateY(0);
    }
    .toast.error { background: var(--danger); }

    @media (max-width: 600px) {
      .cfg-row { flex-direction: column; align-items: flex-start; }
      .cfg-label { width: auto; }
    }
  </style>
</head>
<body>
  <%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

  <main class="adm-content">
    <div class="page-hd">
      <div>
        <div class="page-hd-title">환경설정</div>
        <div class="page-hd-sub">시스템 운영 여부, 점검 시간, 예측 불가 시간을 설정합니다.</div>
      </div>
    </div>

    <form id="cfgForm">
      <!-- 시스템 운영 -->
      <div class="cfg-card">
        <div class="cfg-card-hd">⚙️ 시스템 운영</div>
        <div class="cfg-body">
          <div class="cfg-row">
            <div class="cfg-label">운영 여부</div>
            <div class="cfg-field">
              <div class="toggle-wrap">
                <label class="toggle-switch">
                  <input type="checkbox" id="sysOperToggle"
                         <%= "Y".equals(sysOperYn) ? "checked" : "" %>>
                  <span class="toggle-slider"></span>
                </label>
                <span class="toggle-text <%= "Y".equals(sysOperYn) ? "on" : "off" %>"
                      id="toggleLabel">
                  <%= "Y".equals(sysOperYn) ? "운영중 (Y)" : "운영정지 (N)" %>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 시스템 점검 시간 -->
      <div class="cfg-card">
        <div class="cfg-card-hd">🔧 시스템 점검 시간</div>
        <div class="cfg-body">
          <div class="cfg-row">
            <div class="cfg-label">시작</div>
            <div class="cfg-field">
              <select class="cfg-select" id="sysMntSttDay" name="sysMntSttDay">
                <% for (int d = 1; d <= 7; d++) { %>
                <option value="<%= d %>" <%= sysMntSttDay.intValue() == d ? "selected" : "" %>><%= dayNames[d] %></option>
                <% } %>
              </select>
              <input type="time" class="cfg-input" id="sysMntSttTime" name="sysMntSttTime"
                     value="<%= HtmlUtils.htmlEscape(sysMntSttTime) %>">
            </div>
          </div>
          <div class="cfg-row">
            <div class="cfg-label">종료</div>
            <div class="cfg-field">
              <select class="cfg-select" id="sysMntEndDay" name="sysMntEndDay">
                <% for (int d = 1; d <= 7; d++) { %>
                <option value="<%= d %>" <%= sysMntEndDay.intValue() == d ? "selected" : "" %>><%= dayNames[d] %></option>
                <% } %>
              </select>
              <input type="time" class="cfg-input" id="sysMntEndTime" name="sysMntEndTime"
                     value="<%= HtmlUtils.htmlEscape(sysMntEndTime) %>">
            </div>
          </div>
        </div>
      </div>

      <!-- 예측 불가 시간 -->
      <div class="cfg-card">
        <div class="cfg-card-hd">🚫 예측 불가 시간</div>
        <div class="cfg-body">
          <div class="cfg-row">
            <div class="cfg-label">시작</div>
            <div class="cfg-field">
              <select class="cfg-select" id="predBanSttDay" name="predBanSttDay">
                <% for (int d = 1; d <= 7; d++) { %>
                <option value="<%= d %>" <%= predBanSttDay.intValue() == d ? "selected" : "" %>><%= dayNames[d] %></option>
                <% } %>
              </select>
              <input type="time" class="cfg-input" id="predBanSttTime" name="predBanSttTime"
                     value="<%= HtmlUtils.htmlEscape(predBanSttTime) %>">
            </div>
          </div>
          <div class="cfg-row">
            <div class="cfg-label">종료</div>
            <div class="cfg-field">
              <select class="cfg-select" id="predBanEndDay" name="predBanEndDay">
                <% for (int d = 1; d <= 7; d++) { %>
                <option value="<%= d %>" <%= predBanEndDay.intValue() == d ? "selected" : "" %>><%= dayNames[d] %></option>
                <% } %>
              </select>
              <input type="time" class="cfg-input" id="predBanEndTime" name="predBanEndTime"
                     value="<%= HtmlUtils.htmlEscape(predBanEndTime) %>">
            </div>
          </div>
        </div>
      </div>

      <div style="display:flex; align-items:center; justify-content:space-between;">
        <div class="upd-info">최종 수정: <span id="updDtLabel"><%= HtmlUtils.htmlEscape(updDt) %></span></div>
        <button type="button" class="btn-save" id="btnSave">저장</button>
      </div>
    </form>
  </main>

  <div class="toast" id="toast"></div>

  <script>
  (function() {
    var toggle   = document.getElementById('sysOperToggle');
    var label    = document.getElementById('toggleLabel');
    var btnSave  = document.getElementById('btnSave');
    var toast    = document.getElementById('toast');
    var updDtLbl = document.getElementById('updDtLabel');

    toggle.addEventListener('change', function() {
      if (this.checked) {
        label.textContent = '운영중 (Y)';
        label.className = 'toggle-text on';
      } else {
        label.textContent = '운영정지 (N)';
        label.className = 'toggle-text off';
      }
    });

    btnSave.addEventListener('click', function() {
      var sysMntSttTime  = document.getElementById('sysMntSttTime').value;
      var sysMntEndTime  = document.getElementById('sysMntEndTime').value;
      var predBanSttTime = document.getElementById('predBanSttTime').value;
      var predBanEndTime = document.getElementById('predBanEndTime').value;

      if (!sysMntSttTime || !sysMntEndTime) {
        showToast('시스템 점검 시각을 입력해주세요.', true); return;
      }
      if (!predBanSttTime || !predBanEndTime) {
        showToast('예측 불가 시각을 입력해주세요.', true); return;
      }
      if (!confirm('환경설정을 저장하시겠습니까?')) return;

      btnSave.disabled = true;

      fetch('/lottorank/admin/settings', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'sysOperYn='     + encodeURIComponent(toggle.checked ? 'Y' : 'N')
            + '&sysMntSttDay='  + encodeURIComponent(document.getElementById('sysMntSttDay').value)
            + '&sysMntSttTime=' + encodeURIComponent(sysMntSttTime)
            + '&sysMntEndDay='  + encodeURIComponent(document.getElementById('sysMntEndDay').value)
            + '&sysMntEndTime=' + encodeURIComponent(sysMntEndTime)
            + '&predBanSttDay=' + encodeURIComponent(document.getElementById('predBanSttDay').value)
            + '&predBanSttTime='+ encodeURIComponent(predBanSttTime)
            + '&predBanEndDay=' + encodeURIComponent(document.getElementById('predBanEndDay').value)
            + '&predBanEndTime='+ encodeURIComponent(predBanEndTime)
      })
      .then(function(r) { return r.json(); })
      .then(function(data) {
        btnSave.disabled = false;
        if (data.success) {
          var now = new Date();
          var pad = function(n) { return String(n).padStart(2, '0'); };
          updDtLbl.textContent =
            now.getFullYear() + '-' + pad(now.getMonth()+1) + '-' + pad(now.getDate()) + ' ' +
            pad(now.getHours()) + ':' + pad(now.getMinutes()) + ':' + pad(now.getSeconds());
          showToast('저장되었습니다.', false);
        } else {
          showToast(data.message || '저장에 실패했습니다.', true);
        }
      })
      .catch(function() {
        btnSave.disabled = false;
        showToast('저장 중 오류가 발생했습니다.', true);
      });
    });

    function showToast(msg, isError) {
      toast.textContent = msg;
      toast.className = 'toast' + (isError ? ' error' : '');
      void toast.offsetWidth;
      toast.classList.add('show');
      setTimeout(function() { toast.classList.remove('show'); }, 2500);
    }
  })();
  </script>
</body>
</html>
