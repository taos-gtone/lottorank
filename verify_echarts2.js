var BASE = 'C:/Users/230228/node_modules';
var fs = require('fs');

// HandlerProxy에서 이벤트 객체에 event 프로퍼티를 붙이는지 확인
var proxyPath = BASE + '/zrender/lib/dom/HandlerProxy.js';
if (fs.existsSync(proxyPath)) {
  var src = fs.readFileSync(proxyPath, 'utf8');
  console.log('=== HandlerProxy.js ===');
  var lines = src.split('\n');
  for (var i = 0; i < lines.length; i++) {
    var l = lines[i];
    // event 프로퍼티 설정 찾기
    if ((l.indexOf('.event') !== -1 || l.indexOf("['event']") !== -1) && l.indexOf('=') !== -1) {
      console.log('line ' + (i+1) + ':', l.trim());
    }
    // normalizeEvent 함수
    if (l.indexOf('normalizeEvent') !== -1 && l.indexOf('function') !== -1) {
      console.log('line ' + (i+1) + ' [normalizeEvent]:', l.trim());
    }
  }
}

// normalizeEvent 함수 찾기 - event 객체 구조
var normPath = BASE + '/zrender/lib/core/event.js';
if (fs.existsSync(normPath)) {
  var src = fs.readFileSync(normPath, 'utf8');
  console.log('\n=== event.js 전체 (normalizeEvent 주변) ===');
  var lines = src.split('\n');
  var inNorm = false;
  for (var i = 0; i < lines.length; i++) {
    var l = lines[i];
    if (l.indexOf('normalizeEvent') !== -1 || l.indexOf('exports.') !== -1) {
      inNorm = true;
    }
    if (inNorm) {
      console.log('line ' + (i+1) + ':', l);
      if (i > 0 && lines[i].trim() === '}' && inNorm) {
        inNorm = false;
        if (i > 40) break;
      }
    }
  }
}
