// Minecraft 1.20.1 runtime map: compile the finite positions; roll the layout in game.
const fs=require('fs');
const path=require('path');
const root=path.resolve(__dirname,'..');
const geometry=JSON.parse(fs.readFileSync(path.join(__dirname,'geometry.json'),'utf8'));
const base=path.join(root,'src/main/resources/data/tspire/functions/map/runtime');
fs.mkdirSync(base,{recursive:true});
for(const name of fs.readdirSync(base))if(name.endsWith('.mcfunction'))fs.unlinkSync(path.join(base,name));
const write=(name,lines)=>fs.writeFileSync(path.join(base,name+'.mcfunction'),lines.join('\n')+'\n','utf8');
const types={combat:'minecraft:red_concrete',elite:'minecraft:purple_concrete',artisan:'minecraft:orange_concrete',chest:'minecraft:yellow_concrete',merchant:'minecraft:emerald_block',mystery:'minecraft:cyan_concrete',boss:'minecraft:black_concrete'};
const layer=(floor)=>floor===1?'~':`~${(floor-1)*32}`;
const anchor=(floor)=>`in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ${layer(floor)} ~`;
write('start',[
  '# A new layout is drawn for every floor, every run. The hall is already prepared.',
  'scoreboard players set #MAP_N tspire_timer 0',
  'scoreboard players set #MAP_WIDE tspire_timer 0',
  'scoreboard players set #MAP_FIRST_WIDTH tspire_timer 0',
  'scoreboard players set #MAP_LAST_WIDTH tspire_timer 0',
  'scoreboard players set #MAP_STEP tspire_timer 0',
  'scoreboard players set #PICK_WAIT tspire_timer 0',
  'schedule function tspire:map/runtime/row_1 1t replace'
]);
write('cancel',[
  ...Array.from({length:geometry.rows},(_,i)=>`schedule clear tspire:map/runtime/row_${i+1}`),
  'schedule clear tspire:map/runtime/finish_positions',
  'schedule clear tspire:map/runtime/assign_batch'
]);
for(let row=1;row<=geometry.rows;row++){
  const commands=[`# Draw and place row ${row} of ${geometry.rows}.`,
    'scoreboard players set #MAP_WIDTH tspire_timer 2',
    'execute if predicate tspire:roll/d3 run scoreboard players set #MAP_WIDTH tspire_timer 3',
    'execute if score #MAP_WIDTH tspire_timer matches 2 if predicate tspire:roll/d2 run scoreboard players set #MAP_WIDTH tspire_timer 4'];
  if(row>=13)commands.push(`execute if score #MAP_WIDE tspire_timer matches ..${row-13} run scoreboard players set #MAP_WIDTH tspire_timer 3`);
  commands.push('execute if score #MAP_WIDTH tspire_timer matches 3.. run scoreboard players add #MAP_WIDE tspire_timer 1');
  commands.push('scoreboard players operation #MAP_N tspire_timer += #MAP_WIDTH tspire_timer');
  if(row===1)commands.push('scoreboard players operation #MAP_FIRST_WIDTH tspire_timer = #MAP_WIDTH tspire_timer');
  if(row===15)commands.push('scoreboard players operation #MAP_LAST_WIDTH tspire_timer = #MAP_WIDTH tspire_timer');
  for(let floor=1;floor<=3;floor++)for(let width=2;width<=4;width++)commands.push(`execute if score #FLOOR tspire_timer matches ${floor} if score #MAP_WIDTH tspire_timer matches ${width} ${anchor(floor)} run function tspire:map/runtime/place_f${floor}_r${row}_w${width}`);
  commands.push(`scoreboard players set #MAP_STEP tspire_timer ${row}`);
  commands.push('scoreboard players set #PICK_WAIT tspire_timer 0');
  commands.push(`schedule function tspire:map/runtime/${row<geometry.rows?`row_${row+1}`:'finish_positions'} 1t replace`);
  write(`row_${row}`,commands);
  for(let floor=1;floor<=3;floor++)for(let width=2;width<=4;width++){
    const fixed=row===1?'combat':(floor>=2&&row===15?'artisan':null);
    const lines=[];
    for(let col=0;col<width;col++){
      const x=(col-(width-1)/2)*geometry.colSpacing;
      const z=-row*geometry.rowSpacing;
      const state=row===1?'tspire_node_avail':'tspire_node_locked';
      const typeTag=fixed?`tspire_type_${fixed}`:'tspire_type_pending';
      lines.push(`summon minecraft:marker ~${x} ~ ~${z} {Tags:["tspire_node","tspire_row${row}","tspire_col${col}","${state}","${typeTag}"]}`);
      if(fixed)lines.push(`setblock ~${x} ~-1 ~${z} ${types[fixed]}`);
    }
    write(`place_f${floor}_r${row}_w${width}`,lines);
  }
}
const finish=[
  '# Place the boss, then calculate exact category quotas from the drawn node count.',
  ...[1,2,3].map(f=>`execute if score #FLOOR tspire_timer matches ${f} ${anchor(f)} run function tspire:map/runtime/place_boss`),
  'scoreboard players set #MAP_C100 tspire_timer 100',
  'scoreboard players set #MAP_P23 tspire_timer 23',
  'scoreboard players set #MAP_P7 tspire_timer 7',
  'scoreboard players set #MAP_P8 tspire_timer 8',
  'scoreboard players set #MAP_P20 tspire_timer 20'
];
for(const [score,weight] of [['MYST','23'],['ELITE','7'],['CHEST','8'],['ART','20']]){
  finish.push(`scoreboard players operation #MAP_${score} tspire_timer = #MAP_N tspire_timer`);
  finish.push(`scoreboard players operation #MAP_${score} tspire_timer *= #MAP_P${weight} tspire_timer`);
  finish.push(`scoreboard players operation #MAP_${score} tspire_timer /= #MAP_C100 tspire_timer`);
}
finish.push('scoreboard players set #MAP_MERCH tspire_timer 1');
finish.push('execute if predicate tspire:roll/d2 run scoreboard players set #MAP_MERCH tspire_timer 2');
finish.push('scoreboard players operation #MAP_COMB tspire_timer = #MAP_N tspire_timer');
for(const score of ['MYST','ELITE','CHEST','ART','MERCH'])finish.push(`scoreboard players operation #MAP_COMB tspire_timer -= #MAP_${score} tspire_timer`);
finish.push('scoreboard players operation #MAP_COMB tspire_timer -= #MAP_FIRST_WIDTH tspire_timer');
finish.push('execute if score #FLOOR tspire_timer matches 2..3 run scoreboard players operation #MAP_ART tspire_timer -= #MAP_LAST_WIDTH tspire_timer');
finish.push('scoreboard players set #MAP_STEP tspire_timer 16');
finish.push('scoreboard players set #PICK_WAIT tspire_timer 0');
finish.push('schedule function tspire:map/runtime/assign_batch 1t replace');
write('finish_positions',finish);
write('place_boss',[
  `summon minecraft:marker ~0 ~ ~${-geometry.rows*geometry.rowSpacing-geometry.roomWall-geometry.bossWall-geometry.bossGap} {Tags:["tspire_node","tspire_row16","tspire_col1","tspire_node_locked","tspire_type_boss"]}`,
  `setblock ~0 ~-1 ~${-geometry.rows*geometry.rowSpacing-geometry.roomWall-geometry.bossWall-geometry.bossGap} ${types.boss}`
]);
write('assign_batch',[
  '# Four type assignments per tick keep the floor transition responsive.',
  ...Array.from({length:4},()=> 'execute in tspire:tower if entity @e[tag=tspire_type_pending] run function tspire:map/runtime/assign_one'),
  'scoreboard players set #MAP_STEP tspire_timer 17',
  'scoreboard players set #PICK_WAIT tspire_timer 0',
  'execute in tspire:tower if entity @e[tag=tspire_type_pending] run schedule function tspire:map/runtime/assign_batch 1t replace',
  'execute in tspire:tower unless entity @e[tag=tspire_type_pending] run schedule function tspire:map/build_row_1 1t replace'
]);
const order=[['MYST',1],['ELITE',2],['CHEST',3],['MERCH',4],['ART',5],['COMB',6]];
write('assign_one',[
  'scoreboard players set #MAP_TYPE tspire_timer 0',
  ...order.map(([name,id])=>`execute if score #MAP_TYPE tspire_timer matches 0 if score #MAP_${name} tspire_timer matches 1.. run scoreboard players set #MAP_TYPE tspire_timer ${id}`),
  'execute as @e[tag=tspire_type_pending,sort=random,limit=1] at @s run function tspire:map/runtime/apply_type',
  ...order.map(([name,id])=>`execute if score #MAP_TYPE tspire_timer matches ${id} run scoreboard players remove #MAP_${name} tspire_timer 1`)
]);
const mapped=[['mystery',1],['elite',2],['chest',3],['merchant',4],['artisan',5],['combat',6]];
write('apply_type',[
  ...mapped.flatMap(([name,id])=>[
    `execute if score #MAP_TYPE tspire_timer matches ${id} run tag @s add tspire_type_${name}`,
    `execute if score #MAP_TYPE tspire_timer matches ${id} run setblock ~ ~-1 ~ ${types[name]}`
  ]),
  'tag @s remove tspire_type_pending'
]);
console.log('Generated runtime floor layout, marker positions, and per-tick type assignment.');

