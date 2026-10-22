// Build live, per-slot merchant rolls from a catalog of concrete item candidates.
// The catalog is deliberately checked in; no whole-shelf loadouts are generated.
const fs = require('fs');
const path = require('path');
const root = path.resolve(__dirname, '..');
const fn = path.join(root, 'src/main/resources/data/tspire/functions');
const shop = path.join(fn, 'shop');
const merchant = path.join(fn, 'merchant');
const catalog = JSON.parse(fs.readFileSync(path.join(__dirname, 'shop-catalog.json'), 'utf8'));
const saleSlots = new Set([0,1,2,3,4,6,7,8,9,10]);
const saleMenu = item => {
  const menu=JSON.parse(item.menu.slice('tellraw @s '.length));
  const entry=menu[0];
  const sale=Math.max(5,Math.floor(item.price/2));
  entry.text=entry.text.replace(/ — \d+ 金币/,` — ${sale} 金币 ★特价`);
  entry.hoverEvent.contents=entry.hoverEvent.contents.replace(/售价 \d+ 金币/,`原价 ${item.price} 金币｜★特价 ${sale} 金币`);
  return `tellraw @s ${JSON.stringify(menu)}`;
};
const ancientId = /tconstruct:(melting_pan|war_pick|battlesign|swasher)/;
const specialKind = item => {
  const s=item.stock;
  if(s.includes('seared_fuel_tank')) return 0;
  if(s.includes('golden_apple')) return 1;
  if(s.includes('splash_potion')) return 2;
  if(s.includes('strong_regeneration')) return 5;
  if(s.includes('strength')) return 3;
  if(s.includes('swiftness')) return 4;
  throw Error(`Unknown special: ${s}`);
};
const special={};
for(let f=1;f<=3;f++) {
  special[f]=[];
  for(let kind=0;kind<=5;kind++) {
    special[f][kind]=catalog[`f${f}`].map(row=>row[5]).find(item=>specialKind(item)===kind)
      || Object.values(catalog).flat().map(row=>row[5]).find(item=>specialKind(item)===kind);
    if(!special[f][kind]) throw Error(`Missing special ${f}/${kind}`);
  }
}
const ancient = {};
for (let f=1;f<=3;f++) ancient[f]=catalog[`f${f}`].map(row=>row[14]).filter(item=>ancientId.test(item.stock));
// The archived random sample happened not to contain an ancient item on floor 2.
// Melting pan's tier-2 materials from floor 1 are also legal on floor 2.
if (!ancient[2].length) ancient[2]=[ancient[1][0]];
for (let f=1;f<=3;f++) {
  if (!ancient[f].length) throw Error(`No ancient candidate on floor ${f}`);
  const ordinary=catalog[`f${f}`].map(row=>row[14]).find(item=>!ancientId.test(item.stock));
  for (const row of catalog[`f${f}`]) if (ancientId.test(row[14].stock)) row[14]=ordinary;
}
fs.mkdirSync(shop, {recursive:true});
for (const file of fs.readdirSync(shop)) if (file.endsWith('.mcfunction')) fs.unlinkSync(path.join(shop,file));
const write = (p, lines) => fs.writeFileSync(p, lines.join('\n')+'\n', 'utf8');
const out = (name, lines) => write(path.join(shop,name+'.mcfunction'), lines);
const roll = (score) => [
  `scoreboard players set @s ${score} 1`,
  ...[1,2,4,8].map(bit=>`execute if predicate tspire:roll/d2 run scoreboard players add @s ${score} ${bit}`)
];
const shelfStart = [
  'execute at @e[tag=tspire_shop] run setblock ~ ~ ~ minecraft:air',
  'execute at @e[tag=tspire_shop] run setblock ~ ~-1 ~ minecraft:air',
  'execute in tspire:tower run kill @e[tag=tspire_shop]',
  'summon minecraft:marker ~ ~-2 ~ {Tags:["tspire_shop"]}',
  'execute at @e[tag=tspire_shop] run setblock ~ ~ ~ minecraft:chest{Lock:"tspire_sealed"}',
  'execute at @e[tag=tspire_shop] run setblock ~ ~-1 ~ minecraft:polished_andesite'
];
for (let f=1;f<=3;f++) {
  const pick = [`# Runtime draw: 15 independent slot rolls, each uniform on 1..16.`,`scoreboard players set @s tspire_shop_f ${f}`,`scoreboard players set @s tspire_shop_l 1`,`scoreboard players set @s tspire_shop_anc 0`,`execute if predicate tspire:roll/d20 run scoreboard players set @s tspire_shop_anc 1`,`scoreboard players set @s tspire_shop_spec 0`,`execute unless predicate tspire:roll/d10 run function tspire:shop/pick_special`];
  for(let i=0;i<15;i++) {pick.push(...roll(`tspire_s${i}`));pick.push(`scoreboard players set @s tspire_buy${i} 0`);}
  pick.push('function tspire:shop/pick_sales');
  out(`pick_f${f}`,pick);
  for(let i=0;i<15;i++) {
    const fills=[], menus=[];
    for(let k=1;k<=16;k++) {
      if(i===5) continue;
      const item=catalog[`f${f}`][k-1][i];
      fills.push(`execute if score @s tspire_s${i} matches ${k} run function tspire:shop/f${f}_s${i}_c${k}_fill`);
      if(saleSlots.has(i)) {
        menus.push(`execute unless score @s tspire_sale_a matches ${i} unless score @s tspire_sale_b matches ${i} if score @s tspire_s${i} matches ${k} run function tspire:shop/f${f}_s${i}_c${k}_menu`);
        menus.push(`execute if score @s tspire_sale_a matches ${i} if score @s tspire_s${i} matches ${k} run function tspire:shop/f${f}_s${i}_c${k}_sale_menu`);
        menus.push(`execute if score @s tspire_sale_b matches ${i} if score @s tspire_s${i} matches ${k} run function tspire:shop/f${f}_s${i}_c${k}_sale_menu`);
        out(`f${f}_s${i}_c${k}_sale_menu`,[saleMenu(item)]);
      } else menus.push(`execute if score @s tspire_s${i} matches ${k} run function tspire:shop/f${f}_s${i}_c${k}_menu`);
      out(`f${f}_s${i}_c${k}_fill`,[item.stock,`scoreboard players set #PRICE${i} tspire_timer ${item.price}`]);
      out(`f${f}_s${i}_c${k}_menu`,[item.menu]);
    }
    if (i===5) {
      for(let kind=0;kind<=5;kind++) {
        out(`f${f}_spec${kind}_fill`,[special[f][kind].stock,`scoreboard players set #PRICE5 tspire_timer ${special[f][kind].price}`]);
        out(`f${f}_spec${kind}_menu`,[special[f][kind].menu]);
      }
      fills.push(...Array.from({length:6},(_,kind)=>`execute if score @s tspire_shop_spec matches ${kind} run function tspire:shop/f${f}_spec${kind}_fill`));
      menus.push(...Array.from({length:6},(_,kind)=>`execute if score @s tspire_shop_spec matches ${kind} run function tspire:shop/f${f}_spec${kind}_menu`));
    }
    if (i===14) {
      for(let j=0;j<ancient[f].length;j++) {
        out(`f${f}_anc${j}_fill`,[ancient[f][j].stock,'scoreboard players set #PRICE14 tspire_timer 180']);
        out(`f${f}_anc${j}_menu`,[ancient[f][j].menu]);
      }
      const choice=ancient[f].length===1 ? 0 : 1;
      fills.push(`execute if score @s tspire_shop_anc matches 1 run function tspire:shop/f${f}_anc0_fill`);
      menus.push(`execute if score @s tspire_shop_anc matches 1${choice?' if score @s tspire_s14 matches 1..8':''} run function tspire:shop/f${f}_anc0_menu`);
      if(choice) {fills.push(`execute if score @s tspire_shop_anc matches 1 if score @s tspire_s14 matches 9.. run function tspire:shop/f${f}_anc1_fill`);menus.push(`execute if score @s tspire_shop_anc matches 1 if score @s tspire_s14 matches 9.. run function tspire:shop/f${f}_anc1_menu`);}
      // When ancient is selected, the last ancient dispatch overwrites the
      // ordinary item; menus are handled separately below to avoid two lines.
      menus.splice(0,16,...menus.slice(0,16).map(line=>line.replace('execute if score @s tspire_s14','execute if score @s tspire_shop_anc matches 0 if score @s tspire_s14')));
    }
    if(saleSlots.has(i)) {
      fills.push(`execute if score @s tspire_sale_a matches ${i} run function tspire:shop/apply_sale_${i}`);
      fills.push(`execute if score @s tspire_sale_b matches ${i} run function tspire:shop/apply_sale_${i}`);
    }
    out(`f${f}_s${i}_fill`,fills);out(`f${f}_s${i}_menu`,menus);
  }
}
const weightedDraw=(score,n)=>[
  `scoreboard players set @s ${score} -1`,
  ...Array.from({length:n-1},(_,i)=>`execute if score @s ${score} matches -1 if predicate tspire:roll/d${n-i} run scoreboard players set @s ${score} ${i}`),
  `execute if score @s ${score} matches -1 run scoreboard players set @s ${score} ${n-1}`
];
out('pick_sales',[
  '# Draw exactly two distinct positions among the ten part/crystal slots.',
  ...weightedDraw('tspire_sale_a',10),
  ...weightedDraw('tspire_sale_b',9),
  'execute if score @s tspire_sale_b >= @s tspire_sale_a run scoreboard players add @s tspire_sale_b 1',
  'execute if score @s tspire_sale_a matches 5.. run scoreboard players add @s tspire_sale_a 1',
  'execute if score @s tspire_sale_b matches 5.. run scoreboard players add @s tspire_sale_b 1'
]);
for(const i of saleSlots) out(`apply_sale_${i}`,[
  'scoreboard players set #SHOP_TWO tspire_timer 2',
  `scoreboard players operation #PRICE${i} tspire_timer /= #SHOP_TWO tspire_timer`,
  `execute if score #PRICE${i} tspire_timer matches ..4 run scoreboard players set #PRICE${i} tspire_timer 5`
]);
out('pick_special',[
  'execute if score @s tspire_shop_spec matches 0 if predicate tspire:roll/d5 run scoreboard players set @s tspire_shop_spec 1',
  'execute if score @s tspire_shop_spec matches 0 if predicate tspire:roll/d4 run scoreboard players set @s tspire_shop_spec 2',
  'execute if score @s tspire_shop_spec matches 0 if predicate tspire:roll/d3 run scoreboard players set @s tspire_shop_spec 3',
  'execute if score @s tspire_shop_spec matches 0 if predicate tspire:roll/d2 run scoreboard players set @s tspire_shop_spec 4',
  'execute if score @s tspire_shop_spec matches 0 run scoreboard players set @s tspire_shop_spec 5'
]);
const fallback=[1,2,3].map(f=>`execute unless score @s tspire_shop_f = #FLOOR tspire_timer if score #FLOOR tspire_timer matches ${f} run function tspire:shop/pick_f${f}`);
write(path.join(merchant,'open_own.mcfunction'),[
  '# Runtime per-player shelf; this function is called at the merchant counter.',...fallback,
  'execute unless score @s tspire_sale_a matches 0..10 run function tspire:shop/pick_sales',
  'execute unless score @s tspire_sale_b matches 0..10 run function tspire:shop/pick_sales',
  ...shelfStart,
  ...[1,2,3].flatMap(f=>Array.from({length:15},(_,i)=>`execute if score @s tspire_shop_f matches ${f} run function tspire:shop/f${f}_s${i}_fill`))
]);
const first=catalog.f1[0].map(x=>x.menu);
write(path.join(merchant,'open_menu.mcfunction'),[
  '# Runtime per-player menu; each line follows its separately rolled slot.',
  'execute unless score @s tspire_sale_a matches 0..10 run function tspire:shop/pick_sales',
  'execute unless score @s tspire_sale_b matches 0..10 run function tspire:shop/pick_sales',
  'tellraw @s [{"text":"========== 商人货架 ==========","color":"gold","bold":true}]',
  ...Array.from({length:15},(_,i)=>[1,2,3].map(f=>`execute if score @s tspire_shop_f matches ${f} run function tspire:shop/f${f}_s${i}_menu`)).flat(),
  'tellraw @s [{"text":"也可以直接把要卖的东西丢到商人旁边，他会自动收购。","color":"dark_gray"}]',
  'tellraw @s [{"text":"[出售] 卖出手中的匠魂物品","color":"green","clickEvent":{"action":"run_command","value":"/function tspire:merchant/sell"},"hoverEvent":{"action":"show_text","contents":"部件按材料 6/10/14/18；水晶按类别 9/11/13/15；装备按最高材料 16/30/42/50；远古工具 40"}}]',
  'tellraw @s [{"text":"当前金币：","color":"gray"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"}]',
  'tellraw @s [{"text":"==============================","color":"gold","bold":true}]'
]);
console.log('Generated 15 live slots x 16 candidates x 3 floors.');

