// Generate the five player-requested mystery events. Run after editing this file.
const fs = require('fs');
const path = require('path');
const root = path.join(__dirname, '..', 'src', 'main', 'resources', 'data', 'tspire');
const dir = path.join(root, 'functions', 'mystery');
const write = (name, lines) => fs.writeFileSync(path.join(dir, name + '.mcfunction'), lines.join('\n') + '\n', 'utf8');
const say = (target, text, color = 'yellow') => {
  const m = text.match(/^\[([^\]]+)\]\s*(.*)$/);
  const body = m ? [{text:`[${m[1]}] `,color:m[1]==='神秘事件'?'light_purple':color,bold:true},{text:m[2],color}] : [{text,color}];
  return `tellraw ${target} ${JSON.stringify(body)}`;
};
const click = (text, fn, color = 'green', detail = text) => `tellraw @a[team=tspire_party] ${JSON.stringify({text:'  ['+text+'] ',color,bold:true,clickEvent:{action:'run_command',value:'/function tspire:mystery/'+fn},hoverEvent:{action:'show_text',contents:'后果：'+detail.replace(/^[^：]+：/,'')}})}`;
const intro = (n, title, desc, opts) => write('ev_'+n,[
  'function tspire:mystery/room_clear_chat',
  `scoreboard players set #MYST_EV tspire_timer ${ {witch:18,cheese:19,pigs:20,hunger:21,treasure:22}[n]}`,
  `title @a[team=tspire_party] title ${JSON.stringify({text:title,color:'light_purple',bold:true})}`,
  `title @a[team=tspire_party] subtitle ${JSON.stringify({text:desc,color:'gray'})}`,
  say('@a[team=tspire_party]','[神秘事件] '+title.replace(/\s/g,'')+(title.endsWith('！')?'':'：')+desc),
  ...opts.map(o=>click(...o)),
  say('@a[team=tspire_party]','（每人各自决定；全队都选完后房门才会打开）','gray')
]);
const guard = (id, extra='') => `execute if score #MYST_EV tspire_timer matches ${id} if score @s tspire_my_choice matches 0${extra}`;
const handler = (name,id,actions,extra='') => write(name,[...actions.map(a=>`${guard(id,extra)} run ${a}`),`${guard(id,extra)} run scoreboard players set @s tspire_my_choice 1`]);
intro('witch','巫 女','沼泽里，一位神秘的巫女笑着递来四瓶药。',[
 ['拿黑色药水：凋零 20 秒、力量 II 60 秒','witch_black','dark_purple'],['拿红色药水：抗火 180 秒、缓慢 120 秒','witch_red','red'],
 ['拿蓝色药水：速度 300 秒、中毒 40 秒','witch_blue','aqua'],['拿白色药水：生命 -6、获得牛奶桶','witch_white','white']]);
const potion=(name,id,color,effects)=>{const label=({witch_black:'黑色',witch_red:'红色',witch_blue:'蓝色'}[name]);return handler(name,id,[`give @s minecraft:potion{Potion:"minecraft:water",display:{Name:'${JSON.stringify({text:'巫女的'+label+'药水',italic:false})}'},CustomPotionColor:${color},CustomPotionEffects:[${effects.map(([e,d,a])=>`{Id:${e}b,Duration:${d*20},Amplifier:${a}b}`).join(',')}]} 1`,say('@s','[巫女] 你拿走了'+label+'药水，巫女笑得更神秘了。')]);};
potion('witch_black',18,1973790,[[20,20,0],[5,60,1]]);
potion('witch_red',18,15158332,[[12,180,0],[2,120,0]]);
potion('witch_blue',18,3949738,[[1,300,0],[19,40,0]]);
write('witch_white',[`${guard(18)} run function tspire:hp/read`,`${guard(18,' if score #HP_H tspire_timer matches ..13')} run ${say('@s','生命不足，无法选择白色药水。','red')}`,
 ...['damage @s 6 minecraft:magic','give @s minecraft:milk_bucket 1',say('@s','[巫女] 生命-6，获得牛奶。'),'scoreboard players set @s tspire_my_choice 1'].map(a=>`${guard(18,' if score #HP_H tspire_timer matches 14..')} run ${a}`)]);
