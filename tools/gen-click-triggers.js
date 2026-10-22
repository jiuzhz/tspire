// Convert player-facing /function chat clicks to non-operator /trigger clicks.
// Re-run after every source generator; IDs stay stable in click-targets.json.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..'),src=path.join(root,'src/main/resources');
const fn=path.join(src,'data/tspire/functions'),mapFile=path.join(__dirname,'click-targets.json');
const old=fs.existsSync(mapFile)?JSON.parse(fs.readFileSync(mapFile,'utf8')):{};
const map={...old};let next=Math.max(0,...Object.values(map))+1,changed=0;
const click=/((?:\\?"action\\?":\\?"run_command\\?",\\?"value\\?":\\?"))\/function (tspire:[^"\\]+)((?:\\?"))/g;
function walk(d){for(const e of fs.readdirSync(d,{withFileTypes:true})){const p=path.join(d,e.name);if(e.isDirectory())walk(p);else if(/\.(mcfunction|json)$/.test(e.name)){let s=fs.readFileSync(p,'utf8');let t=s.replace(click,(all,beg,target,end)=>{if(target.startsWith('tspire:test/'))return all;if(!map[target])map[target]=next++;return beg+'/trigger tspire_click set '+map[target]+end});if(t!==s){fs.writeFileSync(p,t,'utf8');changed++}}}}walk(src);
fs.writeFileSync(mapFile,JSON.stringify(Object.fromEntries(Object.entries(map).sort((a,b)=>a[1]-b[1])),null,2)+'\n');
const dispatch=['# Player-facing buttons: /trigger is available to non-operators.','# The trigger score is consumed before running any action.','scoreboard players operation #CLICK_ID tspire_timer = @s tspire_click','scoreboard players set @s tspire_click 0'];
for(const [target,id] of Object.entries(map).sort((a,b)=>a[1]-b[1])){
 if(target==='tspire:run/force_start'){
  dispatch.push(`execute if score #CLICK_ID tspire_timer matches ${id} unless score #TUTOR_MODE tspire_timer matches 1 if score #RUN_STARTED tspire_timer matches 1 run function ${target}`);
  dispatch.push(`execute if score #CLICK_ID tspire_timer matches ${id} unless score #TUTOR_MODE tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 3 run function ${target}`);
  continue;
 }
 if(target==='tspire:run/force_end'){
  dispatch.push(`execute if score #CLICK_ID tspire_timer matches ${id} if entity @s[team=tspire_party] unless score #TUTOR_MODE tspire_timer matches 1 if score #RUN_STARTED tspire_timer matches 1 run function ${target}`);
  dispatch.push(`execute if score #CLICK_ID tspire_timer matches ${id} if entity @s[team=tspire_party] unless score #TUTOR_MODE tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 3 run function ${target}`);
  continue;
 }
 let gate='if entity @s[team=tspire_party]';
 if(target==='tspire:run/start'||target==='tspire:run/join_mid'||target==='tspire:run/join_party')gate='';
 else if(target==='tspire:tutorial/request')gate='';
 else if(target==='tspire:tutorial/exit')gate='if entity @s[tag=tspire_tutorial]';
 else if(target==='tspire:tutorial/restart')gate='if entity @s[tag=tspire_tutorial] if score #TUTOR_MODE tspire_timer matches 1 if score #PICK_STAGE tspire_timer matches 3';
 else if(target==='tspire:run/quit')gate='if score @s tspire_phase matches 6';
 else if(!target.startsWith('tspire:run/')){
  gate+=' if score @s tspire_phase matches 5 if entity @s[nbt={Dimension:"tspire:tower"}]';
  if(target.startsWith('tspire:mystery/'))gate+=' if entity @e[tag=tspire_node_current,tag=tspire_type_mystery]';
  // Service nodes lose the current tag later in the same tick. Select the nearby reusable node.
  // Shop stock must be rebuilt at that node, not below the player who clicked.
  if(target.startsWith('tspire:merchant/'))gate+=' at @e[tag=tspire_node_reusable,tag=tspire_type_merchant,distance=..11,limit=1,sort=nearest]';
  if(target.startsWith('tspire:artisan/'))gate+=' at @e[tag=tspire_node_reusable,tag=tspire_type_artisan,distance=..11,limit=1,sort=nearest]';
 }
 dispatch.push(`execute if score #CLICK_ID tspire_timer matches ${id} ${gate} run function ${target}`.replace(/ +run function/,' run function').replace(/  +/g,' '));
}
const out=path.join(fn,'ui/dispatch.mcfunction');fs.mkdirSync(path.dirname(out),{recursive:true});fs.writeFileSync(out,dispatch.join('\n')+'\n');
console.log(`Converted ${changed} files; ${Object.keys(map).length} player actions.`);


