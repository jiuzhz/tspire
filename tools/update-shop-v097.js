// One-time migration of the checked-in per-slot merchant catalog.
const fs = require('fs');
const path = require('path');
const root = path.resolve(__dirname, '..');
const file = path.join(__dirname, 'shop-catalog.json');
const catalog = JSON.parse(fs.readFileSync(file, 'utf8'));
const materialDir = path.join(fs.readFileSync(path.join(__dirname, 'tc-source.txt'), 'utf8').trim(), 'data/tconstruct/tinkering/materials/definition');
const tiers = {};
for (const name of fs.readdirSync(materialDir)) {
  if (!name.endsWith('.json') || /condition|redirect|hidden/.test(name)) continue;
  const data = JSON.parse(fs.readFileSync(path.join(materialDir, name), 'utf8'));
  if (Number.isInteger(data.tier)) tiers[`tconstruct:${name.slice(0, -5)}`] = Math.max(1, Math.min(4, data.tier));
}
const category = item => {
  const hover = JSON.parse(item.menu.slice('tellraw @s '.length))[0].hoverEvent.contents;
  for (const [zh, en] of [['升级','upgrade'],['防御','defense'],['能力','ability'],['无槽位','slotless']]) if (hover.includes(`（${zh}）`)) return en;
  throw Error(`Unknown crystal category: ${hover}`);
};
const bases = {upgrade:20, defense:24, ability:28, slotless:32};
const hash = s => [...s].reduce((h,c) => (Math.imul(h,33)+c.charCodeAt(0))>>>0, 5381);
function normalize(item, slot, floor, row) {
  const copy = JSON.parse(JSON.stringify(item));
  const oldSlot = +(copy.stock.match(/container\.(\d+)/)||[])[1];
  copy.stock = copy.stock.replace(/container\.\d+/, `container.${slot}`);
  const menu = JSON.parse(copy.menu.slice('tellraw @s '.length));
  const entry = menu[0];
  const sale = entry.text.includes('★特价');
  let base;
  if (slot < 4) {
    const material = (copy.stock.match(/Material:\\?"([^"\\]+)\\?"/)||[])[1];
    if (!material || !tiers[material]) throw Error(`Unknown part material: ${copy.stock}`);
    base = 15 + (tiers[material]-1)*12;
  } else if (slot >= 5 && slot <= 9) base = bases[category(copy)];
  if (base !== undefined) {
    const shift = hash(`${floor}/${row}/${slot}/${copy.stock}`)%11-5;
    copy.price = sale ? Math.max(5, Math.floor((base+shift)/2)) : base+shift;
    entry.text = entry.text.replace(/ — \d+ 金币/, ` — ${copy.price} 金币`);
    entry.hoverEvent.contents = entry.hoverEvent.contents.replace(/原价 \d+ 金币/, `原价 ${base+shift} 金币`).replace(/★特价 \d+ 金币/, `★特价 ${copy.price} 金币`).replace(/售价 \d+ 金币/, `售价 ${copy.price} 金币`);
  }
  entry.text = entry.text.replace(/^\[\d+\]/, `[${slot+1}]`);
  entry.clickEvent.value = `/function tspire:merchant/buy/slot${slot}`;
  copy.menu = `tellraw @s ${JSON.stringify(menu)}`;
  return copy;
}
for (let floor=1;floor<=3;floor++) {
  const rows = catalog[`f${floor}`];
  const crystals = rows.flatMap(row => row.slice(6,10));
  const byCategory = Object.fromEntries(Object.keys(bases).map(k=>[k,crystals.filter(x=>category(x)===k)]));
  for (const k of Object.keys(bases)) if (!byCategory[k].length) throw Error(`Floor ${floor}: no ${k} crystals`);
  const abilityOrSlotless = [...byCategory.ability, ...byCategory.slotless];
  catalog[`f${floor}`] = rows.map((row, i) => {
    const result = [...row];
    result[4] = row[5];
    for (const slot of [5,6,7]) result[slot] = crystals[(i*3 + slot-5)%crystals.length];
    result[8] = abilityOrSlotless[i%abilityOrSlotless.length];
    result[9] = byCategory.slotless[i%byCategory.slotless.length];
    return result.map((item, slot)=>normalize(item,slot,floor,i));
  });
}
fs.writeFileSync(file, JSON.stringify(catalog,null,2)+'\n');
console.log('Migrated shop catalog: parts 1-4; special 5; crystals 6-10.');
