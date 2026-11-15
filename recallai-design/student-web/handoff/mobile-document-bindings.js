
const toolbar=sp(4).findOne(n=>n.name==='Điều khiển học liệu');toolbar.itemSpacing=8;toolbar.setBoundVariable('itemSpacing',T['space/8']);toolbar.children.find(n=>n.type==='TEXT').resize(340,24);
const notes=first(sp(4),'study-note'),field=notes.findOne(n=>n.name==='Ô nhập'),valueText=notes.findOne(n=>n.name==='Field value');valueText.layoutSizingHorizontal='FILL';valueText.maxLines=5;valueText.textTruncation='ENDING';field.resize(field.width,144);
const files=['Cơ sở dữ liệu.pdf','Lập trình C#.pdf','Nhập môn trí tuệ nhân tạo.pdf'];let count=0;for(const f of page.children.filter(n=>/^\d\d ·/.test(n.name)))for(const t of f.findAllWithCriteria({types:['TEXT']})){const i=files.indexOf(t.characters);if(i>=0){bind(t,S['doc/name'+i]);count++;}}
return{mobileFilenameBindings:count,pdfToolbarFits:true};

