// Keep hand-sale and drop-sale price classification identical.
const fs = require('fs');
const path = require('path');
const root = path.resolve(__dirname, '..');
const dir = path.join(root, 'src/main/resources/data/tspire/functions/merchant');
const defs = path.join(fs.readFileSync(path.join(__dirname,'tc-source.txt'),'utf8').trim(), 'data/tconstruct/tinkering/materials/definition');
const tiers = {};
for (const name of fs.readdirSync(defs)) {
  if (!name.endsWith('.json') || /condition|redirect|hidden/.test(name)) continue;
  const data = JSON.parse(fs.readFileSync(path.join(defs,name),'utf8'));
  if (Number.isInteger(data.tier) && data.tier >= 2) tiers[`tconstruct:${name.slice(0,-5)}`] = Math.min(4,data.tier);
}
const crystals = {
  2:['protection','melee_protection','magic_protection','revitalizing','dragonborn'],
  3:['returning'],
  4:['writable','harmonious','draconic']
};
const cfg = path.join(root, 'src/main/resources/data/tspire/functions/config/defaults.mcfunction');
let config = fs.readFileSync(cfg,'utf8');
if (!config.includes('#CFG_SELL_PART_T2')) {
  const at = 'scoreboard players set #CFG_SELL_ANCIENT tspire_config 40';
  const addition = [
    '# 按材料阶级收购：0/1 阶使用上述基础价；混合材料装备取最高阶。',
    'scoreboard players set #CFG_SELL_PART_T2 tspire_config 10',
    'scoreboard players set #CFG_SELL_PART_T3 tspire_config 14',
    'scoreboard players set #CFG_SELL_PART_T4 tspire_config 18',
    '# 水晶按升级 / 防御 / 能力 / 无槽位类别定价。',
    'scoreboard players set #CFG_SELL_CRYSTAL_DEF tspire_config 11',
    'scoreboard players set #CFG_SELL_CRYSTAL_ABILITY tspire_config 13',
    'scoreboard players set #CFG_SELL_CRYSTAL_SLOTLESS tspire_config 15',
    'scoreboard players set #CFG_SELL_TOOL_T2 tspire_config 30',
    'scoreboard players set #CFG_SELL_TOOL_T3 tspire_config 42',
    'scoreboard players set #CFG_SELL_TOOL_T4 tspire_config 50'
  ].join('\n');
  config = config.replace(at, `${at}\n${addition}`);
  fs.writeFileSync(cfg,config);
}
for (const [file, field] of [['sell.mcfunction','SelectedItem'],['sell_drop.mcfunction','Item']]) {
  const target=path.join(dir,file);
  let src=fs.readFileSync(target,'utf8');
  const first=src.indexOf('# BEGIN TIERED BUYBACK');
  const last=src.indexOf('# END TIERED BUYBACK');
  if (first>=0 && last>first) src=src.slice(0,first)+src.slice(last+'# END TIERED BUYBACK'.length).replace(/^\r?\n/,'');
  const lines=src.split(/\r?\n/);
  const saleLines=lines.filter(line=>line.includes('run scoreboard players operation #SELL tspire_timer = #CFG_SELL_'));
  const id = line => (line.match(/id:"tconstruct:([^"]+)"/)||[])[1];
  const parts=new Set(saleLines.filter(x=>x.includes('#CFG_SELL_PART ')).map(id));
  const tools=new Set(saleLines.filter(x=>x.includes('#CFG_SELL_TOOL ')).map(id));
  const rule=[];
  rule.push('# BEGIN TIERED BUYBACK');
  rule.push('# Material tier 0/1 keeps the base price; higher material tier overrides it.');
  rule.push('scoreboard players set #SELL_KIND tspire_timer 0');
  for (const [kind,ids] of [[1,parts],[2,tools]]) for (const item of ids) rule.push(`execute if score #CFG_SELL_ENABLED tspire_config matches 1.. if entity @s[nbt={${field}:{id:"tconstruct:${item}"}}] run scoreboard players set #SELL_KIND tspire_timer ${kind}`);
  rule.push(`execute if score #CFG_SELL_ENABLED tspire_config matches 1.. if entity @s[nbt={${field}:{id:"tconstruct:modifier_crystal"}}] run scoreboard players set #SELL_KIND tspire_timer 3`);
  for (const tier of [2,3,4]) {
    for (const mat of Object.keys(tiers).filter(k=>tiers[k]===tier).sort()) {
      const partNbt=`{${field}:{tag:{Material:"${mat}"}}}`;
      const gearNbt=`{${field}:{tag:{tic_materials:["${mat}"]}}}`;
      rule.push(`execute if score #SELL_KIND tspire_timer matches 1 if entity @s[nbt=${partNbt}] run scoreboard players operation #SELL tspire_timer = #CFG_SELL_PART_T${tier} tspire_config`);
      rule.push(`execute if score #SELL_KIND tspire_timer matches 2 if entity @s[nbt=${gearNbt}] run scoreboard players operation #SELL tspire_timer = #CFG_SELL_TOOL_T${tier} tspire_config`);
    }
  }
  for (const [group,mods] of Object.entries(crystals)) for (const mod of mods) {
    const key = {2:'DEF',3:'ABILITY',4:'SLOTLESS'}[group];
    rule.push(`execute if score #SELL_KIND tspire_timer matches 3 if entity @s[nbt={${field}:{tag:{modifier:"tconstruct:${mod}"}}}] run scoreboard players operation #SELL tspire_timer = #CFG_SELL_CRYSTAL_${key} tspire_config`);
  }
  rule.push('# END TIERED BUYBACK');
  const marker='# v0.6.47 multiply by the stack size';
  const index=src.indexOf(marker);
  if(index<0) throw Error(`${file}: stack marker missing`);
  src=src.slice(0,index)+rule.join('\n')+'\n\n'+src.slice(index);
  fs.writeFileSync(target,src);
}
console.log('Generated matching tiered hand/drop merchant buyback rules.');
