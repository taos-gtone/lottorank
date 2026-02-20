  <script>
    // =============================================
    // 번호 그리드 생성
    // =============================================
    const numGrid = document.getElementById('numGrid');
    const numDisplay = document.getElementById('numDisplay');
    const selectedBall = document.getElementById('selectedBall');
    const submitBtn = document.getElementById('submitBtn');
    let selectedNum = null;

    const getBallClass = (n) => {
      if (n <= 10) return 'range-1';
      if (n <= 20) return 'range-2';
      if (n <= 30) return 'range-3';
      if (n <= 40) return 'range-4';
      return 'range-5';
    };

    const getBallColorInline = (n) => {
      if (n <= 10) return 'background:linear-gradient(135deg,#FFC107,#FF9800);color:#000';
      if (n <= 20) return 'background:linear-gradient(135deg,#2196F3,#1565C0);color:#fff';
      if (n <= 30) return 'background:linear-gradient(135deg,#F44336,#B71C1C);color:#fff';
      if (n <= 40) return 'background:linear-gradient(135deg,#9E9E9E,#616161);color:#fff';
      return 'background:linear-gradient(135deg,#4CAF50,#1B5E20);color:#fff';
    };

    for (let i = 1; i <= 45; i++) {
      const btn = document.createElement('button');
      btn.className = 'num-btn ' + getBallClass(i);
      btn.textContent = i;
      btn.addEventListener('click', () => {
        document.querySelectorAll('.num-btn.selected').forEach(b => b.classList.remove('selected'));
        btn.classList.add('selected');
        selectedNum = i;

        numDisplay.classList.remove('empty');
        selectedBall.textContent = i;
        selectedBall.style.cssText = getBallColorInline(i) + ';width:64px;height:64px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:1.6rem;font-weight:900;box-shadow:0 4px 16px rgba(0,0,0,0.2)';
        submitBtn.disabled = false;
      });
      numGrid.appendChild(btn);
    }

    submitBtn.addEventListener('click', () => {
      if (!selectedNum) return;
      alert('제 1162회 예측 번호 [' + selectedNum + ']이 제출되었습니다!\n당첨 결과는 토요일 오후에 확인하세요.');
    });

    // =============================================
    // 모바일 메뉴
    // =============================================
    const menuBtn = document.getElementById('menuBtn');
    const mobileMenu = document.getElementById('mobileMenu');
    const menuClose = document.getElementById('menuClose');

    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
    menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
    mobileMenu.addEventListener('click', (e) => {
      if (e.target === mobileMenu) mobileMenu.classList.remove('open');
    });

    // =============================================
    // 카운트다운 타이머 (두 곳에 동시 표시)
    // =============================================
    function getNextSaturday8am() {
      const now = new Date();
      const day = now.getDay();
      const daysUntilSat = (6 - day + 7) % 7 || 7;
      const sat = new Date(now);
      sat.setDate(now.getDate() + daysUntilSat);
      sat.setHours(8, 0, 0, 0);
      return sat;
    }

    function updateCountdown() {
      const target = getNextSaturday8am();
      const now = new Date();
      const diff = target - now;

      let text;
      if (diff <= 0) {
        text = '마감';
      } else {
        const d = Math.floor(diff / 86400000);
        const h = Math.floor((diff % 86400000) / 3600000);
        const m = Math.floor((diff % 3600000) / 60000);
        const s = Math.floor((diff % 60000) / 1000);
        text = d + '일 ' + String(h).padStart(2,'0') + ':' + String(m).padStart(2,'0') + ':' + String(s).padStart(2,'0');
      }

      const cd1 = document.getElementById('countdown');
      const cd2 = document.getElementById('countdown2');
      if (cd1) cd1.textContent = text;
      if (cd2) cd2.textContent = text;
    }

    updateCountdown();
    setInterval(updateCountdown, 1000);

    // =============================================
    // 랭킹 탭
    // =============================================
    document.querySelectorAll('.ptab').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('.ptab').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
      });
    });
  </script>
