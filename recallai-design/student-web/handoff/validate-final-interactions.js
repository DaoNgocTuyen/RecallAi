
const get=(s,n)=>s[S[n].id];const family=page.findOne(n=>n.type==='COMPONENT_SET'&&n.name==='Student Web / Flashcard'),back=family.children.find(n=>n.name==='Mặt=Sau');
{const s=fresh();click(first(sp(8),'save-explanation'),s);check('saving explanation freezes a review task',get(s,'review/saved')===true&&get(s,'review/savedFront')===get(s,'quiz/question'));click(first(sp(11),'study-saved-question'),s);click(first(back,'rate-Tốt'),s);check('saved question rating updates shared review schedule',get(s,'review/savedStatus')==='Đã ôn · Tốt'&&s[M().review.id]==='23 thẻ');}
{const s=fresh(),m=page.children.find(n=>n.name==='SW Modal · Delete deck 0');click(first(m,'confirm-deck-delete'),s);const count=get(s,'deck/count');click(first(m,'confirm-deck-delete'),s);check('deck deletion updates count once',count===11&&get(s,'deck/count')===11&&get(s,'deck/countText')==='11');}
{const s=fresh();click(first(sp(1),'toggle-sidebar'),s);check('sidebar collapses with labels hidden',get(s,'side/width')===80&&get(s,'side/labels')===false);click(first(sp(1),'toggle-sidebar'),s);check('sidebar expands again',get(s,'side/width')===248&&get(s,'side/labels')===true);}
{const f=page.children.find(n=>n.name.includes('[source:130:13462]')),n=first(f,'start-shared-quiz');for(const [field,val,part]of [['mobile/eligible',false,'chưa thuộc lớp'],['assign/pubOpen',false,'chưa mở'],['mobile/remaining',0,'hết số lượt']]){const s=fresh();s[W['mobile/eligible'].id]=true;s[W['assign/pubOpen'].id]=true;s[W['mobile/remaining'].id]=2;s[W[field].id]=val;click(n,s);check('access message reflects '+field,s[W['mobile/blockedReason'].id].includes(part));}}
const subtitle=sf(sp(9)).children.find(n=>n.type==='TEXT'&&n.characters.startsWith('Ba bộ đại diện'));if(subtitle)subtitle.characters='Các bộ thẻ tiêu biểu trong thư viện của bạn.';

{const s=fresh();click(first(sp(4),'pdf-narrow'),s);check('PDF assistant narrows once per click',get(s,'pdf/rightWidth')===320);click(first(sp(4),'pdf-narrow'),s);check('PDF assistant expands again',get(s,'pdf/rightWidth')===440);}
return{checks:checks.length,passed:checks.filter(c=>c.pass).length,failures:checks.filter(c=>!c.pass)};

