// One-time conversion: the old catalog baked sales into individual candidates.
// Runtime shelf rolls need full prices so exactly two slot-level sales can be drawn.
const fs=require('fs');
const path=require('path');
const file=path.join(__dirname,'shop-catalog.json');
const catalog=JSON.parse(fs.readFileSync(file,'utf8'));
let fixed=0;
for(const rows of Object.values(catalog)) for(const row of rows) for(const item of row) {
  const entry=JSON.parse(item.menu.slice('tellraw @s '.length))[0];
  if(!entry.text.includes('★特价')) continue;
  const before=entry.hoverEvent.contents.match(/原价 (\d+) 金币/);
  const price=before?+before[1]:Math.min(30,item.price*2);
  item.price=price;
  entry.text=entry.text.replace(/ — \d+ 金币 ★特价/,` — ${price} 金币`);
  entry.hoverEvent.contents=entry.hoverEvent.contents.replace(/原价 \d+ 金币｜★特价 \d+ 金币/,`售价 ${price} 金币`).replace(/售价 \d+ 金币/,`售价 ${price} 金币`);
  item.menu=`tellraw @s ${JSON.stringify([entry])}`;
  fixed++;
}
fs.writeFileSync(file,JSON.stringify(catalog,null,2)+'\n');
console.log(`Restored ${fixed} catalog entries to full price.`);
