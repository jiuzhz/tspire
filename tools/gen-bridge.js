// Generate bridge event choices. Each candidate receives a globally unique NBT
// serial, so changing slots, handing it to another player, or dropping it cannot
// redirect the loss to another item.
const fs = require('fs');
const path = require('path');
const root = path.join(__dirname, '..', 'src', 'main', 'resources', 'data', 'tspire');
const functions = path.join(root, 'functions', 'mystery');
const modifiers = path.join(root, 'item_modifiers', 'bridge');
fs.mkdirSync(modifiers, {recursive:true});
const tinkers = ['sword','dagger','cleaver','scythe','broad_axe','crossbow','longbow','plate_shield','travelers_shield','vein_hammer','sledge_hammer','shuriken','throwing_axe','javelin','melting_pan','war_pick','battlesign','swasher'].map(x => 'tconstruct:' + x);
const vanilla = ['wooden','stone','iron','golden','diamond','netherite'].flatMap(x => ['minecraft:' + x + '_sword','minecraft:' + x + '_axe']).concat(['minecraft:bow','minecraft:crossbow','minecraft:trident']);
const weapons = tinkers.concat(vanilla);
const slots = [];
for (let i = 0; i < 36; i++) slots.push({nbt:i,cmd:i < 9 ? 'hotbar.' + i : 'inventory.' + (i-9),label:'背包第 ' + (i+1) + ' 格',weapon:true});
slots.push({nbt:-106,cmd:'weapon.offhand',label:'副手',weapon:true});
for (const [nbt,cmd,label] of [[100,'armor.feet','靴子'],[101,'armor.legs','护腿'],[102,'armor.chest','胸甲'],[103,'armor.head','头盔']]) slots.push({nbt,cmd,label,weapon:false});
function write(name,lines){fs.writeFileSync(path.join(functions,name+'.mcfunction'),lines.join('\n')+'\n','utf8');}
fs.writeFileSync(path.join(modifiers,'mark.json'),JSON.stringify({function:'minecraft:copy_nbt',source:{type:'minecraft:storage',source:'tspire:bridge'},ops:[{source:'serial',target:'tspire_bridge_serial',op:'replace'}]},null,2)+'\n');

const candidate=['# AUTO-GENERATED: one temporary marker per eligible slot.'];
for(let i=0;i<slots.length;i++){
  const s=slots[i], byte=s.nbt+'b';
  candidate.push('scoreboard players set #BR_OK tspire_timer 0');
  if(s.weapon) for(const id of weapons) candidate.push('execute if entity @s[nbt={Inventory:[{Slot:'+byte+',id:"'+id+'"}]}] run scoreboard players set #BR_OK tspire_timer 1');
  else candidate.push('execute if entity @s[nbt={Inventory:[{Slot:'+byte+'}]}] run scoreboard players set #BR_OK tspire_timer 1');
  candidate.push('execute if score #BR_OK tspire_timer matches 1 run summon minecraft:marker ~ ~ ~ {Tags:["tspire_bridge_marker","tspire_bridge_candidate","tspire_bridge_new"]}');
  candidate.push('execute if score #BR_OK tspire_timer matches 1 run scoreboard players set @e[tag=tspire_bridge_new,limit=1] tspire_brslot '+(i+1));
  candidate.push('tag @e[tag=tspire_bridge_new] remove tspire_bridge_new');
}
write('bridge_candidates',candidate);

