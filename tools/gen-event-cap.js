// Build uniformly random mystery pools using each event's per-run cap.
const fs = require('fs');
const path = require('path');
const out = path.join(__dirname,'..','src','main','resources','data','tspire','functions','mystery');
const pools = {
  1:[1,2,3,7,8,9,10,13,12,15,16,17,18,19,20,22,23,24],
  2:[1,2,5,6,7,8,9,10,13,12,15,16,17,18,19,20,21,23,24],
  3:[2,4,6,7,9,11,12,14,15,16,17,21,20,23,24]
};
for(const [floor,events] of Object.entries(pools)){
  const lines=['# Eligible events receive one marker each; random marker = uniform among eligible events.'];
  events.forEach((id,index)=>{
    const cap=id===9?2:([2,7,12,16,24].includes(id)?1:0);
    lines.push('execute if score #ME_'+id+' tspire_timer matches ..'+cap+(id===16?' unless score #PARTY_SIZE tspire_timer matches 3..':'')+' run summon minecraft:marker ~ ~ ~ {Tags:["tspire_event_draw","tspire_event_draw_new"]}');
    lines.push('execute if entity @e[tag=tspire_event_draw_new,limit=1] run scoreboard players set @e[tag=tspire_event_draw_new,limit=1] tspire_brslot '+(index+1));
    lines.push('tag @e[tag=tspire_event_draw_new] remove tspire_event_draw_new');
  });
  fs.writeFileSync(path.join(out,'available_f'+floor+'.mcfunction'),lines.join('\n')+'\n');
}
fs.writeFileSync(path.join(out,'event_cap_count.mcfunction'),[
  '# One shared counter per event type across all three floors.',
  ...Array.from({length:24},(_,i)=>'execute if score #MYST_EV tspire_timer matches '+(i+1)+' run scoreboard players add #ME_'+(i+1)+' tspire_timer 1')
].join('\n')+'\n');
fs.writeFileSync(path.join(out,'event_cap_init.mcfunction'),[
  '# Initialize missing counters on reload without erasing an active run.',
  ...Array.from({length:24},(_,i)=>'scoreboard players add #ME_'+(i+1)+' tspire_timer 0')
].join('\n')+'\n');
