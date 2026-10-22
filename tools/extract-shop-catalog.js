// One-time migration from the v0.7.91 backed-up shelves to a per-item catalog.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..');
const old=path.join(root,'backup/shop-v0.7.91-20261015/shop');
const result={};
for(let f=1;f<=3;f++) {
  const rows=[];
  for(let k=1;k<=16;k++) {
    const fill=fs.readFileSync(path.join(old,`f${f}_l${k}_fill.mcfunction`),'utf8').split(/\r?\n/);
    const menu=fs.readFileSync(path.join(old,`f${f}_l${k}_menu.mcfunction`),'utf8').split(/\r?\n/);
    const slots=[];
    for(let i=0;i<15;i++) {
      const stock=fill.find(line=>line.includes(`container.${i} `) && (line.includes('item replace block')||line.includes('loot replace block')));
      const priceLine=fill.find(line=>line.startsWith(`scoreboard players set #PRICE${i} `));
      const menuLine=menu.find(line=>line.includes(`/function tspire:merchant/buy/slot${i}"`));
      if(!stock||!priceLine||!menuLine) throw Error(`Missing item f${f} l${k} s${i}`);
      slots.push({stock,price:Number(priceLine.split(' ').at(-1)),menu:menuLine});
    }
    rows.push(slots);
  }
  result[`f${f}`]=rows;
}
fs.writeFileSync(path.join(__dirname,'shop-catalog.json'),JSON.stringify(result,null,2)+'\n','utf8');
console.log('Extracted 720 concrete candidates.');
