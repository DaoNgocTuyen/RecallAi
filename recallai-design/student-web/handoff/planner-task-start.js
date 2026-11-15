
const detail=portMap['79:8134'],a=C();const starts=[];for(let i=0;i<42;i++)starts.push({condition:eq(a['task/current'],i),actions:[{type:'CLOSE'},proto(i%3===2?sp(11):sp(5))]});await on(first(detail,'task-start'),conditional(starts));
return{plannerTaskStartRoutes:{knowledge:sp(5).id,practice:sp(5).id,flashcards:sp(11).id}};

