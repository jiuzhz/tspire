const fs=require('fs');
const path=require('path');
const root=path.resolve(__dirname,'..');
const c=JSON.parse(fs.readFileSync(path.join(__dirname,'shop-catalog.json'),'utf8'));
const shop=path.join(root,'src/main/resources/data/tspire/functions/shop');
const eligible=[0,1,2,3,5,6,7,8,9];
const read=name=>fs.readFileSync(path.join(shop,name+'.mcfunction'),'utf8');
for(let a=0;a<9;a++)for(let rank=0;rank<8;rank++){
  const b=rank>=a?rank+1:rank;
  const slots=[eligible[a],eligible[b]];
  if(new Set(slots).size!==2||slots.some(x=>!eligible.includes(x)))throw Error(`bad draw ${a}/${rank}`);
}
for(let f=1;f<=3;f++)for(let k=1;k<=16;k++)for(let i=0;i<15;i++){
  if(i===4)continue;
  const item=c[`f${f}`][k-1][i];
  if(i===14 && /tconstruct:(melting_pan|war_pick|battlesign|swasher)/.test(item.stock))continue;
  const menu=JSON.parse(item.menu.slice('tellraw @s '.length))[0];
  if(menu.text.includes('★特价'))throw Error(`baked sale ${f}/${i}/${k}`);
  if(!menu.text.includes(` — ${item.price} 金币`))throw Error(`base menu price ${f}/${i}/${k}`);
  if(!read(`f${f}_s${i}_c${k}_fill`).includes(`tspire_timer ${item.price}`))throw Error(`base fill price ${f}/${i}/${k}`);
  if(eligible.includes(i)){
    const sale=Math.max(5,Math.floor(item.price/2));
    const saleMenu=JSON.parse(read(`f${f}_s${i}_c${k}_sale_menu`).slice('tellraw @s '.length))[0];
    if(!saleMenu.text.includes(` — ${sale} 金币 ★特价`)||!saleMenu.hoverEvent.contents.includes(`原价 ${item.price} 金币｜★特价 ${sale} 金币`))throw Error(`sale menu ${f}/${i}/${k}`);
    const dispatch=read(`f${f}_s${i}_menu`);
    if(!dispatch.includes(`tspire_sale_a matches ${i}`)||!dispatch.includes(`tspire_sale_b matches ${i}`))throw Error(`sale dispatch ${f}/${i}`);
  }
}
for(const i of eligible)if(!read(`apply_sale_${i}`).includes(`scoreboard players operation #PRICE${i} tspire_timer /= #SHOP_TWO tspire_timer`))throw Error(`sale price ${i}`);
console.log('PASS: exactly two distinct eligible slots; 3 floors x 16 candidates; sale menus and checkout prices agree.');
