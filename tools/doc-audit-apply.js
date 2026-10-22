// apply audited doc fixes: exact-match, uniqueness-checked, with a failure report
// input : D:\dswork\_audit\*.json  -> [{line, old, new, why}, ...]
// output: rewrites the design doc in place (UTF-8, LF) + prints applied/failed
const fs = require('fs');
const path = require('path');
const DOC = 'D:\\dswork\\匠魂尖塔-设计文档-完整整合版.md';
const DIR = 'D:\\dswork\\tinkers-spire\\docs\\doc-audit';

let text = fs.readFileSync(DOC, 'utf8');
const before = text.split('\n').length;
const ONLY = process.argv[2];   // optional: only files whose name contains this
const files = (fs.existsSync(DIR) ? fs.readdirSync(DIR).filter((f) => f.endsWith('.json')).sort() : [])
  .filter((f) => !ONLY || f.includes(ONLY));
let applied = 0;
const failed = [];

for (const f of files) {
  let arr;
  try { arr = JSON.parse(fs.readFileSync(path.join(DIR, f), 'utf8')); }
  catch (e) { failed.push(f + ': JSON parse error: ' + e.message); continue; }
  if (!Array.isArray(arr)) { failed.push(f + ': not an array'); continue; }
  for (const item of arr) {
    const oldS = item.old, newS = item['new'];
    if (typeof oldS !== 'string' || typeof newS !== 'string' || !oldS) {
      failed.push(f + ': bad item ' + JSON.stringify(item).slice(0, 90)); continue;
    }
    const n = text.split(oldS).length - 1;
    if (n === 0) { failed.push(f + ' L' + item.line + ': NO MATCH -> ' + oldS.slice(0, 70)); continue; }
    if (n > 1) { failed.push(f + ' L' + item.line + ': ' + n + ' MATCHES (not unique) -> ' + oldS.slice(0, 70)); continue; }
    text = text.replace(oldS, newS);
    applied++;
  }
}

fs.writeFileSync(DOC, text, 'utf8');
console.log('files read: ' + files.length + ' (' + files.join(', ') + ')');
console.log('applied: ' + applied + ' fix(es);  doc lines ' + before + ' -> ' + text.split('\n').length);
if (failed.length) {
  console.log('FAILED (' + failed.length + '):');
  for (const x of failed) console.log('  ' + x);
} else {
  console.log('no failures');
}