// Rebuild the five swasher candidates with full tool data and a runtime fluid roll.
const swasherFluids=["minecraft:water","minecraft:lava","tconstruct:powdered_snow","tconstruct:earth_slime","tconstruct:sky_slime","tconstruct:ichor","tconstruct:molten_queens_slime","tconstruct:molten_netherite"];
const swasherTables=path.join(root,'src/main/resources/data/tspire/loot_tables/shop');
for(const name of fs.readdirSync(swasherTables).filter(n=>/^swasher_.*\.json$/.test(n))){
 const file=path.join(swasherTables,name),table=JSON.parse(fs.readFileSync(file,'utf8'));
 const first=table.pools[0].entries[0];
 let materials=first.functions.find(f=>f.function==='tconstruct:add_tool_data')?.materials;
 if(!materials){const m=first.functions.find(f=>f.function==='minecraft:set_nbt')?.tag.match(/tic_materials:(\[[^\]]+\])/);if(!m)throw Error('Missing swasher materials '+name);materials=JSON.parse(m[1]).map(type=>({type}));}
 const materialIds=materials.map(m=>typeof m==='string'?m:m.type);
 const materialTag='{tic_materials:'+JSON.stringify(materialIds)+'}';
 table.pools[0].entries=swasherFluids.map(fluid=>({type:'minecraft:item',name:'tconstruct:swasher',weight:1,functions:[{function:'minecraft:set_nbt',tag:materialTag},{function:'mantle:set_fluid',fluid:{amount:2000,fluid}}]}));
 fs.writeFileSync(file,JSON.stringify(table,null,2)+'\n');
}

