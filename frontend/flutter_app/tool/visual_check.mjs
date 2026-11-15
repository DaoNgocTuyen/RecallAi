import fs from 'node:fs';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const { chromium } = require('../../react_reference/node_modules/@playwright/test');
const browser = await chromium.launch({ channel: 'msedge', headless: true });
fs.mkdirSync('validation', { recursive: true });
const issues = [];
const selected = process.argv.slice(2);
const screens = [
  ['student-dashboard-desktop', '/student/dashboard', 1440, 900],
  ['login-mobile', '/login', 390, 844],
  ['student-quiz-desktop', '/student/quiz', 1440, 900],
  ['teacher-grading-desktop', '/teacher/grading', 1440, 900],
  ['role-mobile', '/role', 390, 844],
].filter(([name]) => selected.length === 0 || selected.includes(name));
for (const [name, route, width, height] of screens) {
  const page = await browser.newPage({ viewport: { width, height }, deviceScaleFactor: 1 });
  page.on('pageerror', e => issues.push({ name, message: e.message }));
  await page.goto(`http://127.0.0.1:8892/#${route}`);
  await page.locator('flutter-view').waitFor({ timeout: 60000 });
  await page.waitForTimeout(1800);
  await page.screenshot({ path: `validation/${name}.png` });
  await page.close();
}
fs.writeFileSync('validation/browser-issues.json', JSON.stringify(issues, null, 2));
await browser.close();
console.log(JSON.stringify({ screenshots: screens.length, issues }));
if (issues.length) process.exitCode = 1;
