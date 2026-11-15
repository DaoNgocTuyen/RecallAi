
const mainFrames=Array.from({length:14},(_,i)=>sp(i+1));
for(const f of mainFrames){for(const n of f.findAll(n=>n.name==='Action / student-notifications')){const b=n.type==='INSTANCE'?n.detachInstance():n;for(const t of b.findAllWithCriteria({types:['TEXT']}))t.visible=false;icon(b,'bell',20,'deepGreen');}
const avatar=first(f,'student-account');if(avatar){avatar.paddingLeft=avatar.paddingRight=0;avatar.counterAxisAlignItems='CENTER';avatar.primaryAxisAlignItems='CENTER';const t=avatar.findOne(n=>n.type==='TEXT');t.resize(28,20);t.textAlignHorizontal='CENTER';}
}
const source=sp(1),variants=[];
for(const [name,width,collapsed]of [['Laptop · 1280',1280,false],['Tablet · 1024',1024,true],['Sidebar collapsed · 1440',1440,true]]){const f=source.clone();page.appendChild(f);created.push(f.id);f.name='SW · Responsive · '+name;f.x=48000+(sci%2)*1520;f.y=Math.floor(sci++/2)*1020;f.resize(width,900);const side=f.findOne(n=>n.name==='Student sidebar');side.setBoundVariable('width',null);side.resize(collapsed?80:248,900);for(const ch of [side,...side.findAll(n=>'layoutMode'in n)])if(ch.boundVariables?.paddingLeft){for(const k of ['paddingLeft','paddingRight'])ch.setBoundVariable(k,null);ch.paddingLeft=ch.paddingRight=collapsed?16:24;}
for(const n of side.findAll(n=>n.boundVariables?.visible?.id===S['side/labels'].id)){n.setBoundVariable('visible',null);n.visible=!collapsed;}
if(collapsed){const a=side.findOne(n=>n.name==='Student workspace');if(a)a.visible=false;}
const crumb=f.findOne(n=>n.name==='Student breadcrumb');crumb.resize(width<=1024?140:190,crumb.height);
const search=first(f,'global-search');search.minWidth=120;for(const t of search.findAllWithCriteria({types:['TEXT']})){t.layoutSizingHorizontal='FILL';t.textTruncation='ENDING';t.maxLines=1;}
const feed=sf(f),available=width-(collapsed?80:248)-64;feed.resize(available,feed.height);
for(const row of feed.children.filter(n=>n.layoutMode==='HORIZONTAL')){row.layoutSizingHorizontal='FILL';if(['Hoạt động và kế hoạch','Lớp học và gợi ý'].includes(row.name)){for(const card of row.children){card.layoutSizingHorizontal='FILL';for(const c of card.children)if(c.type==='TEXT')c.layoutSizingHorizontal='FILL';}row.counterAxisAlignItems='MIN';}
if(row.name==='Tiếp tục và ôn tập'){row.children[1].resize(width===1024?248:280,row.children[1].height);for(const c of row.children[1].children)if(c.type==='TEXT')c.layoutSizingHorizontal='FILL';}
}
const chart=f.findOne(n=>n.name==='Phút học');if(chart){chart.layoutSizingHorizontal='FILL';chart.itemSpacing=8;for(const col of chart.children){col.layoutSizingHorizontal='FILL';col.minWidth=24;for(const ch of col.children)if(ch.type==='TEXT')ch.layoutSizingHorizontal='FILL';else if(ch.type==='RECTANGLE')ch.resize(28,ch.height);}}
for(const n of f.findAll(n=>n.type==='TEXT'&&n.parent?.layoutMode==='VERTICAL'&&n.width>n.parent.width-(n.parent.paddingLeft||0)-(n.parent.paddingRight||0)))n.layoutSizingHorizontal='FILL';
for(const n of f.findAll(n=>n.name==='Progress / 65'||n.name==='Study progress'))n.layoutSizingHorizontal='FILL';
const toggle=first(f,'toggle-sidebar');await on(toggle,[proto(collapsed?source:page.children.find(n=>n.name==='SW · Responsive · Sidebar collapsed · 1440')||source)]);
variants.push({id:f.id,width});
}
const desktopAll=page.children.filter(n=>/^S\d\d ·|^SW ·/.test(n.name));
for(const f of desktopAll){const side=f.findOne(n=>n.name==='Student sidebar'),num=Number(f.name.slice(1,3));const active=({1:0,2:1,3:2,4:1,5:2,6:2,7:2,8:2,9:3,10:3,11:4,12:5,13:6,14:7})[num]??(f.name.includes('Assessment')?7:0);if(side){for(let i=0;i<9;i++){const nav=side.findOne(n=>n.name==='StudentNav / '+i);bg(nav,i===active?'mint':null);}const account=side.findOne(n=>n.name==='Student workspace');if(account&&!f.name.includes('Responsive'))account.setBoundVariable('visible',S['side/labels']);}}
return{responsive:variants};

