const fs=require('fs');
const path=require('path');
const root=path.resolve(__dirname,'..');
const dir=path.join(root,'src/main/resources/data/tspire/functions/map/runtime');
const read=n=>fs.readFileSync(path.join(dir,n+'.mcfunction'),'utf8');
const types=['mystery','elite','chest','merchant','artisan','combat'];
const roundDown=(n,p)=>Math.floor(n*p/100);
const seen=new Set();
for(let trial=0;trial<10000;trial++){
  const floor=1+Math.floor(Math.random()*3);
  const widths=[];
  let wide=0;
  for(let r=1;r<=15;r++){
    let w=2+Math.floor(Math.random()*3);
    if(r>=13&&wide<=r-13)w=3;
    if(w>=3)wide++;
    widths.push(w);
  }
  const n=widths.reduce((a,b)=>a+b,0);
  if(n<30||n>60||wide<3)throw Error(`widths: ${widths}`);
  const counts={mystery:roundDown(n,23),elite:roundDown(n,7),chest:roundDown(n,8),artisan:roundDown(n,20),merchant:1+Math.floor(Math.random()*2)};
  counts.combat=n-types.slice(0,5).reduce((a,k)=>a+counts[k],0);
  const nodes=[];
  for(let row=1;row<=15;row++)for(let col=0;col<widths[row-1];col++){
    const fixed=row===1?'combat':(floor>=2&&row===15?'artisan':null);
    if(fixed)counts[fixed]--;
    nodes.push({row,col,type:fixed});
  }
  for(const type of types)if(counts[type]<0)throw Error(`negative quota ${floor}/${type}`);
  const pending=nodes.filter(x=>!x.type);
  for(const type of types)for(let i=0;i<counts[type];i++){
    const index=Math.floor(Math.random()*pending.length);
    if(!pending[index])throw Error(`quota overflow ${type}`);
    pending.splice(index,1)[0].type=type;
  }
  if(pending.length)throw Error('unassigned nodes');
  if(nodes.filter(x=>x.type==='merchant').length<1||nodes.filter(x=>x.type==='merchant').length>2)throw Error('merchant bound');
  if(nodes.filter(x=>x.type==='elite').length<1||nodes.filter(x=>x.type==='chest').length<1||nodes.filter(x=>x.type==='artisan').length<2)throw Error('minimum types');
  if(nodes.some(x=>x.row===1&&x.type!=='combat')||nodes.some(x=>floor>=2&&x.row===15&&x.type!=='artisan'))throw Error('forced row');
  // runtime/unlock_next connects same/adjacent columns and chooses a
  // nearest node when the direct set is empty. Every possible chosen node can advance.
  for(let row=1;row<15;row++)for(let col=0;col<widths[row-1];col++){
    const direct=Array.from({length:widths[row]},(_,c)=>c).filter(c=>Math.abs(c-col)<=1);
    const next=direct.length?direct:[Array.from({length:widths[row]},(_,c)=>c).sort((a,b)=>Math.abs(a-col)-Math.abs(b-col))[0]];
    if(!next.length||next[0]===undefined)throw Error(`broken route ${row}/${col}`);
  }
  seen.add(`${floor}:${widths.join('')}:${nodes.map(x=>x.type[0]).join('')}`);
}
for(let floor=1;floor<=3;floor++)for(let row=1;row<=15;row++)for(let width=2;width<=4;width++){
  const commands=read(`place_f${floor}_r${row}_w${width}`).split(/\r?\n/).filter(x=>x.startsWith('summon '));
  if(commands.length!==width)throw Error(`position count ${floor}/${row}/${width}`);
  for(let col=0;col<width;col++)if(!commands[col].includes(`tspire_col${col}`)||!commands[col].includes(`tspire_row${row}`))throw Error(`position tag ${floor}/${row}/${width}/${col}`);
}
if(!read('finish_positions').includes('schedule function tspire:map/runtime/assign_batch'))throw Error('assignment not scheduled');
if(!read('assign_batch').includes('schedule function tspire:map/build_row_1'))throw Error('room build not scheduled');
console.log(`PASS: 10,000 layouts, ${seen.size} distinct; row widths, type quotas, route fallback, and generated positions.`);
