let p3=(await figma.variables.getLocalVariableCollectionsAsync()).find(c=>c.name==='RecallAI · Nâng cao mẫu');
const pvCache=Object.fromEntries(vars.filter(v=>p3&&v.variableCollectionId===p3.id).map(v=>[v.name,v]));
function pv(name,type,initial){if(pvCache[name])return pvCache[name];const v=figma.variables.createVariable(name,p3,type);v.scopes=type==='STRING'?['TEXT_CONTENT']:type==='BOOLEAN'?['ALL_SCOPES']:type==='COLOR'?['FRAME_FILL','SHAPE_FILL']:[];v.setValueForMode(p3.modes[0].modeId,initial);v.setVariableCodeSyntax('WEB','var(--recall-advanced-'+name.replace(/\//g,'-')+')');pvCache[name]=v;return v;}
function pdata(){return{...pvCache};}
const p3names=['16 · Thống kê học tập','17 · Kiến thức cần củng cố','18 · Lập kế hoạch ôn thi','19 · Kế hoạch học tập','20 · Lớp học của tôi','21 · Tham gia lớp học','22 · Chi tiết lớp học','23 · Bài kiểm tra được giao','24 · Bài kiểm tra','25 · Kết quả kiểm tra'];
let p3index=page.children.filter(n=>n.name.startsWith('RA3 · ')).length;
function pphone(number,title,tab='Cá nhân',key){const s=phone(title,0,tab,!!key);s.f.name=key?'RA3 · '+key:number+' · '+title;s.head.children.find(n=>n.type==='TEXT').characters=title;s.f.x=key?14000+(p3index%6)*438:48+((number-16)%5)*438;s.f.y=key?2440+Math.floor(p3index++/6)*960:2440+Math.floor((number-16)/5)*1000;return s;}
function pm(number){return page.children.find(n=>n.name===p3names[number-16]);}
function ps(key){return page.children.find(n=>n.name==='RA3 · '+key);}
function body(f){return f.findOne(n=>n.name==='Feed / Auto Layout');}
function field(p,label,val,key){const n=inst(p,asset('Biểu mẫu / Mã mời','Trạng thái=Đã nhập'),'Action / '+key);setText(n,label,0);setText(n,val,1);return n;}
function actionText(p,label,key){const t=text(p,label,'Body Small','deepGreen');t.name='Action / '+key;return t;}
function chip(p,label,key,w=100,active=false){const n=box(p,'Action / '+key,w,active?'deepGreen':'surface','HORIZONTAL',0,12);round(n,16);border(n,active?'deepGreen':'border');text(n,label,'Caption',active?'surface':'deepGreen',w-24).textAlignHorizontal='CENTER';return n;}
function eqN(v,n){return expr('EQUALS',[ref(v),value(n)]);}
function less(a,b){return expr('LESS_THAN',[a,b]);}
function and(a,b){return expr('AND',[a,b]);}
function sum(items){return items.reduce((a,b)=>a?expr('ADDITION',[a,b]):b,null);}
function cvalue(k){return{type:'COLOR',resolvedType:'COLOR',value:k==='primary'?{r:0,g:214/255,b:160/255,a:1}:k==='mint'?{r:221/255,g:248/255,b:240/255,a:1}:{r:1,g:1,b:1,a:1}};}
sources=page.children.find(n=>n.name==='RecallAI · Sources 16–25');if(!sources){sources=box(page,'RecallAI · Sources 16–25',2100,null,'VERTICAL',32,32);sources.x=17000;sources.y=2300;}
