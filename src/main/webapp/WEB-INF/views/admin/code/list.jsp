<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.ComCodeMstVO" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>코드 관리 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
    .adm-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 28px 24px;
    }
    .page-hd {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 24px;
    }
    .page-hd-title { font-size: 1.25rem; font-weight: 900; color: var(--g8); }
    .page-hd-sub   { font-size: 0.84rem; color: var(--g5); margin-top: 3px; }

    /* 패널 */
    .code-panel { margin-bottom: 28px; }
    .panel-hd {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 10px;
    }
    .panel-title {
      font-size: 1rem;
      font-weight: 800;
      color: var(--g8);
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .panel-title .grp-badge {
      font-size: 0.8rem;
      font-weight: 600;
      color: var(--g5);
      background: var(--g3);
      padding: 2px 10px;
      border-radius: 20px;
    }
    .btn-add-row {
      padding: 7px 16px;
      background: var(--primary);
      color: #fff;
      border: none;
      border-radius: 6px;
      font-size: 0.84rem;
      font-weight: 700;
      cursor: pointer;
      font-family: inherit;
      transition: background 0.18s;
    }
    .btn-add-row:hover    { background: var(--primary-h); }
    .btn-add-row:disabled { background: var(--g4); cursor: not-allowed; }

    /* 테이블 */
    .tbl-wrap {
      border: 1px solid var(--line);
      border-radius: 10px;
      overflow: hidden;
      overflow-x: auto;
    }
    .adm-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.875rem;
    }
    .adm-table thead th {
      background: var(--g3);
      color: var(--g6);
      font-weight: 700;
      padding: 10px 12px;
      text-align: left;
      border-bottom: 1px solid var(--line);
      white-space: nowrap;
    }
    .adm-table tbody tr {
      border-bottom: 1px solid var(--line);
      transition: background 0.12s;
    }
    .adm-table tbody tr:last-child { border-bottom: none; }
    .adm-table tbody tr:hover        { background: var(--g2); }
    .adm-table tbody tr.row-selected { background: #eff6ff !important; }
    .adm-table tbody td {
      padding: 9px 12px;
      color: var(--g7);
      vertical-align: middle;
    }
    .adm-table tbody td.empty {
      text-align: center;
      padding: 36px;
      color: var(--g5);
      font-size: 0.875rem;
    }

    /* 정렬 가능한 헤더 */
    .sort-th {
      cursor: pointer;
      user-select: none;
    }
    .sort-th:hover { color: var(--g8); background: var(--g2); }
    .sort-icon {
      display: inline-block;
      font-size: 0.7rem;
      margin-left: 4px;
      color: var(--g4);
      vertical-align: middle;
    }
    .sort-th.asc  .sort-icon,
    .sort-th.desc .sort-icon { color: var(--primary); }

    /* 배지 */
    .badge-y { display:inline-block; padding:2px 8px; border-radius:20px; background:#dcfce7; color:#15803d; font-size:0.78rem; font-weight:700; }
    .badge-n { display:inline-block; padding:2px 8px; border-radius:20px; background:var(--g3); color:var(--g5); font-size:0.78rem; font-weight:700; }

    /* 셀 입력 */
    .cell-input {
      padding: 5px 8px;
      border: 1px solid var(--g4);
      border-radius: 5px;
      font-size: 0.84rem;
      font-family: inherit;
      color: var(--g8);
      outline: none;
      width: 100%;
      min-width: 60px;
      box-sizing: border-box;
      transition: border-color 0.15s, box-shadow 0.15s;
    }
    .cell-input:focus { border-color: var(--primary); box-shadow: 0 0 0 2px rgba(59,130,246,0.15); }
    .cell-input-sm { width: 70px; min-width: 50px; }
    select.cell-input { cursor: pointer; }

    /* 행 버튼 */
    .btn-sm {
      padding: 4px 10px;
      border-radius: 5px;
      font-size: 0.78rem;
      font-weight: 700;
      cursor: pointer;
      font-family: inherit;
      border: 1px solid transparent;
      transition: background 0.15s, border-color 0.15s, color 0.15s;
      white-space: nowrap;
    }
    .btn-edit   { background:#f0f9ff; border-color:#bae6fd; color:#0369a1; }
    .btn-edit:hover   { background:#e0f2fe; border-color:#7dd3fc; }
    .btn-del    { background:#fff1f2; border-color:#fecdd3; color:#be123c; }
    .btn-del:hover    { background:#ffe4e6; border-color:#fda4af; }
    .btn-save   { background:#f0fdf4; border-color:#bbf7d0; color:#15803d; }
    .btn-save:hover   { background:#dcfce7; border-color:#86efac; }
    .btn-cancel { background:var(--g3); border-color:var(--g4); color:var(--g6); }
    .btn-cancel:hover { background:var(--g2); }

    .mst-row-view { cursor: pointer; }
    .new-row       { background:#fefce8 !important; }
    .new-row:hover { background:#fef9c3 !important; }
    .edit-row-active        { background:#f0f9ff !important; }
    .edit-row-active:hover  { background:#e0f2fe !important; }

    /* 페이징 */
    .pg-wrap {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4px;
      margin-top: 12px;
    }
    .pg-btn {
      min-width: 32px;
      height: 32px;
      padding: 0 8px;
      border: 1px solid var(--line);
      border-radius: 6px;
      background: #fff;
      color: var(--g6);
      font-size: 0.83rem;
      font-weight: 600;
      cursor: pointer;
      font-family: inherit;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.15s, color 0.15s, border-color 0.15s;
    }
    .pg-btn:hover  { background: var(--g3); color: var(--g8); }
    .pg-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); }
    .pg-btn.disabled { opacity: 0.4; cursor: not-allowed; pointer-events: none; }
  </style>
</head>
<body>
<%
  String _activeNavSection = "code";
%>
<%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<ComCodeMstVO> codeGrpList = (List<ComCodeMstVO>) request.getAttribute("codeGrpList");
  if (codeGrpList == null) codeGrpList = new java.util.ArrayList<>();
%>

<div class="adm-content">

  <div class="page-hd">
    <div>
      <div class="page-hd-title">코드 관리</div>
      <div class="page-hd-sub">공통 코드그룹 및 코드 목록을 관리합니다.</div>
    </div>
  </div>

  <!-- ─────────────────────────────────────
       상단: 코드그룹 목록 (COM_CODE_MST)
  ───────────────────────────────────────── -->
  <div class="code-panel">
    <div class="panel-hd">
      <span class="panel-title">코드그룹 목록</span>
      <button class="btn-add-row" onclick="addMstRow()">+ 행 추가</button>
    </div>
    <div class="tbl-wrap">
      <table class="adm-table" id="mstTable">
        <thead>
          <tr>
            <th id="mst-th-grpId" class="sort-th" style="width:120px" onclick="sortMst('grpId')">
              코드그룹ID <span class="sort-icon" id="mst-icon-grpId">⇅</span>
            </th>
            <th id="mst-th-grpNm" class="sort-th" onclick="sortMst('grpNm')">
              코드그룹명 <span class="sort-icon" id="mst-icon-grpNm">⇅</span>
            </th>
            <th style="width:80px">사용여부</th>
            <th style="width:80px">정렬순서</th>
            <th style="width:145px">등록시간</th>
            <th style="width:120px">관리</th>
          </tr>
        </thead>
        <tbody id="mstTbody">
<%
  if (codeGrpList.isEmpty()) {
%>
          <tr id="mst-empty-row">
            <td colspan="6" class="empty">등록된 코드그룹이 없습니다.</td>
          </tr>
<%
  } else {
    for (ComCodeMstVO g : codeGrpList) {
      String grpId   = HtmlUtils.htmlEscape(g.getCodeGrpId()  != null ? g.getCodeGrpId()  : "");
      String grpNm   = HtmlUtils.htmlEscape(g.getCodeGrpNm()  != null ? g.getCodeGrpNm()  : "");
      String useYn   = g.getUseYn()   != null ? g.getUseYn()   : "Y";
      String sortOrd = g.getSortOrd() != null ? String.valueOf(g.getSortOrd()) : "0";
      String createTs= g.getCreateTs()!= null ? HtmlUtils.htmlEscape(g.getCreateTs()) : "";
%>
          <!-- VIEW ROW -->
          <tr class="mst-row-view"
              id="mst-view-<%= grpId %>"
              data-grp-id="<%= grpId %>"
              data-grp-nm="<%= grpNm %>"
              data-use-yn="<%= useYn %>"
              data-sort-ord="<%= sortOrd %>"
              onclick="selectGroup('<%= grpId %>', '<%= grpNm %>')">
            <td><strong><%= grpId %></strong></td>
            <td><%= grpNm %></td>
            <td><% if ("Y".equals(useYn)) { %><span class="badge-y">사용</span><% } else { %><span class="badge-n">미사용</span><% } %></td>
            <td><%= sortOrd %></td>
            <td style="color:var(--g5);font-size:0.8rem"><%= createTs %></td>
            <td onclick="event.stopPropagation()">
              <button class="btn-sm btn-edit" onclick="startEditMst('<%= grpId %>')">수정</button>
              <button class="btn-sm btn-del"  onclick="deleteMst('<%= grpId %>')">삭제</button>
            </td>
          </tr>
          <!-- EDIT ROW -->
          <tr class="mst-row-edit edit-row-active"
              id="mst-edit-<%= grpId %>"
              style="display:none">
            <td><strong><%= grpId %></strong></td>
            <td><input type="text" class="cell-input" id="edit-grp-nm-<%= grpId %>" value="<%= grpNm %>" maxlength="100" placeholder="코드그룹명"></td>
            <td>
              <select class="cell-input" id="edit-use-yn-<%= grpId %>">
                <option value="Y" <%= "Y".equals(useYn) ? "selected" : "" %>>사용</option>
                <option value="N" <%= "N".equals(useYn) ? "selected" : "" %>>미사용</option>
              </select>
            </td>
            <td><input type="number" class="cell-input cell-input-sm" id="edit-sort-ord-<%= grpId %>" value="<%= sortOrd %>"></td>
            <td style="color:var(--g5);font-size:0.8rem"><%= createTs %></td>
            <td>
              <button class="btn-sm btn-save"   onclick="saveEditMst('<%= grpId %>')">저장</button>
              <button class="btn-sm btn-cancel" onclick="cancelEditMst('<%= grpId %>')">취소</button>
            </td>
          </tr>
<%
    }
  }
%>
        </tbody>
      </table>
    </div>
    <!-- 페이징 -->
    <div class="pg-wrap" id="mstPaging"></div>
  </div>

  <!-- ─────────────────────────────────────
       하단: 코드 목록 (COM_CODE_DTL)
  ───────────────────────────────────────── -->
  <div class="code-panel">
    <div class="panel-hd">
      <span class="panel-title">
        코드 목록
        <span class="grp-badge" id="dtlGrpBadge" style="display:none"></span>
      </span>
      <button class="btn-add-row" id="btnAddDtl" onclick="addDtlRow()" disabled>+ 행 추가</button>
    </div>
    <div class="tbl-wrap">
      <table class="adm-table" id="dtlTable">
        <thead>
          <tr>
            <th id="dtl-th-codeId" class="sort-th" style="width:100px" onclick="sortDtl('codeId')">
              코드ID <span class="sort-icon" id="dtl-icon-codeId">⇅</span>
            </th>
            <th id="dtl-th-codeNm" class="sort-th" style="width:160px" onclick="sortDtl('codeNm')">
              코드명 <span class="sort-icon" id="dtl-icon-codeNm">⇅</span>
            </th>
            <th style="width:160px">코드명(영문)</th>
            <th style="width:80px">사용여부</th>
            <th style="width:80px">정렬순서</th>
            <th style="width:145px">등록시간</th>
            <th style="width:120px">관리</th>
          </tr>
        </thead>
        <tbody id="dtlTbody">
          <tr id="dtl-empty-row">
            <td colspan="7" class="empty">위 목록에서 코드그룹을 선택하세요.</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

</div><!-- /adm-content -->

<script>
/* ═══════════════════════════════════════════════
   공통 유틸
═══════════════════════════════════════════════ */
let selectedGrpId = null;
let selectedGrpNm = null;

function esc(str) {
  if (str == null) return '';
  return String(str)
    .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
    .replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}
function escAttr(str) { return esc(str); }

/* ═══════════════════════════════════════════════
   MST 정렬
═══════════════════════════════════════════════ */
let mstSortCol = null;
let mstSortDir = 'asc';

function sortMst(col) {
  mstSortDir = (mstSortCol === col && mstSortDir === 'asc') ? 'desc' : 'asc';
  mstSortCol = col;

  const tbody  = document.getElementById('mstTbody');
  const viewRows = Array.from(tbody.querySelectorAll('.mst-row-view'));

  viewRows.sort(function(a, b) {
    const aVal = (col === 'grpId' ? a.dataset.grpId : a.dataset.grpNm) || '';
    const bVal = (col === 'grpId' ? b.dataset.grpId : b.dataset.grpNm) || '';
    const cmp  = aVal.localeCompare(bVal, 'ko', { sensitivity: 'base' });
    return mstSortDir === 'asc' ? cmp : -cmp;
  });

  // DOM 재배치 (view + edit 쌍으로)
  viewRows.forEach(function(viewRow) {
    const grpId  = viewRow.dataset.grpId;
    const editRow = document.getElementById('mst-edit-' + grpId);
    tbody.appendChild(viewRow);
    if (editRow) tbody.appendChild(editRow);
  });

  // 페이지 1부터 다시 페이지번호 할당
  mstCurrentPage = 1;
  initMstPaging();
  updateMstSortIndicators();
}

function updateMstSortIndicators() {
  ['grpId', 'grpNm'].forEach(function(col) {
    const th   = document.getElementById('mst-th-' + col);
    const icon = document.getElementById('mst-icon-' + col);
    th.classList.remove('asc', 'desc');
    icon.textContent = '⇅';
  });
  if (mstSortCol) {
    const th   = document.getElementById('mst-th-' + mstSortCol);
    const icon = document.getElementById('mst-icon-' + mstSortCol);
    th.classList.add(mstSortDir);
    icon.textContent = mstSortDir === 'asc' ? '↑' : '↓';
  }
}

/* ═══════════════════════════════════════════════
   MST 페이징
═══════════════════════════════════════════════ */
const MST_PAGE_SIZE = 5;
let mstCurrentPage = 1;
let mstTotalPages  = 1;

function initMstPaging() {
  const viewRows = Array.from(document.querySelectorAll('#mstTbody .mst-row-view'));
  mstTotalPages  = Math.max(1, Math.ceil(viewRows.length / MST_PAGE_SIZE));

  viewRows.forEach(function(row, idx) {
    const p = Math.floor(idx / MST_PAGE_SIZE) + 1;
    row.dataset.mstPage = p;
    const editRow = document.getElementById('mst-edit-' + row.dataset.grpId);
    if (editRow) editRow.dataset.mstPage = p;
  });

  applyMstPage();
}

function applyMstPage() {
  // 편집 중인 행 취소
  document.querySelectorAll('#mstTbody .mst-row-edit').forEach(function(row) {
    if (row.style.display !== 'none') {
      cancelEditMst(row.id.replace('mst-edit-', ''));
    }
  });

  document.querySelectorAll('#mstTbody .mst-row-view').forEach(function(row) {
    if (!row.dataset.mstPage) return;
    row.style.display = (row.dataset.mstPage == mstCurrentPage) ? '' : 'none';
  });
  document.querySelectorAll('#mstTbody .mst-row-edit').forEach(function(row) {
    if (!row.dataset.mstPage) return;
    row.style.display = 'none';
  });

  renderMstPaging();
}

function renderMstPaging() {
  const container = document.getElementById('mstPaging');
  if (mstTotalPages <= 1) { container.innerHTML = ''; return; }

  let html = '<button class="pg-btn' + (mstCurrentPage <= 1 ? ' disabled' : '') +
    '" onclick="goMstPage(' + (mstCurrentPage - 1) + ')">‹</button>';
  for (let p = 1; p <= mstTotalPages; p++) {
    html += '<button class="pg-btn' + (p === mstCurrentPage ? ' active' : '') +
      '" onclick="goMstPage(' + p + ')">' + p + '</button>';
  }
  html += '<button class="pg-btn' + (mstCurrentPage >= mstTotalPages ? ' disabled' : '') +
    '" onclick="goMstPage(' + (mstCurrentPage + 1) + ')">›</button>';
  container.innerHTML = html;
}

function goMstPage(page) {
  if (page < 1 || page > mstTotalPages) return;
  mstCurrentPage = page;
  applyMstPage();
}

/* ═══════════════════════════════════════════════
   MST CRUD
═══════════════════════════════════════════════ */

function selectGroup(grpId, grpNm) {
  document.querySelectorAll('.mst-row-view.row-selected').forEach(r => r.classList.remove('row-selected'));
  const viewRow = document.getElementById('mst-view-' + grpId);
  if (viewRow) viewRow.classList.add('row-selected');

  selectedGrpId = grpId;
  selectedGrpNm = grpNm;

  const badge = document.getElementById('dtlGrpBadge');
  badge.textContent = grpId + ' · ' + grpNm;
  badge.style.display = '';

  document.getElementById('btnAddDtl').disabled = false;

  // DTL 정렬 초기화
  dtlSortCol = null;
  dtlSortDir = 'asc';
  updateDtlSortIndicators();

  loadDtl(grpId);
}

function addMstRow() {
  if (document.getElementById('mst-new-row')) {
    document.getElementById('new-mst-grp-id').focus(); return;
  }
  const emptyRow = document.getElementById('mst-empty-row');
  if (emptyRow) emptyRow.remove();

  const tbody = document.getElementById('mstTbody');
  const tr    = document.createElement('tr');
  tr.id        = 'mst-new-row';
  tr.className = 'new-row';
  tr.innerHTML =
    '<td><input type="text" class="cell-input" id="new-mst-grp-id" maxlength="10" placeholder="그룹ID (영문/숫자)"></td>' +
    '<td><input type="text" class="cell-input" id="new-mst-grp-nm" maxlength="100" placeholder="코드그룹명"></td>' +
    '<td><select class="cell-input" id="new-mst-use-yn">' +
      '<option value="Y">사용</option><option value="N">미사용</option>' +
    '</select></td>' +
    '<td><input type="number" class="cell-input cell-input-sm" id="new-mst-sort-ord" value="0"></td>' +
    '<td style="color:var(--g5);font-size:0.8rem">-</td>' +
    '<td>' +
      '<button class="btn-sm btn-save" onclick="saveNewMst()">저장</button> ' +
      '<button class="btn-sm btn-cancel" onclick="cancelNewMst()">취소</button>' +
    '</td>';
  tbody.insertBefore(tr, tbody.firstChild);
  document.getElementById('new-mst-grp-id').focus();
}

function cancelNewMst() {
  const row = document.getElementById('mst-new-row');
  if (row) row.remove();
  if (!document.querySelector('#mstTbody .mst-row-view')) restoreMstEmptyRow();
}

function restoreMstEmptyRow() {
  const tbody = document.getElementById('mstTbody');
  const tr    = document.createElement('tr');
  tr.id       = 'mst-empty-row';
  tr.innerHTML = '<td colspan="6" class="empty">등록된 코드그룹이 없습니다.</td>';
  tbody.appendChild(tr);
}

function saveNewMst() {
  const grpId   = document.getElementById('new-mst-grp-id').value.trim().toUpperCase();
  const grpNm   = document.getElementById('new-mst-grp-nm').value.trim();
  const useYn   = document.getElementById('new-mst-use-yn').value;
  const sortOrd = document.getElementById('new-mst-sort-ord').value;

  if (!grpId) { alert('코드그룹ID를 입력하세요.'); document.getElementById('new-mst-grp-id').focus(); return; }
  if (!grpNm) { alert('코드그룹명을 입력하세요.'); document.getElementById('new-mst-grp-nm').focus(); return; }

  postJson('/lottorank/admin/code/mst/save',
    { codeGrpId: grpId, codeGrpNm: grpNm, useYn, sortOrd, mode: 'insert' },
    function(data) {
      if (data.success) { location.reload(); }
      else { alert(data.msg || '저장에 실패했습니다.'); }
    }
  );
}

function startEditMst(grpId) {
  document.getElementById('mst-view-' + grpId).style.display = 'none';
  document.getElementById('mst-edit-' + grpId).style.display = '';
  document.getElementById('edit-grp-nm-' + grpId).focus();
}

function cancelEditMst(grpId) {
  document.getElementById('mst-edit-' + grpId).style.display = 'none';
  document.getElementById('mst-view-' + grpId).style.display = '';
}

function saveEditMst(grpId) {
  const grpNm   = document.getElementById('edit-grp-nm-'   + grpId).value.trim();
  const useYn   = document.getElementById('edit-use-yn-'   + grpId).value;
  const sortOrd = document.getElementById('edit-sort-ord-' + grpId).value;

  if (!grpNm) { alert('코드그룹명을 입력하세요.'); return; }

  postJson('/lottorank/admin/code/mst/save',
    { codeGrpId: grpId, codeGrpNm: grpNm, useYn, sortOrd, mode: 'update' },
    function(data) {
      if (data.success) { location.reload(); }
      else { alert(data.msg || '저장에 실패했습니다.'); }
    }
  );
}

function deleteMst(grpId) {
  if (!confirm('코드그룹 [' + grpId + ']을(를) 삭제하시겠습니까?\n하위 코드가 모두 삭제됩니다.')) return;
  postJson('/lottorank/admin/code/mst/delete',
    { codeGrpId: grpId },
    function(data) {
      if (data.success) {
        if (selectedGrpId === grpId) { selectedGrpId = null; clearDtl(); }
        location.reload();
      } else {
        alert(data.msg || '삭제에 실패했습니다.');
      }
    }
  );
}

/* ═══════════════════════════════════════════════
   DTL 정렬
═══════════════════════════════════════════════ */
let dtlList    = [];
let dtlSortCol = null;
let dtlSortDir = 'asc';

function sortDtl(col) {
  if (!selectedGrpId || dtlList.length === 0) return;

  dtlSortDir = (dtlSortCol === col && dtlSortDir === 'asc') ? 'desc' : 'asc';
  dtlSortCol = col;

  const sorted = dtlList.slice().sort(function(a, b) {
    const aVal = (col === 'codeId' ? a.codeId : a.codeNm) || '';
    const bVal = (col === 'codeId' ? b.codeId : b.codeNm) || '';
    const cmp  = aVal.localeCompare(bVal, 'ko', { sensitivity: 'base' });
    return dtlSortDir === 'asc' ? cmp : -cmp;
  });

  updateDtlSortIndicators();
  renderDtl(sorted, selectedGrpId);
}

function updateDtlSortIndicators() {
  ['codeId', 'codeNm'].forEach(function(col) {
    const th   = document.getElementById('dtl-th-' + col);
    const icon = document.getElementById('dtl-icon-' + col);
    if (!th) return;
    th.classList.remove('asc', 'desc');
    icon.textContent = '⇅';
  });
  if (dtlSortCol) {
    const th   = document.getElementById('dtl-th-' + dtlSortCol);
    const icon = document.getElementById('dtl-icon-' + dtlSortCol);
    if (th) {
      th.classList.add(dtlSortDir);
      icon.textContent = dtlSortDir === 'asc' ? '↑' : '↓';
    }
  }
}

/* ═══════════════════════════════════════════════
   DTL CRUD
═══════════════════════════════════════════════ */

function loadDtl(grpId) {
  fetch('/lottorank/admin/code/dtl/list?codeGrpId=' + encodeURIComponent(grpId))
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success) {
        dtlList = data.list || [];
        renderDtl(dtlList, grpId);
      } else {
        alert(data.msg || '코드 목록 조회에 실패했습니다.');
      }
    });
}

function clearDtl() {
  dtlList    = [];
  dtlSortCol = null;
  dtlSortDir = 'asc';
  updateDtlSortIndicators();
  const badge = document.getElementById('dtlGrpBadge');
  badge.style.display = 'none';
  badge.textContent   = '';
  document.getElementById('btnAddDtl').disabled = true;
  document.getElementById('dtlTbody').innerHTML =
    '<tr id="dtl-empty-row"><td colspan="7" class="empty">위 목록에서 코드그룹을 선택하세요.</td></tr>';
}

function renderDtl(list, grpId) {
  const tbody = document.getElementById('dtlTbody');
  if (!list || list.length === 0) {
    tbody.innerHTML = '<tr id="dtl-empty-row"><td colspan="7" class="empty">등록된 코드가 없습니다.</td></tr>';
    return;
  }
  let html = '';
  list.forEach(function(d) {
    const codeId   = esc(d.codeId   || '');
    const codeNm   = esc(d.codeNm   || '');
    const codeNmEn = esc(d.codeNmEn || '');
    const useYn    = d.useYn   || 'Y';
    const sortOrd  = d.sortOrd != null ? d.sortOrd : 0;
    const createTs = esc(d.createTs || '');
    const badge    = useYn === 'Y'
      ? '<span class="badge-y">사용</span>'
      : '<span class="badge-n">미사용</span>';
    const rowKey = grpId + '__' + codeId;
    const selY = useYn === 'Y' ? 'selected' : '';
    const selN = useYn === 'N' ? 'selected' : '';

    // VIEW ROW
    html +=
      '<tr class="dtl-row-view" id="dtl-view-' + rowKey + '">' +
      '<td><strong>' + codeId + '</strong></td>' +
      '<td>' + codeNm + '</td>' +
      '<td>' + codeNmEn + '</td>' +
      '<td>' + badge + '</td>' +
      '<td>' + sortOrd + '</td>' +
      '<td style="color:var(--g5);font-size:0.8rem">' + createTs + '</td>' +
      '<td>' +
        '<button class="btn-sm btn-edit" onclick="startEditDtl(\'' + escAttr(grpId) + '\',\'' + escAttr(codeId) + '\')">수정</button> ' +
        '<button class="btn-sm btn-del"  onclick="deleteDtl(\'' + escAttr(grpId) + '\',\'' + escAttr(codeId) + '\')">삭제</button>' +
      '</td></tr>';

    // EDIT ROW
    html +=
      '<tr class="dtl-row-edit edit-row-active" id="dtl-edit-' + rowKey + '" style="display:none">' +
      '<td><strong>' + codeId + '</strong></td>' +
      '<td><input type="text" class="cell-input" id="de-nm-' + rowKey + '" value="' + escAttr(codeNm) + '" maxlength="100" placeholder="코드명"></td>' +
      '<td><input type="text" class="cell-input" id="de-nmen-' + rowKey + '" value="' + escAttr(codeNmEn) + '" maxlength="100" placeholder="영문명"></td>' +
      '<td><select class="cell-input" id="de-useyn-' + rowKey + '">' +
        '<option value="Y" ' + selY + '>사용</option><option value="N" ' + selN + '>미사용</option>' +
      '</select></td>' +
      '<td><input type="number" class="cell-input cell-input-sm" id="de-sortord-' + rowKey + '" value="' + sortOrd + '"></td>' +
      '<td style="color:var(--g5);font-size:0.8rem">' + createTs + '</td>' +
      '<td>' +
        '<button class="btn-sm btn-save"   onclick="saveEditDtl(\'' + escAttr(grpId) + '\',\'' + escAttr(codeId) + '\')">저장</button> ' +
        '<button class="btn-sm btn-cancel" onclick="cancelEditDtl(\'' + escAttr(grpId) + '\',\'' + escAttr(codeId) + '\')">취소</button>' +
      '</td></tr>';
  });
  tbody.innerHTML = html;
}

function addDtlRow() {
  if (!selectedGrpId) return;
  if (document.getElementById('dtl-new-row')) {
    document.getElementById('new-dtl-code-id').focus(); return;
  }
  const emptyRow = document.getElementById('dtl-empty-row');
  if (emptyRow) emptyRow.remove();

  const tbody = document.getElementById('dtlTbody');
  const tr    = document.createElement('tr');
  tr.id        = 'dtl-new-row';
  tr.className = 'new-row';
  tr.innerHTML =
    '<td><input type="text" class="cell-input" id="new-dtl-code-id" maxlength="10" placeholder="코드ID"></td>' +
    '<td><input type="text" class="cell-input" id="new-dtl-code-nm" maxlength="100" placeholder="코드명"></td>' +
    '<td><input type="text" class="cell-input" id="new-dtl-code-nm-en" maxlength="100" placeholder="영문명"></td>' +
    '<td><select class="cell-input" id="new-dtl-use-yn">' +
      '<option value="Y">사용</option><option value="N">미사용</option>' +
    '</select></td>' +
    '<td><input type="number" class="cell-input cell-input-sm" id="new-dtl-sort-ord" value="0"></td>' +
    '<td style="color:var(--g5);font-size:0.8rem">-</td>' +
    '<td>' +
      '<button class="btn-sm btn-save"   onclick="saveNewDtl()">저장</button> ' +
      '<button class="btn-sm btn-cancel" onclick="cancelNewDtl()">취소</button>' +
    '</td>';
  tbody.insertBefore(tr, tbody.firstChild);
  document.getElementById('new-dtl-code-id').focus();
}

function cancelNewDtl() {
  const row = document.getElementById('dtl-new-row');
  if (row) row.remove();
  if (!document.querySelector('#dtlTbody .dtl-row-view')) {
    document.getElementById('dtlTbody').innerHTML =
      '<tr id="dtl-empty-row"><td colspan="7" class="empty">등록된 코드가 없습니다.</td></tr>';
  }
}

function saveNewDtl() {
  if (!selectedGrpId) return;
  const codeId   = document.getElementById('new-dtl-code-id').value.trim();
  const codeNm   = document.getElementById('new-dtl-code-nm').value.trim();
  const codeNmEn = document.getElementById('new-dtl-code-nm-en').value.trim();
  const useYn    = document.getElementById('new-dtl-use-yn').value;
  const sortOrd  = document.getElementById('new-dtl-sort-ord').value;

  if (!codeId) { alert('코드ID를 입력하세요.'); document.getElementById('new-dtl-code-id').focus(); return; }
  if (!codeNm) { alert('코드명을 입력하세요.');  document.getElementById('new-dtl-code-nm').focus();  return; }

  postJson('/lottorank/admin/code/dtl/save',
    { codeGrpId: selectedGrpId, codeId, codeNm, codeNmEn, useYn, sortOrd, mode: 'insert' },
    function(data) {
      if (data.success) {
        dtlSortCol = null; dtlSortDir = 'asc';
        updateDtlSortIndicators();
        loadDtl(selectedGrpId);
      } else {
        alert(data.msg || '저장에 실패했습니다.');
      }
    }
  );
}

function startEditDtl(grpId, codeId) {
  const rowKey = grpId + '__' + codeId;
  document.getElementById('dtl-view-' + rowKey).style.display = 'none';
  document.getElementById('dtl-edit-' + rowKey).style.display = '';
  document.getElementById('de-nm-' + rowKey).focus();
}

function cancelEditDtl(grpId, codeId) {
  const rowKey = grpId + '__' + codeId;
  document.getElementById('dtl-edit-' + rowKey).style.display = 'none';
  document.getElementById('dtl-view-' + rowKey).style.display = '';
}

function saveEditDtl(grpId, codeId) {
  const rowKey   = grpId + '__' + codeId;
  const codeNm   = document.getElementById('de-nm-'      + rowKey).value.trim();
  const codeNmEn = document.getElementById('de-nmen-'    + rowKey).value.trim();
  const useYn    = document.getElementById('de-useyn-'   + rowKey).value;
  const sortOrd  = document.getElementById('de-sortord-' + rowKey).value;

  if (!codeNm) { alert('코드명을 입력하세요.'); return; }

  postJson('/lottorank/admin/code/dtl/save',
    { codeGrpId: grpId, codeId, codeNm, codeNmEn, useYn, sortOrd, mode: 'update' },
    function(data) {
      if (data.success) {
        dtlSortCol = null; dtlSortDir = 'asc';
        updateDtlSortIndicators();
        loadDtl(grpId);
      } else {
        alert(data.msg || '저장에 실패했습니다.');
      }
    }
  );
}

function deleteDtl(grpId, codeId) {
  if (!confirm('코드 [' + codeId + ']을(를) 삭제하시겠습니까?')) return;
  postJson('/lottorank/admin/code/dtl/delete',
    { codeGrpId: grpId, codeId },
    function(data) {
      if (data.success) {
        dtlList = dtlList.filter(function(d) {
          return !(d.codeGrpId === grpId && d.codeId === codeId);
        });
        loadDtl(grpId);
      } else {
        alert(data.msg || '삭제에 실패했습니다.');
      }
    }
  );
}

/* ═══════════════════════════════════════════════
   공통 AJAX 헬퍼
═══════════════════════════════════════════════ */
function postJson(url, params, callback) {
  fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams(params)
  })
  .then(function(r) { return r.json(); })
  .then(callback)
  .catch(function(e) { alert('요청 처리 중 오류가 발생했습니다.'); console.error(e); });
}

/* 초기화 */
document.addEventListener('DOMContentLoaded', function() {
  initMstPaging();
});
</script>

</body>
</html>
