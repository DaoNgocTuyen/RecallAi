import fs from 'node:fs';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const { chromium } = require('../../react_reference/node_modules/@playwright/test');
const browser = await chromium.launch({channel:'msedge',headless:true});
const results=[];
fs.mkdirSync('validation/auth-responsive',{recursive:true});
for(const [width,height] of [[1366,768],[1440,900],[1920,1080],[768,1024],[390,844]]) {
  for(const route of ['login','role']) {
    const issues=[];
    const page=await browser.newPage({viewport:{width,height},deviceScaleFactor:1});
    page.on('pageerror',error=>issues.push(error.message));
    await page.goto(`http://127.0.0.1:8892/#/${route}`);
    await page.locator('flutter-view').waitFor({timeout:60000});
    await page.waitForTimeout(1800);
    const metrics=await page.evaluate(()=>({width:innerWidth,height:innerHeight,scrollWidth:document.documentElement.scrollWidth,scrollHeight:document.documentElement.scrollHeight}));
    await page.screenshot({path:`validation/auth-responsive/${route}-${width}x${height}.png`});
    await page.mouse.move(width/2,height/2);
    await page.mouse.wheel(0,1500);
    await page.waitForTimeout(300);
    await page.screenshot({path:`validation/auth-responsive/${route}-${width}x${height}-bottom.png`});
    results.push({route,width,height,issues,metrics});
    await page.close();
  }
}
await browser.close();
fs.writeFileSync('validation/auth-responsive/browser-results.json',JSON.stringify(results,null,2));
console.log(JSON.stringify({screens:results.length,errors:results.flatMap(x=>x.issues)}));
if(results.some(x=>x.issues.length)) process.exitCode=1;
