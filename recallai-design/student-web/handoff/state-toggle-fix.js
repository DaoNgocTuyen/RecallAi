
sv('side/before','BOOLEAN',true);
const toggle=[sset('side/before',sref('side/labels')),conditional([{condition:se('side/before',true),actions:[sset('side/width',80),sset('side/padding',16),sset('side/labels',false)]},{actions:[sset('side/width',248),sset('side/padding',24),sset('side/labels',true)]}])];
for(const f of page.children.filter(n=>(/^S\d\d ·|^SW ·/.test(n.name))&&!n.name.includes('Responsive'))){const n=first(f,'toggle-sidebar');if(n)await on(n,toggle);}
await on(first(sp(4),'pdf-narrow'),[sset('pdf/temp',sref('pdf/rightWidth')),conditional([{condition:se('pdf/temp',440),actions:[sset('pdf/rightWidth',320)]},{actions:[sset('pdf/rightWidth',440)]}])]);
return{sidebarToggleFixed:true,pdfNarrowToggleFixed:true};