const prepare=['# Mark each selected stack with a global serial, not just its slot.','scoreboard players set @s tspire_br1 0','scoreboard players set @s tspire_br2 0','scoreboard players set @s tspire_br3 0','scoreboard players set @s tspire_brid1 0','scoreboard players set @s tspire_brid2 0','scoreboard players set @s tspire_brid3 0','function tspire:mystery/bridge_candidates'];
for(let k=1;k<=3;k++){
  prepare.push('execute if entity @e[tag=tspire_bridge_candidate,distance=..0.2] store result score @s tspire_br'+k+' run scoreboard players get @e[tag=tspire_bridge_candidate,distance=..0.2,sort=random,limit=1] tspire_brslot');
  prepare.push('execute if score @s tspire_br'+k+' matches 1.. run scoreboard players operation #BR_SELECTED tspire_timer = @s tspire_br'+k);
  prepare.push('execute if score @s tspire_br'+k+' matches 1.. as @e[tag=tspire_bridge_candidate,distance=..0.2] if score @s tspire_brslot = #BR_SELECTED tspire_timer run tag @s remove tspire_bridge_candidate');
  prepare.push('execute if score @s tspire_br'+k+' matches 1.. run scoreboard players add #BR_SERIAL tspire_timer 1');
  prepare.push('execute if score @s tspire_br'+k+' matches 1.. run scoreboard players operation @s tspire_brid'+k+' = #BR_SERIAL tspire_timer');
  prepare.push('execute if score @s tspire_br'+k+' matches 1.. store result storage tspire:bridge serial int 1 run scoreboard players get #BR_SERIAL tspire_timer');
  for(let i=0;i<slots.length;i++) prepare.push('execute if score @s tspire_br'+k+' matches '+(i+1)+' run item modify entity @s '+slots[i].cmd+' tspire:bridge/mark');
}
prepare.push('kill @e[tag=tspire_bridge_marker,distance=..0.2]','function tspire:mystery/bridge_menu');
write('bridge_prepare',prepare);

const menu=['# Display captured candidates; their unique serials follow the items if moved.','execute if score @s tspire_br1 matches 0 run tellraw @s [{"text":"[吊桥] ","color":"light_purple","bold":true},{"text":"你没有可失去的护甲或武器，直接通过。","color":"yellow"}]','execute if score @s tspire_br1 matches 0 run scoreboard players set @s tspire_my_choice 1','execute if score @s tspire_br1 matches 1.. run tellraw @s {"text":"从以下候选中放弃一件；物品移动、交给队友或丢在地上仍会被追踪。","color":"gray"}'];
for(let k=1;k<=3;k++) for(let i=0;i<slots.length;i++){
  const s=slots[i], fn='/function tspire:mystery/bridge_drop_'+k;
  const parts=[{text:'  [放弃候选 '+k+'] ',color:'red',bold:true,clickEvent:{action:'run_command',value:fn},hoverEvent:{action:'show_text',contents:'放弃抽中时在'+s.label+'的那件物品'}},{text:s.label+' · ',color:'yellow'},{nbt:'Inventory[{Slot:'+s.nbt+'b}].id',entity:'@s',color:'aqua'}];
  menu.push('execute if score @s tspire_br'+k+' matches '+(i+1)+' run tellraw @s '+JSON.stringify(parts));
}
write('bridge_menu',menu);

const scan=['# @s is any online player; #BR_TARGET holds the exact candidate serial.'];
for(const s of slots){
  scan.push('scoreboard players set #BR_SCAN tspire_timer 0');
  scan.push('execute store result score #BR_SCAN tspire_timer run data get entity @s Inventory[{Slot:'+s.nbt+'b}].tag.tspire_bridge_serial');
  scan.push('execute if score #BR_SCAN tspire_timer = #BR_TARGET tspire_timer run item replace entity @s '+s.cmd+' with air');
}
write('bridge_scan_player',scan);
write('bridge_scan_drop',[
  '# @s is a dropped item in the tower dimension.',
  'scoreboard players set #BR_SCAN tspire_timer 0',
  'execute store result score #BR_SCAN tspire_timer run data get entity @s Item.tag.tspire_bridge_serial',
  'execute if score #BR_SCAN tspire_timer = #BR_TARGET tspire_timer run kill @s'
]);
for(let k=1;k<=3;k++){
  write('bridge_drop_'+k,[
    '# Capture chosen serial, then search every player and every tower item entity.',
    'execute if score #MYST_EV tspire_timer matches 24 if score @s tspire_my_choice matches 0 if score @s tspire_br'+k+' matches 1.. run function tspire:mystery/bridge_choose_'+k
  ]);
  write('bridge_choose_'+k,[
    'scoreboard players operation #BR_TARGET tspire_timer = @s tspire_brid'+k,
    'execute as @a run function tspire:mystery/bridge_scan_player',
    'execute in tspire:tower as @e[type=minecraft:item] run function tspire:mystery/bridge_scan_drop',
    'tellraw @s [{"text":"[吊桥] ","color":"light_purple","bold":true},{"text":"你放弃了候选 '+k+'，另外两件留在身上。","color":"yellow"}]',
    'scoreboard players set @s tspire_my_choice '+k
  ]);
}
