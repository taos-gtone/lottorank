var BASE = 'C:/Users/230228/node_modules';
var echarts = require(BASE + '/echarts');
var fs = require('fs');

console.log('=== ECharts 5.4.3 API 검증 ===');
console.log('ECharts version:', echarts.version);

// 1. getZr() 메서드 존재 확인 (dist 파일에서)
var distPath = BASE + '/echarts/dist/echarts.esm.js';
if (!fs.existsSync(distPath)) {
  distPath = BASE + '/echarts/index.js';
}
var src = fs.readFileSync(distPath, 'utf8');
var getZrIdx = src.indexOf('getZr');
console.log('\n[1] getZr() 메서드 존재:', getZrIdx !== -1);
if (getZrIdx !== -1) {
  console.log('[1] 코드 주변:', src.substring(getZrIdx - 10, getZrIdx + 50).replace(/\n/g,''));
}

// 2. zrender Handler에서 native event 확인
var zrFiles = [
  BASE + '/zrender/lib/Handler.js',
  BASE + '/echarts/node_modules/zrender/lib/Handler.js'
];
zrFiles.forEach(function(p) {
  if (fs.existsSync(p)) {
    var s = fs.readFileSync(p, 'utf8');
    console.log('\n[2] zrender Handler:', p.split('/').pop());
    // event 프로퍼티 설정 찾기
    var lines = s.split('\n');
    for (var i = 0; i < lines.length; i++) {
      var l = lines[i];
      if ((l.indexOf('.event') !== -1 || l.indexOf("'event'") !== -1 || l.indexOf('"event"') !== -1)
           && (l.indexOf('native') !== -1 || l.indexOf('domEvent') !== -1 || l.indexOf('original') !== -1)) {
        console.log('  line ' + (i+1) + ':', l.trim());
      }
    }
    // 전체 event 관련 라인 (20개 이내)
    var cnt = 0;
    for (var i = 0; i < lines.length && cnt < 10; i++) {
      var l = lines[i];
      if (l.indexOf('event') !== -1 && l.indexOf('=') !== -1 && l.indexOf('//') === -1) {
        console.log('  event line ' + (i+1) + ':', l.trim());
        cnt++;
      }
    }
  }
});

// 3. zrender Event 객체 구조 확인
var evFiles = [
  BASE + '/zrender/lib/core/event.js',
];
evFiles.forEach(function(p) {
  if (fs.existsSync(p)) {
    var s = fs.readFileSync(p, 'utf8');
    console.log('\n[3] zrender event.js 구조:');
    var lines = s.split('\n');
    for (var i = 0; i < Math.min(lines.length, 100); i++) {
      var l = lines[i];
      if (l.indexOf('exports.') !== -1 || l.indexOf('clientX') !== -1 ||
          l.indexOf('ZRenderEvent') !== -1 || l.indexOf('event') !== -1) {
        console.log('  line ' + (i+1) + ':', l.trim());
      }
    }
  }
});

// 4. 실제 ZRenderEvent 타입에 'event' 프로퍼티가 있는지 타입 정의 확인
var typeFiles = [
  BASE + '/zrender/lib/Handler.d.ts',
  BASE + '/echarts/node_modules/zrender/lib/Handler.d.ts'
];
typeFiles.forEach(function(p) {
  if (fs.existsSync(p)) {
    console.log('\n[4] Handler type def:', fs.readFileSync(p,'utf8').substring(0, 500));
  }
});
