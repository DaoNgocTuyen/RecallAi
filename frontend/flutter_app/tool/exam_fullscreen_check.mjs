import fs from 'node:fs';
import {createRequire} from 'node:module';
const require=createRequire(import.meta.url);
const {chromium}=require('../../react_reference/node_modules/@playwright/test');
const browser=await chromium.launch({channel:'msedge',headless:true});
const page=await browser.newPage({viewport:{width:1440,height:900},deviceScaleFactor:1});
const errors=[];
page.on('pageerror',error=>errors.push(error.message));
page.on('dialog',dialog=>dialog.dismiss());
fs.mkdirSync('validation/exam-fullscreen',{recursive:true});
async function click(text) {
  const target=page.getByText(text,{exact:false}).or(page.getByLabel(text,{exact:false})).last();
  for(let i=0;i<35;i++) {
    const box=await target.count() ? await target.boundingBox() : null;
    if(box && box.y>70 && box.y+box.height<880) break;
    await page.mouse.move(1100,500);await page.mouse.wheel(0,box && box.y<70 ? -500 : 500);await page.waitForTimeout(140);
  }
  await target.click({timeout:10000});await page.waitForTimeout(350);
}
try {
  await page.goto('http://127.0.0.1:8892/#/student/preview');
  await page.locator('flutter-view').waitFor({timeout:60000});await page.waitForTimeout(1600);
  const accessibility=page.locator('flt-semantics-placeholder');
  if(await accessibility.count()) await accessibility.evaluate(e=>e.click());
  await page.waitForTimeout(300);
  await click('Bắt đầu luyện tập');
  await page.waitForFunction(()=>document.fullscreenElement!==null,{timeout:10000});
  await page.screenshot({path:'validation/exam-fullscreen/started.png'});
  await click('Câu tiếp theo');await click('Câu tiếp theo');
  await page.getByRole('textbox').last().fill('NULL means unknown');
  await page.keyboard.press('Escape');await page.waitForTimeout(200);
  if(await page.evaluate(()=>document.fullscreenElement!==null)) await page.evaluate(()=>document.exitFullscreen());
  await page.waitForFunction(()=>document.fullscreenElement===null);
  await page.waitForTimeout(300);
  if(await page.getByRole('textbox').count()) throw Error('Question input remains visible outside fullscreen');
  await page.screenshot({path:'validation/exam-fullscreen/paused.png'});
  await click('Vào toàn màn hình để làm bài');
  await page.waitForFunction(()=>document.fullscreenElement!==null);
  await page.getByRole('textbox').last().click();
  await page.waitForTimeout(200);
  const answer=await page.getByRole('textbox').last().inputValue();
  if(answer!=='NULL means unknown') throw Error('Answer was lost after leaving fullscreen');
  await page.screenshot({path:'validation/exam-fullscreen/resumed.png'});
  await click('Nộp bài');await click('Quay lại');
  if(!await page.evaluate(()=>document.fullscreenElement!==null)) throw Error('Cancel submission exited fullscreen');
  await click('Nộp bài');await click('Xác nhận nộp bài');
  await page.waitForFunction(()=>document.fullscreenElement===null);
  await page.waitForTimeout(800);
  await page.screenshot({path:'validation/exam-fullscreen/submitted.png'});
  const results={startedFullscreen:true,pausedOutsideFullscreen:true,answerPreserved:true,cancelKeptFullscreen:true,exitedAfterSubmit:true,errors};
  fs.writeFileSync('validation/exam-fullscreen/browser-results.json',JSON.stringify(results,null,2));
  console.log(JSON.stringify(results));
  if(errors.length) process.exitCode=1;
} catch(error) {
  await page.screenshot({path:'validation/exam-fullscreen/failure.png'});
  console.error(error);process.exitCode=1;
} finally { await browser.close(); }

