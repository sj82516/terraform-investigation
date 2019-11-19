const fetch = require('node-fetch');

async function handler(event, context, callback) {
    const startAt = new Date().getTime();
    await fetch("https://www.president.gov.tw/");
    const duration = new Date().getTime() - startAt;

    const region = process.env.REGION || "local-test";

    const text = `(version 2) api called from ${region}, take ${duration} ms to get page response.`;

    console.log(text);

    if (process.env.SLACK_URL) {
        await fetch(process.env.SLACK_URL, {
            method: "POST",
            body: JSON.stringify({
                text
            }),
            headers: {
                'Content-Type': 'application/json'
            }
        })
    }

    callback();
}

exports.handler = handler;