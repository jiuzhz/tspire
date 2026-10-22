// apply block rewrites produced by rewrite agents.
// file format (one or more blocks per file), exact single-line markers:
//
//   === START
//   <an exact, UNIQUE single line from the doc: first line of the region>
//   === END
//   <an exact, UNIQUE single line from the doc: last line of the region, inclusive>
//   === REPLACEMENT
//   <replacement markdown; may be empty for a pure deletion>
//   === EOF
//
// markers must be unique in the doc; START must appear before END.
const fs = require('fs');
const path = require('path');
const DOC = 'D:\\dswork\\匠魂尖塔-设计文档-完整整合版.md';
const DIR = 'D:\\dswork\\tinkers-spire\\docs\\doc-audit';

let text = fs.readFileSync(DOC, 'utf8');
// the doc is CRLF -- split on /\r?\n/ and rejoin with the file's own EOL, otherwise every
// exact-line marker lookup fails (markers are trimmed, stored lines still carry "\r").
const EOL = text.includes('\r\n') ? '\r\n' : '\n';
const linesBefore = text.split(/\r?\n/).length;
const ONLY = process.argv[2];   // optional: only files whose name contains this
const files = (fs.existsSync(DIR) ? fs.readdirSync(DIR).filter((f) => /^rewrite-.*\.txt$/.test(f)).sort() : [])
  .filter((f) => !ONLY || f.includes(ONLY));
let applied = 0;
const failed = [];

for (const f of files) {
  const raw = fs.readFileSync(path.join(DIR, f), 'utf8');
  const blocks = raw.split(/^=== START\s*$/m).slice(1);
  if (!blocks.length) { failed.push(f + ': no START block'); continue; }
  for (let bi = 0; bi < blocks.length; bi++) {
    const b = blocks[bi];
    const mEnd = /^=== END\s*$/m.exec(b);
    const mRep = /^=== REPLACEMENT\s*$/m.exec(b);
    const mEof = /^=== EOF\s*$/m.exec(b);
    if (!mEnd || !mRep) { failed.push(f + ' block ' + (bi + 1) + ': missing END/REPLACEMENT'); continue; }
    const startMarker = b.slice(0, mEnd.index).trim();
    const endMarker = b.slice(mEnd.index + mEnd[0].length, mRep.index).trim();
    const replEnd = mEof ? mEof.index : b.length;
    const replacement = b.slice(mRep.index + mRep[0].length, replEnd).replace(/^\n/, '').replace(/\n$/, '');

    const allLines = text.split(/\r?\n/);
    // markers are trimmed when parsed, so compare against TRIMMED lines (a marker line may
    // legitimately carry leading indentation, e.g. list items)
    const idxOf = (m) => allLines.findIndex((l) => l.trim() === m);
    const sIdx = idxOf(startMarker);
    const eIdx = idxOf(endMarker);
    if (sIdx < 0) { failed.push(f + ' block ' + (bi + 1) + ': START not found -> ' + startMarker.slice(0, 70)); continue; }
    if (eIdx < 0) { failed.push(f + ' block ' + (bi + 1) + ': END not found -> ' + endMarker.slice(0, 70)); continue; }
    if (eIdx < sIdx) { failed.push(f + ' block ' + (bi + 1) + ': END before START'); continue; }
    if (allLines.filter((l) => l.trim() === startMarker).length > 1) { failed.push(f + ' block ' + (bi + 1) + ': START not unique'); continue; }
    if (allLines.filter((l) => l.trim() === endMarker).length > 1) { failed.push(f + ' block ' + (bi + 1) + ': END not unique'); continue; }

    const out = allLines.slice(0, sIdx).concat(replacement === '' ? [] : replacement.split(/\r?\n/), allLines.slice(eIdx + 1));
    text = out.join(EOL);
    applied++;
    console.log('  ' + f + ' block ' + (bi + 1) + ': replaced lines ' + (sIdx + 1) + '..' + (eIdx + 1) +
      ' (' + (eIdx - sIdx + 1) + ' -> ' + (replacement === '' ? 0 : replacement.split('\n').length) + ' lines)');
  }
}

fs.writeFileSync(DOC, text, 'utf8');
console.log('rewrite files: ' + files.length + ' (' + files.join(', ') + ')');
console.log('blocks applied: ' + applied + ';  doc lines ' + linesBefore + ' -> ' + text.split(/\r?\n/).length);
if (failed.length) { console.log('FAILED (' + failed.length + '):'); for (const x of failed) console.log('  ' + x); }
else console.log('no failures');
