
wv('mobile/blockedReason','STRING','Tài khoản mẫu chưa thuộc lớp nhận bài.');
const reasons=conditional([{condition:eqw('mobile/eligible',false),actions:[set(W['mobile/blockedReason'],'Tài khoản mẫu chưa thuộc lớp nhận bài. Hãy tham gia lớp bằng mã giáo viên cung cấp.')]},{condition:eqw('assign/pubOpen',false),actions:[set(W['mobile/blockedReason'],'Bài kiểm tra chưa mở hoặc đã hết hạn. Kiểm tra thời gian bắt đầu và hạn nộp trong hướng dẫn.')]},{actions:[set(W['mobile/blockedReason'],'Bạn đã dùng hết số lượt làm bài. Bạn vẫn có thể xem kết quả mà giáo viên cho phép từ lớp học.')]}]);
function patch(actions,denied){return actions.flatMap(a=>a.type==='CONDITIONAL'?[{...a,conditionalBlocks:a.conditionalBlocks.map(b=>({...b,actions:patch(b.actions,denied)}))}]:a.type==='NODE'&&a.destinationId===denied?[reasons,a]:[a]);}
const pairs=[[await figma.getNodeByIdAsync('130:13462'),await figma.getNodeByIdAsync('130:13509')],[portMap['130:13462'],portMap['130:13509']]];
for(const [start,denied]of pairs){const n=first(start,'start-shared-quiz');await on(n,patch(n.reactions[0].actions,denied.id));const body=denied.findOne(n=>n.name==='Feed / Auto Layout')||sf(denied),t=body.findOne(n=>n.type==='TEXT'&&n.characters.startsWith('Tài khoản'));bind(t,W['mobile/blockedReason']);}
const f=sp(14),entry=f.reactions.find(r=>r.trigger?.type==='AFTER_TIMEOUT');await on(f,[...entry.actions,...[0,1,2,3].map(n=>conditional([{condition:eqw('mobile/remaining',n),actions:[set(W['mobile/remainingText'],n+' lượt còn lại')]}]))],entry.trigger);
return{blockedReasonClarified:true};

