// Focused consistency check for the staged geometry pipeline.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'../src/main/resources/data/tspire/functions/map');
const read=p=>fs.readFileSync(path.join(root,p+'.mcfunction'),'utf8');
const cmds=s=>s.split(/\r?\n/).filter(x=>x.startsWith('fill ')||x.startsWith('setblock '));
const expected=[...cmds(read('clear_floor')),...cmds(read('build_hall'))];
if(!cmds(read('build_hall')).some(x=>/fill ~-\d+ ~-2 ~-?\d+ ~\d+ ~-2 ~-?\d+ minecraft:polished_andesite/.test(x))) throw Error('Second floor layer missing');
const [x1,z1,x2,z2]=fs.readFileSync(path.join(__dirname,'geometry-forceload.txt'),'utf8').trim().split(/\s+/).map(Number);
const chunks=(z2-z1)/16+1;
if(!Number.isInteger(chunks)) throw Error('Chunk range not aligned');
for(let n=1;n<=chunks;n++) {
  const s=read(`prepare/forceload_${n}`);
  if(!s.includes(`forceload add ${x1} ${z1+(n-1)*16} ${x2} ${z1+(n-1)*16}`)) throw Error(`Bad forceload ${n}`);
  if(!s.includes(n<chunks?`prepare/forceload_${n+1}`:'prepare/f1_1')) throw Error(`Broken forceload chain ${n}`);
}
for(let f=1;f<=3;f++) {
  const actual=[];
  for(let n=1;n<=expected.length;n++) {
    const s=read(`prepare/f${f}_${n}`);
    const line=s.split(/\r?\n/).find(x=>x.includes(' run fill ')||x.includes(' run setblock '));
    if(!line) throw Error(`Missing fill in floor ${f} batch ${n}`);
    actual.push(line.substring(line.indexOf(' run ')+5));
    if(n<expected.length&&!s.includes(`prepare/f${f}_${n+1}`)) throw Error(`Broken floor chain ${f}/${n}`);
  }
  if(actual.join('\n')!==expected.join('\n')) throw Error(`Geometry drift on floor ${f}`);
  const last=read(`prepare/f${f}_${expected.length}`);
  if(f===1) {
    if(!last.includes('prepare/lobby_1')) throw Error('First-floor lobby not scheduled');
  } else if(f===2) { if(!last.includes('prepare/lobby_f2_1')) throw Error('Second-floor lobby not scheduled'); }
  else if(f===3) { if(!last.includes('prepare/lobby_f3_1')) throw Error('Third-floor lobby not scheduled'); }
}
const lobby=cmds(read('lobby_deco'));
const lobbyCount=Math.ceil(lobby.length/48), reconstructed=[];
for(let n=1;n<=lobbyCount;n++) {
  const s=read(`prepare/lobby_${n}`);
  const placed=s.split(/\r?\n/).filter(x=>x.includes(' run fill '));
  if(placed.some(x=>x.includes(' positioned ~ ~32 ~'))) throw Error(`Floor-1 lobby has wrong Y anchor in batch ${n}`);
  reconstructed.push(...placed.map(x=>x.substring(x.indexOf(' run ')+5)));
  if(n<lobbyCount&&!s.includes(`prepare/lobby_${n+1}`)) throw Error(`Broken lobby chain ${n}`);
}
if(reconstructed.join('\n')!==lobby.join('\n')) throw Error('Lobby snapshot drift');
if(!read(`prepare/lobby_${lobbyCount}`).includes('#MAP_READY1')) throw Error('Lobby never marks floor 1 ready');
const lobbyF2=cmds(read('lobby_f2_deco'));
const lobbyF2Count=Math.ceil(lobbyF2.length/48), reconstructedF2=[];
for(let n=1;n<=lobbyF2Count;n++) {
  const s=read(`prepare/lobby_f2_${n}`);
  const placed=s.split(/\r?\n/).filter(x=>x.includes(' run fill '));
  if(placed.some(x=>!x.includes(' positioned ~ ~32 ~ run fill '))) throw Error(`Floor-2 lobby has wrong Y anchor in batch ${n}`);
  reconstructedF2.push(...placed.map(x=>x.substring(x.indexOf(' run ')+5)));
  if(n<lobbyF2Count&&!s.includes(`prepare/lobby_f2_${n+1}`)) throw Error(`Broken floor-2 lobby chain ${n}`);
}
if(reconstructedF2.join('\n')!==lobbyF2.join('\n')) throw Error('Floor-2 lobby snapshot drift');
if(!read(`prepare/lobby_f2_${lobbyF2Count}`).includes('#MAP_READY2')) throw Error('Floor-2 lobby never marks ready');
const lobbyF3=cmds(read('lobby_f3_deco'));
const lobbyF3Count=Math.ceil(lobbyF3.length/48), reconstructedF3=[];
for(let n=1;n<=lobbyF3Count;n++) {
  const s=read(`prepare/lobby_f3_${n}`);
  const placed=s.split(/\r?\n/).filter(x=>x.includes(' run fill '));
  if(placed.some(x=>!x.includes(' positioned ~ ~64 ~ run fill '))) throw Error(`Floor-3 lobby has wrong Y anchor in batch ${n}`);
  reconstructedF3.push(...placed.map(x=>x.substring(x.indexOf(' run ')+5)));
  if(n<lobbyF3Count&&!s.includes(`prepare/lobby_f3_${n+1}`)) throw Error(`Broken floor-3 lobby chain ${n}`);
}
if(reconstructedF3.join('\n')!==lobbyF3.join('\n')) throw Error('Floor-3 lobby snapshot drift');
if(!read(`prepare/lobby_f3_${lobbyF3Count}`).includes('#MAP_READY3')) throw Error('Floor-3 lobby never marks ready');
if(!read(`prepare/lobby_f3_${lobbyF3Count}`).includes('#MAP_BUILDING tspire_timer 0')) throw Error('Floor-3 lobby never ends preparation');
for(let row=1;row<=16;row++) {
  const s=read(`build_row_${row}`);
  if(row<16&&!s.includes(`map/build_row_${row+1}`)) throw Error(`Broken room chain ${row}`);
  if(row<16&&(!s.includes('matches 1..2')||!s.includes('map/room_entry_lights'))) throw Error(`Missing floor 1-2 room lights in row ${row}`);
}
for(const z of ['~8','~9','~-8','~-9']) if(!read('room_entry_lights').includes(`setblock ~ ~4 ${z} minecraft:sea_lantern`)) throw Error(`Room light position drift at ${z}`);
if(!read('room_boss').includes('fill ~-2 ~ ~15 ~2 ~2 ~16')) throw Error('Boss door not five wide');
if(!read('build_row_15').includes('fill ~-2 ~ ~-8 ~2 ~2 ~-9')) throw Error('Row 15 door not five wide');
console.log(`PASS: ${chunks} chunk rows, ${expected.length} fixed commands per floor, 16 room rows, five-wide boss passage.`);
