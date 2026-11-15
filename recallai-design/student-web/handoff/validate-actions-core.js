
const byId=Object.fromEntries(vars.map(v=>[v.id,v]));
function read(d,s){if(d.type==='VARIABLE_ALIAS')return s[d.value.id];if(d.type==='EXPRESSION'){const e=d.value,x=e.expressionArguments.map(d=>read(d,s));switch(e.expressionFunction){case'ADDITION':return x[0]+x[1];case'SUBTRACTION':return x[0]-x[1];case'MULTIPLICATION':return x[0]*x[1];case'DIVISION':return x[0]/x[1];case'EQUALS':return x[0]===x[1];case'NOT_EQUAL':return x[0]!==x[1];case'LESS_THAN':return x[0]<x[1];case'AND':return x.every(Boolean);case'OR':return x.some(Boolean);case'NOT':return!x[0];default:throw new Error(e.expressionFunction);}}return d.value;}
function apply(actions,s){let target=null;for(const x of actions||[]){if(x.type==='SET_VARIABLE')s[x.variableId]=read(x.variableValue,s);else if(x.type==='CONDITIONAL'){for(const b of x.conditionalBlocks)if(!b.condition||read(b.condition,s)){const next=apply(b.actions,s);if(next)target=next;break;}}else if(x.type==='NODE')target=x.destinationId;}return target;}
function fresh(){return Object.fromEntries(vars.map(v=>[v.id,Object.values(v.valuesByMode)[0]]));}
const checks=[];function check(name,pass,details){checks.push({name,pass,details:pass?undefined:details});}
const actionCache=new Map();const firstCache=new Map();const originalFirst=first;first=(f,k)=>{const key=f.id+'/'+k;if(!firstCache.has(key))firstCache.set(key,originalFirst(f,k));return firstCache.get(key);};const screenCache=Array.from({length:14},(_,i)=>sp(i+1));sp=n=>screenCache[n-1];
function click(n,s){if(!n)throw Error('Missing click target');let r=actionCache.get(n.id);if(!r){r=n.reactions?.find(r=>r.trigger?.type==='ON_CLICK');if(r)actionCache.set(n.id,r);}if(!r)throw Error('Missing reaction '+n.name+' '+n.id);return apply(r.actions,s);}

