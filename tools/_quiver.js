const fs = require('fs'), path = require('path');
const root = fs.readFileSync('D:/dswork/tinkers-spire/tools/tc-source.txt', 'utf8').trim();
const out = new Set();
function scan(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) { scan(p); continue; }
    if (!/Quiver/i.test(e.name)) continue;
    const buf = fs.readFileSync(p);
    const s = buf.toString('latin1');
    for (const m of s.matchAll(/[ -~]{4,}/g)) {
      const t = m[0];
      if (/quiver|ammo|arrow|tconstruct:/i.test(t)) out.add(e.name + ' :: ' + t);
    }
  }
}
scan(root);
console.log([...out].slice(0, 60).join('\n'));
console.log('total ' + out.size);