intro('cheese','奶 酪','房间里堆满了奶酪，空气中都是香味。', [['花 60 金币吃点奶酪：奶酪 ×16','cheese_buy','gold'],['直接离开：得到一件奶酪材料部件','cheese_leave']]);
write('cheese_buy',[`${guard(19)} run scoreboard players operation #TMP tspire_timer = @s tspire_gold`,`${guard(19)} run scoreboard players remove #TMP tspire_timer 60`,`${guard(19,' if score #TMP tspire_timer matches ..-1')} run ${say('@s','[奶酪] 金币不足 60，先选另一条路吧。','red')}`,...['scoreboard players remove @s tspire_gold 60','give @s tconstruct:cheese_ingot 16',say('@s','[奶酪] 花费 60 金币，抱走了 16 个奶酪。'),'scoreboard players set @s tspire_my_choice 1'].map(a=>`${guard(19,' if score #TMP tspire_timer matches 0..')} run ${a}`)]);
// In this TConstruct version, cheese can make a bowstring in the reward material pool.
handler('cheese_leave',19,['loot give @s loot tspire:mystery/cheese_part',say('@s','[奶酪] 获得一件奶酪部件（弓弦或绑带）。')]);
intro('pigs','猪！','一群猪挤满了整个房间，正齐刷刷地看着你。', [['花 200 金币赞美群猪 → 猪猪祝福','pigs_praise','gold','敌人缓慢和虚弱 10 秒；每多一名祝福持有者，两种效果各延长 5 秒'],['想吃群猪：清空牛排，得到培根 ×64','pigs_eat'],['挤出房间：生命 -4','pigs_leave','red']]);
write('pigs_spawn',Array.from({length:9},(_,i)=>`execute at @e[tag=tspire_node_current,limit=1] positioned ~${i%3-2} ~ ~${Math.floor(i/3)-2} run summon minecraft:pig ~ ~ ~ {Tags:["tspire_event_pig"],NoAI:1b,Invulnerable:1b,Silent:1b,PersistenceRequired:1b}`));
write('pigs_praise',[`${guard(20)} run scoreboard players operation #TMP tspire_timer = @s tspire_gold`,`${guard(20)} run scoreboard players remove #TMP tspire_timer 200`,`${guard(20,' if score #TMP tspire_timer matches ..-1')} run ${say('@s','金币不足200。','red')}`,...['scoreboard players remove @s tspire_gold 200','tag @s add tspire_pig_bless',say('@s','获得猪猪祝福：进入战斗或BOSS房时削弱敌人。'),'scoreboard players set @s tspire_my_choice 1'].map(a=>`${guard(20,' if score #TMP tspire_timer matches 0..')} run ${a}`)]);
write('steak_count',['execute store result score #STEAK tspire_timer run clear @s minecraft:cooked_beef 0','clear @s minecraft:cooked_beef',...Array.from({length:40},()=> 'execute if score #STEAK tspire_timer matches 64.. run give @s minecraft:rotten_flesh 64\nexecute if score #STEAK tspire_timer matches 64.. run scoreboard players remove #STEAK tspire_timer 64').flatMap(x=>x.split('\n')),...[32,16,8,4,2,1].flatMap(n=>[`execute if score #STEAK tspire_timer matches ${n}.. run give @s minecraft:rotten_flesh ${n}`,`execute if score #STEAK tspire_timer matches ${n}.. run scoreboard players remove #STEAK tspire_timer ${n}`])]);
write('steak_clear',['clear @s minecraft:cooked_beef']);
handler('pigs_eat',20,['function tspire:mystery/steak_clear','give @s tconstruct:bacon 64',say('@s','[猪！] 背包牛排已清空，获得64个培根。')]);
write('pigs_leave',[`${guard(20)} run function tspire:hp/read`,`${guard(20,' if score #HP_H tspire_timer matches ..9')} run ${say('@s','[猪！] 生命不足，无法硬挤出去。','red')}`,...['damage @s 4 minecraft:magic',say('@s','[猪！] 你从猪群中挤出一条路，生命 -4。','red'),'scoreboard players set @s tspire_my_choice 1'].map(a=>`${guard(20,' if score #HP_H tspire_timer matches 10..')} run ${a}`)]);
write('pig_bless_apply',['scoreboard players set #PIG_N tspire_timer 0','execute as @a[team=tspire_party,tag=tspire_pig_bless] run scoreboard players add #PIG_N tspire_timer 1',...[1,2,3,4,5,6,7,8,9,10,11,12].flatMap((n)=>{const d=10+(n-1)*5, max=n===12?'..':`..${n}`;return ['minecraft:slowness','minecraft:weakness'].map(e=>`execute if score #PIG_N tspire_timer matches ${n}${max} as @e[tag=tspire_mob,distance=..35] run effect give @s ${e} ${d} 0 true`).concat(['minecraft:slowness','minecraft:weakness'].map(e=>`execute if score #PIG_N tspire_timer matches ${n}${max} as @e[tag=tspire_boss,distance=..35] run effect give @s ${e} ${d} 0 true`));})]);
intro('hunger','饥 饿','腐烂的臭味弥漫房间，背包里的牛排全变成了腐肉。', [['忍受饥饿：回满生命，本局持续饥饿','hunger_endure','red'],['花 50 金币强行进食 → 混合药水 ×2','hunger_eat','gold','每瓶药水饮下后有饱和 10 秒、饥饿 180 秒、力量 II 60 秒']]);
write('hunger_convert',['execute as @a[team=tspire_party] run function tspire:mystery/steak_count']);
handler('hunger_endure',21,['effect give @s minecraft:instant_health 1 10 true','tag @s add tspire_hunger','effect give @s minecraft:hunger 1000000 0 true',say('@s','[饥饿] 生命已恢复，但饥饿将持续。')]);
write('hunger_eat',[`${guard(21)} run scoreboard players operation #TMP tspire_timer = @s tspire_gold`,`${guard(21)} run scoreboard players remove #TMP tspire_timer 50`,`${guard(21,' if score #TMP tspire_timer matches ..-1')} run ${say('@s','[饥饿] 金币不足 50，无法强行进食。','red')}`,...['scoreboard players remove @s tspire_gold 50',`give @s minecraft:potion{Potion:"minecraft:water",display:{Name:'${JSON.stringify({text:'腐臭的补给',italic:false})}'},tspireHungerMeal:1b,CustomPotionEffects:[{Id:17b,Duration:3600,Amplifier:0b},{Id:5b,Duration:1200,Amplifier:1b}]} 2`,say('@s','[饥饿] 花费 50 金币，得到两瓶混合药水。'),'scoreboard players set @s tspire_my_choice 1'].map(a=>`${guard(21,' if score #TMP tspire_timer matches 0..')} run ${a}`)]);
write('hunger_meal_drink',['advancement revoke @s only tspire:mystery/hunger_meal','scoreboard players set @s tspire_food_timer 200',say('@s','[饥饿] 饱和效果持续10秒。')]);
intro('treasure','藏 宝 图','房间中央放着一张藏宝图，标记指向第二层的宝箱。', [['拿走藏宝图：持续缓慢，首次进二层宝箱得 300 金币','treasure_take','gold'],['直接离开：随机获得一件特殊奖励','treasure_leave']]);
handler('treasure_take',22,['tag @s add tspire_treasure','effect give @s minecraft:slowness 1000000 0 true',say('@s','[藏宝图] 标记了二层的宝箱；在找到前脚步沉重。')]);
handler('treasure_leave',22,['function tspire:rewards/special_give',say('@s','[藏宝图] 你没拿地图，却找到了一件特殊奖励。')]);
write('treasure_claim',['tag @s remove tspire_treasure','effect clear @s minecraft:slowness','scoreboard players add @s tspire_gold 300',say('@s','[藏宝图] 找到了二层宝箱，获得300金币，缓慢已解除。','gold')]);
// Room entry effects must happen after the event number is set, before players choose.
for(const [name,line] of [['hunger','function tspire:mystery/hunger_convert']]){
 const p=path.join(dir,'ev_'+name+'.mcfunction');let s=fs.readFileSync(p,'utf8');s=s.replace(/(scoreboard players set #MYST_EV tspire_timer \d+\n)/,`$1${line}\n`);fs.writeFileSync(p,s,'utf8');
}
console.log('generated five mystery events');
