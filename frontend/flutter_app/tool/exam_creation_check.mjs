import fs from 'node:fs';
import {createRequire} from 'node:module';
const require=createRequire(import.meta.url);
const {chromium}=require('../../react_reference/node_modules/@playwright/test');
const browser=await chromium.launch({channel:'msedge',headless:true});
const errors=[];
fs.mkdirSync('validation/exam-creation',{recursive:true});
const page=await browser.newPage({viewport:{width:1440,height:900},deviceScaleFactor:1});
page.on('pageerror',error=>errors.push(error.message));
await page.goto('http://127.0.0.1:8892/#/teacher/builder');
await page.locator('flutter-view').waitFor({timeout:60000});await page.waitForTimeout(2500);
await page.screenshot({path:'validation/exam-creation/create-desktop.png'});
const enable=page.locator('flt-semantics-placeholder');
if(await enable.count()) await enable.evaluate(e=>e.click());
await page.waitForTimeout(800);
async function clickText(text) {
  const target=page.getByText(text,{exact:false}).or(page.getByLabel(text,{exact:false})).last();

  for(let i=0;i<20;i++) {
    const box=await target.count() ? await target.boundingBox() : null;
    if(box && box.y>=90 && box.y+box.height<=880) break;
    await page.mouse.move(1100,450);await page.mouse.wheel(0,box && box.y<90 ? -500 : 500);await page.waitForTimeout(180);
  }
  await target.click({timeout:15000});await page.waitForTimeout(500);
}
await clickText('Tự soạn Đề thi / Bài tập');
await page.getByRole('textbox').first().fill('Kiểm tra giữa kỳ – Cơ sở dữ liệu');
await page.screenshot({path:'validation/exam-creation/config-desktop.png'});
await clickText('Lưu');
await page.screenshot({path:'validation/exam-creation/success-desktop.png'});
await clickText('Cài đặt làm bài online');
await page.screenshot({path:'validation/exam-creation/settings-desktop.png'});
await clickText('Khi đạt điểm nhất định');
await clickText('80%');
await clickText('Lưu cài đặt');
await page.getByText('Đã lưu cài đặt',{exact:false}).or(page.getByLabel('Đã lưu cài đặt',{exact:false})).last().waitFor();
await page.screenshot({path:'validation/exam-creation/settings-saved-desktop.png'});
await clickText('Quản lý đề đã tạo');
await page.mouse.move(1000,400);await page.mouse.wheel(0,-5000);await page.waitForTimeout(300);
await page.close();
for(const [width,height] of [[1366,768],[1920,1080],[768,1024],[390,844]]) {
  const mobile=await browser.newPage({viewport:{width,height},deviceScaleFactor:1});
  mobile.on('pageerror',error=>errors.push(error.message));
  await mobile.goto('http://127.0.0.1:8892/#/teacher/builder');
  await mobile.locator('flutter-view').waitFor();await mobile.waitForTimeout(1600);
  await mobile.screenshot({path:`validation/exam-creation/create-${width}x${height}.png`});
  await mobile.close();
}
await browser.close();
fs.writeFileSync('validation/exam-creation/browser-results.json',JSON.stringify({errors,journey:'create -> configure -> save -> settings -> save',responsiveScreens:5},null,2));
console.log(JSON.stringify({errors,journey:'passed',responsiveScreens:5}));
if(errors.length) process.exitCode=1;




