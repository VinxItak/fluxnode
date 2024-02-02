const puppeteer = require('puppeteer');
const url = process.argv[2];

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto(url);

  // Wait for the page to finish loading and execute the JavaScript
  await page.waitForSelector('body');

  // Retrieve page content
  const bodyContent = await page.evaluate(() => {
    return document.querySelector('body').innerText;
  });

  console.log(bodyContent);

  await browser.close();
})();