// Runtime routes preserve adjacent-column choices with a nearest-room fallback.
const unlock=['# Runtime route unlock: do not reopen a row already entered or completed.'];
for(let r=1;r<=geometry.rows;r++){
 const next=r+1;
 const guard='execute in tspire:tower unless entity @e[tag=tspire_node_done,tag=tspire_row'+next+'] unless entity @e[tag=tspire_node_current,tag=tspire_row'+next+']';
 if(r<geometry.rows){
  for(let c=0;c<geometry.maxCols;c++)for(let d=Math.max(0,c-1);d<=Math.min(geometry.maxCols-1,c+1);d++){
   unlock.push(guard+' if entity @e[tag=tspire_node_done,tag=tspire_row'+r+',tag=tspire_col'+c+'] run tag @e[tag=tspire_node_locked,tag=tspire_row'+next+',tag=tspire_col'+d+'] add tspire_node_avail');
  }
 }else unlock.push(guard+' if entity @e[tag=tspire_node_done,tag=tspire_row'+r+'] run tag @e[tag=tspire_node_locked,tag=tspire_row'+next+'] add tspire_node_avail');
 unlock.push(guard+' unless entity @e[tag=tspire_node_avail,tag=tspire_row'+next+'] at @e[tag=tspire_node_done,tag=tspire_row'+r+',limit=1] run tag @e[tag=tspire_node_locked,tag=tspire_row'+next+',sort=nearest,limit=1] add tspire_node_avail');
 unlock.push('execute in tspire:tower run tag @e[tag=tspire_node_avail,tag=tspire_row'+next+'] remove tspire_node_locked');
}
unlock.push('execute in tspire:tower run function tspire:map/refresh_doors');
write('unlock_next',unlock);
