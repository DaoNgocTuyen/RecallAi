const page=await figma.getNodeByIdAsync('0:1');await figma.setCurrentPageAsync(page);figma.skipInvisibleInstanceChildren=false;
const lib=await figma.getNodeByIdAsync('32:449');await lib.loadAsync();
for(const style of ['Regular','Medium','Semi Bold','Bold'])await figma.loadFontAsync({family:'Inter',style});
const created=[],mutated=[];
function encodedIds(ids){const groups={};for(const id of new Set(ids)){const [prefix,suffix]=id.split(':');if(!groups[prefix])groups[prefix]=[];groups[prefix].push(Number(suffix));}for(const p of Object.keys(groups)){const a=groups[p].sort((a,b)=>a-b);groups[p]=a.map((n,i)=>i?n-a[i-1]:n);}return groups;}
const coll=(await figma.variables.getLocalVariableCollectionsAsync()).find(c=>c.name==='RecallAI v2 · Sémantique');
const vars=await figma.variables.getLocalVariablesAsync();const T=Object.fromEntries(vars.filter(v=>v.variableCollectionId===coll.id).map(v=>[v.name,v]));
const styles=Object.fromEntries((await figma.getLocalTextStylesAsync()).filter(s=>s.name.startsWith('RecallAI v2/')).map(s=>[s.name.split('/')[1],s]));
const effects=await figma.getLocalEffectStylesAsync();const shadow=effects.find(e=>e.name==='RecallAI v2/Soft');
const assetMap=Object.fromEntries(lib.findAllWithCriteria({types:['COMPONENT','COMPONENT_SET']}).map(n=>[n.name,n]));
function asset(name,variant){const a=assetMap[name];if(!a)throw new Error('Missing asset '+name);return a.type==='COMPONENT_SET'?(a.children.find(c=>c.name===variant)||a.children[0]):a;}
const color=k=>figma.variables.setBoundVariableForPaint({type:'SOLID',color:{r:1,g:1,b:1}},'color',T['color/'+k]);
function bg(n,k){n.fills=k?[color(k)]:[];}
function round(n,r=20){n.cornerRadius=r;if(T['radius/'+r])n.setBoundVariable('cornerRadius',T['radius/'+r]);}
function border(n,k='border'){n.strokes=[color(k)];n.strokeWeight=1;}
function box(p,name,w=342,k=null,dir='VERTICAL',gap=16,pad=0){const n=figma.createFrame();created.push(n.id);p.appendChild(n);n.name=name;n.resize(w,40);bg(n,k);n.clipsContent=false;n.layoutMode=dir;n.itemSpacing=gap;n.paddingLeft=n.paddingRight=n.paddingTop=n.paddingBottom=pad;if(dir==='VERTICAL'){n.primaryAxisSizingMode='AUTO';n.counterAxisSizingMode='FIXED';}else{n.primaryAxisSizingMode='FIXED';n.counterAxisSizingMode='AUTO';n.counterAxisAlignItems='CENTER';}if(T['space/'+gap])n.setBoundVariable('itemSpacing',T['space/'+gap]);for(const f of ['paddingLeft','paddingRight','paddingTop','paddingBottom'])if(T['space/'+pad])n.setBoundVariable(f,T['space/'+pad]);return n;}
function text(p,s,style='Body Small',ink='text',w){const t=figma.createText();created.push(t.id);p.appendChild(t);t.name=s;t.textStyleId=styles[style].id;t.characters=s;t.resize(w||p.width-p.paddingLeft-p.paddingRight,20);t.textAutoResize='HEIGHT';bg(t,ink);return t;}
function inst(p,c,name){const n=c.createInstance();created.push(n.id);p.appendChild(n);if(name)n.name=name;return n;}
function icon(p,key,size=24,ink='deepGreen'){const n=inst(p,asset('Biểu tượng / '+key));if(size!==24)n.rescale(size/24);for(const v of n.findAllWithCriteria({types:['VECTOR']}))v.strokes=[color(ink)];return n;}
function setText(n,s,index=0){const t=n.findAllWithCriteria({types:['TEXT']})[index];t.characters=s;return t;}
function action(p,s,key,kind='Chính',w){const n=inst(p,asset('Nút / '+kind,'Cỡ=Vừa, Trạng thái=Mặc định'),'Action / '+key);setText(n,s);if(w)n.resize(w,44);return n;}
function card(p,name,k='surface',w=342){const c=box(p,name,w,k,'VERTICAL',16,16);round(c,24);border(c);if(k==='surface')c.effectStyleId=shadow.id;return c;}
function row(p,name,w=310,gap=12){return box(p,name,w,null,'HORIZONTAL',gap,0);}
function pill(p,s,k='mint',w=310){const b=box(p,s,w,k,'HORIZONTAL',8,8);round(b,999);text(b,s,'Caption','deepGreen',w-16);return b;}
function progress(p,value,w=310){const track=box(p,'Progress / '+value,w,'mint','HORIZONTAL',0,0);track.resize(w,6);track.primaryAxisSizingMode='FIXED';track.counterAxisSizingMode='FIXED';round(track,999);const fill=figma.createRectangle();created.push(fill.id);track.appendChild(fill);fill.resize(Math.max(1,w*value/100),6);bg(fill,'primaryDark');round(fill,999);return track;}
function note(p,s){return text(p,s,'Caption','readable');}
const primaryNames=['06 · Thư viện tài liệu','07 · Thêm tài liệu học tập','08 · AI phân tích tài liệu','09 · Tạo nội dung học tập','10 · Xem trước câu hỏi','11 · Luyện tập kiến thức','12 · Kết quả luyện tập','13 · Giải thích đáp án','14 · Học bằng Flashcard','15 · Lịch ôn tập'];
let stateIndex=page.children.filter(n=>n.name.startsWith('RA · ')).length;
function phone(name,index,tab='Tài liệu',state=false){const f=figma.createFrame();created.push(f.id);page.appendChild(f);f.name=state?'RA · '+name:name;f.resize(390,844);round(f,24);bg(f,'background');f.clipsContent=true;f.x=state?3400+(stateIndex%10)*438:3400+(index%5)*438;f.y=state?2400+Math.floor(stateIndex++/10)*960:140+Math.floor(index/5)*1000;
const status=box(f,'Status',342,null,'HORIZONTAL',16,0);status.x=24;status.y=12;text(status,'9:41','Caption','text',240);text(status,'▮▮  ◉  ▰','Caption','text',86);
const head=box(f,'Header',342,null,'VERTICAL',8,0);head.x=24;head.y=54;const top=row(head,'Back and wordmark',342);const back=text(top,'‹','Heading 1','deepGreen',24);back.name='Action / back';text(top,'RecallAI','Caption','deepGreen',180);text(top,'BẢN MẪU','Caption','readable',110);text(head,name.replace(/^\d+ · /,''),'Heading 1');
const vp=box(f,'Viewport / scroll',390,null,'VERTICAL',0,0);vp.layoutMode='NONE';vp.resize(390,580);vp.x=0;vp.y=162;vp.clipsContent=true;vp.overflowDirection='VERTICAL';
const feed=box(vp,'Feed / Auto Layout',342,null,'VERTICAL',16,0);feed.x=24;feed.y=8;feed.paddingBottom=32;feed.counterAxisAlignItems='CENTER';
const bar=inst(f,asset('Điều hướng / Thanh di động','Đang chọn='+tab),'Navigation / fixed');bar.x=19;bar.y=754;
const home=figma.createRectangle();created.push(home.id);f.appendChild(home);home.name='Home indicator';home.resize(130,4);home.x=130;home.y=832;bg(home,'text');round(home,999);
for(let i=0;i<5;i++){const hit=figma.createFrame();created.push(hit.id);f.appendChild(hit);hit.name='NavHit / '+i;hit.resize(67,66);hit.x=27+67*i;hit.y=754;hit.fills=[];}
return{f,feed,head,back};}
function primary(index){const f=page.children.find(n=>n.name===primaryNames[index]);if(!f)throw new Error('Missing screen '+index);return f;}
function getState(name){return page.children.find(n=>n.name==='RA · '+name);}
function findAction(f,k){return f.findOne(n=>n.name==='Action / '+k);}
const proto=(id,nav='NAVIGATE',duration=.25,type='SMART_ANIMATE')=>{const a={type:'NODE',destinationId:typeof id==='string'?id:id.id,navigation:nav,transition:{type:nav==='OVERLAY'?'DISSOLVE':type,easing:{type:'EASE_OUT'},duration}};if(nav==='NAVIGATE'){a.resetScrollPosition=true;a.resetInteractiveComponents=false;}return a;};
async function on(n,actions,trigger={type:'ON_CLICK'}){try{await n.setReactionsAsync([{trigger,actions:Array.isArray(actions)?actions:[actions]}]);mutated.push(n.id);}catch(e){throw new Error('Prototype '+n.name+' ['+n.id+'] '+String(e)+' Actions: '+JSON.stringify(actions).slice(0,1200));}}
const value=v=>({type:typeof v==='number'?'FLOAT':typeof v==='boolean'?'BOOLEAN':'STRING',resolvedType:typeof v==='number'?'FLOAT':typeof v==='boolean'?'BOOLEAN':'STRING',value:v});
const ref=v=>({type:'VARIABLE_ALIAS',resolvedType:v.resolvedType,value:{type:'VARIABLE_ALIAS',id:v.id}});
const expr=(op,args)=>({type:'EXPRESSION',resolvedType:['EQUALS','AND','LESS_THAN'].includes(op)?'BOOLEAN':'FLOAT',value:{expressionFunction:op,expressionArguments:args}});
let mock=(await figma.variables.getLocalVariableCollectionsAsync()).find(c=>c.name==='RecallAI · Học tập mẫu');
function variable(name,type,initial){const found=vars.find(v=>mock&&v.variableCollectionId===mock.id&&v.name===name);if(found)return found;const v=figma.variables.createVariable(name,mock,type);v.scopes=type==='STRING'?['TEXT_CONTENT']:type==='BOOLEAN'?['ALL_SCOPES']:[];v.setValueForMode(mock.modes[0].modeId,initial);v.setVariableCodeSyntax('WEB','var(--recall-demo-'+name.replace(/\//g,'-')+')');return v;}
function data(){return Object.fromEntries(vars.filter(v=>v.variableCollectionId===mock.id).map(v=>[v.name,v]));}
function set(v,x){return{type:'SET_VARIABLE',variableId:v.id,variableValue:x&&typeof x==='object'?x:value(x)};}
function bind(t,v){t.setBoundVariable('characters',v);}
function conditional(blocks){if(blocks.length===1)return{type:'CONDITIONAL',conditionalBlocks:[{condition:blocks[0].condition||value(true),actions:blocks[0].actions}]};const mid=Math.ceil(blocks.length/2),left=blocks.slice(0,mid),right=blocks.slice(mid);const test=left.map(b=>b.condition).reduce((a,b)=>a?{type:'EXPRESSION',resolvedType:'BOOLEAN',value:{expressionFunction:'OR',expressionArguments:[a,b]}}:b,null);return{type:'CONDITIONAL',conditionalBlocks:[{condition:test,actions:left.length===1?left[0].actions:[conditional(left)]},{actions:right.length===1&&!right[0].condition?right[0].actions:[conditional(right)]}]};}
function eq(v,x){return expr('EQUALS',[ref(v),value(x)]);}
let sources=page.children.find(n=>n.name==='RecallAI · Sources 06–15');
function ensureSources(){if(!sources){sources=box(page,'RecallAI · Sources 06–15',2100,null,'VERTICAL',32,32);sources.x=8000;sources.y=140;}return sources;}
function mergeSet(components,name,w){const set=figma.combineAsVariants(components,ensureSources());set.name=name;set.description='RecallAI · Composant de prototype réutilisable';let y=24;components.forEach((c,i)=>{c.x=24+(i%4)*(w+24);c.y=24+Math.floor(i/4)*(Math.max(...components.map(n=>n.height))+32);y=Math.max(y,c.y+c.height);});set.resize(Math.min(4,components.length)*(w+24)+24,y+24);created.push(set.id);return set;}
function component(w=342){const c=figma.createComponent();created.push(c.id);ensureSources().appendChild(c);c.resize(w,40);c.fills=[];c.layoutMode='VERTICAL';c.primaryAxisSizingMode='AUTO';c.counterAxisSizingMode='FIXED';c.itemSpacing=8;return c;}
async function selector(name,labels,v,width=342){const comps=[];for(const selected of labels){const c=component(width);c.name='Chọn='+selected;const r=row(c,'Options',width,8);for(const label of labels){const w=(width-8*(labels.length-1))/labels.length;const b=box(r,'Option / '+label,w,label===selected?'deepGreen':'surface','HORIZONTAL',0,10);round(b,12);border(b,label===selected?'deepGreen':'border');text(b,label,'Caption',label===selected?'surface':'readable',w-20).textAlignHorizontal='CENTER';}comps.push(c);}const family=mergeSet(comps,name,width);for(const c of comps)for(let i=0;i<labels.length;i++){const actions=[set(v,v.resolvedType==='FLOAT'?Number(labels[i]):labels[i])];if(c!==comps[i])actions.push(proto(comps[i],'CHANGE_TO'));await on(c.children[0].children[i],actions);}return family;}
