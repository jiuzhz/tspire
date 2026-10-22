// Split fixed tower geometry and node rooms into small scheduled batches.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..');
const map=path.join(root,'src/main/resources/data/tspire/functions/map');
const prep=path.join(map,'prepare');
fs.mkdirSync(prep,{recursive:true});
for(const f of fs.readdirSync(prep)) if(/^(f[123]_\d+|forceload_\d+|lobby_\d+|lobby_f2_\d+|lobby_f3_\d+)\.mcfunction$/.test(f)) fs.unlinkSync(path.join(prep,f));
const read=n=>fs.readFileSync(path.join(map,n+'.mcfunction'),'utf8').split(/\r?\n/).filter(x=>x.startsWith('fill ')||x.startsWith('setblock '));
const commands=[...read('clear_floor'),...read('build_hall')];
const write=(p,lines)=>fs.writeFileSync(p,lines.join('\n')+'\n','utf8');
const lobby=read('lobby_deco');
if(!lobby.length) throw Error('First-floor lobby snapshot missing');
const lobbyBatch=48, lobbyCount=Math.ceil(lobby.length/lobbyBatch);
for(let i=0;i<lobbyCount;i++) {
  const lines=[`# First-floor hand-built lobby, batch ${i+1}/${lobbyCount}.`];
  for(const cmd of lobby.slice(i*lobbyBatch,(i+1)*lobbyBatch))
    lines.push(`execute in tspire:tower at @e[tag=tspire_anchor,limit=1] run ${cmd}`);
  if(i+1<lobbyCount) lines.push(`schedule function tspire:map/prepare/lobby_${i+2} 1t replace`);
  else {
    lines.push('scoreboard players set #MAP_READY1 tspire_timer 1');
    lines.push('schedule function tspire:map/prepare/f2_1 1t replace');
  }
  write(path.join(prep,`lobby_${i+1}.mcfunction`),lines);
}
const lobbyF2=read('lobby_f2_deco');
if(!lobbyF2.length) throw Error('Second-floor lobby snapshot missing');
const lobbyF2Count=Math.ceil(lobbyF2.length/lobbyBatch);
for(let i=0;i<lobbyF2Count;i++) {
  const lines=[`# Second-floor hand-built lobby, batch ${i+1}/${lobbyF2Count}.`];
  for(const cmd of lobbyF2.slice(i*lobbyBatch,(i+1)*lobbyBatch))
    lines.push(`execute in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~32 ~ run ${cmd}`);
  if(i+1<lobbyF2Count) lines.push(`schedule function tspire:map/prepare/lobby_f2_${i+2} 1t replace`);
  else {
    lines.push('scoreboard players set #MAP_READY2 tspire_timer 1');
    lines.push('schedule function tspire:map/prepare/f3_1 1t replace');
  }
  write(path.join(prep,`lobby_f2_${i+1}.mcfunction`),lines);
}
const lobbyF3=read('lobby_f3_deco');
if(!lobbyF3.length) throw Error('Third-floor lobby snapshot missing');
const lobbyF3Count=Math.ceil(lobbyF3.length/lobbyBatch);
for(let i=0;i<lobbyF3Count;i++) {
  const lines=[`# Third-floor hand-built lobby, batch ${i+1}/${lobbyF3Count}.`];
  for(const cmd of lobbyF3.slice(i*lobbyBatch,(i+1)*lobbyBatch))
    lines.push(`execute in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~64 ~ run ${cmd}`);
  if(i+1<lobbyF3Count) lines.push(`schedule function tspire:map/prepare/lobby_f3_${i+2} 1t replace`);
  else {
    lines.push('scoreboard players set #MAP_READY3 tspire_timer 1');
    lines.push('scoreboard players set #MAP_BUILDING tspire_timer 0');
  }
  write(path.join(prep,`lobby_f3_${i+1}.mcfunction`),lines);
}
const [loadX1,loadZ1,loadX2,loadZ2]=fs.readFileSync(path.join(__dirname,'geometry-forceload.txt'),'utf8').trim().split(/\s+/).map(Number);
const loadRows=(loadZ2-loadZ1)/16+1;
if(!Number.isInteger(loadRows)||loadRows<1) throw Error('Invalid forceload geometry');
for(let i=0;i<loadRows;i++) {
  const z=loadZ1+i*16;
  write(path.join(prep,`forceload_${i+1}.mcfunction`),[
    `execute in tspire:tower run forceload add ${loadX1} ${z} ${loadX2} ${z}`,
    `schedule function tspire:map/prepare/${i+1<loadRows?`forceload_${i+2}`:'f1_1'} 1t replace`
  ]);
}
for(let floor=1;floor<=3;floor++) {
  const y=(floor-1)*32, batch=1;
  const count=Math.ceil(commands.length/batch);
  for(let i=0;i<count;i++) {
    const lines=[`# Fixed hall preparation: floor ${floor}, batch ${i+1}/${count}.`];
    for(const cmd of commands.slice(i*batch,(i+1)*batch))
      lines.push(`execute in tspire:tower at @e[tag=tspire_anchor,limit=1] positioned ~ ~${y} ~ run ${cmd}`);
    if(i+1<count) lines.push(`schedule function tspire:map/prepare/f${floor}_${i+2} 1t replace`);
    else {
      if(floor===1) lines.push('schedule function tspire:map/prepare/lobby_1 1t replace');
      else if(floor===2) lines.push('schedule function tspire:map/prepare/lobby_f2_1 1t replace');
      else if(floor===3) lines.push('schedule function tspire:map/prepare/lobby_f3_1 1t replace');
      else {
        lines.push(`scoreboard players set #MAP_READY${floor} tspire_timer 1`);
        if(floor<3) lines.push(`schedule function tspire:map/prepare/f${floor+1}_1 1t replace`);
        else lines.push('scoreboard players set #MAP_BUILDING tspire_timer 0');
      }
    }
    write(path.join(prep,`f${floor}_${i+1}.mcfunction`),lines);
  }
}
// Carve at most one row per tick. The players are teleported only after row 16.
for(let row=1;row<=16;row++) {
  const lines=[`# Carve row ${row} after the map markers are drawn.`];
  if(row<16) {
    lines.push(`execute in tspire:tower as @e[tag=tspire_node,tag=tspire_row${row}] at @s run function tspire:map/room_shell`);
    lines.push(`execute if score #FLOOR tspire_timer matches 1..2 in tspire:tower as @e[tag=tspire_node,tag=tspire_row${row}] at @s run function tspire:map/room_entry_lights`);
    if(row===15) lines.push('execute in tspire:tower as @e[tag=tspire_node,tag=tspire_row15] at @s run fill ~-2 ~ ~-8 ~2 ~2 ~-9 minecraft:air');
  } else lines.push('execute in tspire:tower as @e[tag=tspire_node,tag=tspire_type_boss] at @s run function tspire:map/room_boss');
  lines.push(`scoreboard players set #MAP_STEP tspire_timer ${20+row}`);
  lines.push('scoreboard players set #PICK_WAIT tspire_timer 0');
  if(row<16) lines.push(`schedule function tspire:map/build_row_${row+1} 1t replace`);
  else {
    lines.push('execute in tspire:tower run function tspire:map/refresh_doors');
    lines.push('execute unless score #PICK_STAGE tspire_timer matches 9 if score #FLOOR tspire_timer matches 2..3 run function tspire:run/next_floor_finish');
    lines.push('execute if score #PICK_STAGE tspire_timer matches 9 run scoreboard players set #PICK_STAGE tspire_timer 2');
  }
  write(path.join(map,`build_row_${row}.mcfunction`),lines);
}
write(path.join(map,'room_entry_lights.mcfunction'),[
  '# Four sea lanterns, two above each doorway, mirrored north and south.',
  '# Node centre is y=walk level; doorway roof is y+4.',
  'setblock ~ ~4 ~8 minecraft:sea_lantern',
  'setblock ~ ~4 ~9 minecraft:sea_lantern',
  'setblock ~ ~4 ~-8 minecraft:sea_lantern',
  'setblock ~ ~4 ~-9 minecraft:sea_lantern'
]);
console.log(`Prepared ${commands.length} fixed commands per floor, ${lobbyCount} first-floor and ${lobbyF2Count} second-floor and ${lobbyF3Count} third-floor lobby batches, plus 16 room rows.`);
