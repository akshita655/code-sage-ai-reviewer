exports.handler = async function (event) {
  try {
    if (event.httpMethod !== "POST") {
      return {
        statusCode: 405,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          error: "Method not allowed",
        }),
      };
    }

    const body = JSON.parse(event.body || "{}");
    const code = body.code;
    const language = body.language || "code";

    if (!code || code.trim() === "") {
      return {
        statusCode: 400,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          error: "Code is required",
        }),
      };
    }

    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${process.env.OPENROUTER_API_KEY}`,
        "Content-Type": "application/json",
        "HTTP-Referer": "https://codesage-ai.netlify.app",
        "X-Title": "CodeSage AI"
      },
      body: JSON.stringify({
        model: process.env.OPENROUTER_MODEL || "deepseek/deepseek-r1-0528:free",
        messages: [
          {
            role: "system",
            content:
              "You are a helpful programming teacher. Explain code clearly and simply.",
          },
          {
            role: "user",
            content: `
The following code is written in ${language}.

Explain this code in simple language for a student developer.

Rules:
- Keep the explanation easy to understand.
- Explain what the code does.
- Mention the main logic.
- Mention important functions, loops, or conditions.
- Keep it concise but useful.
- Return plain text only.

Code:
${code}
`,
          }
        ],
        temperature: 0.4,
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      return {
        statusCode: response.status,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          error: "OpenRouter request failed",
          details: data,
        }),
      };
    }

    const content = data?.choices?.[0]?.message?.content ?? "";

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        result: content,
      }),
    };
  } catch (e) {
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        error: "Internal server error",
        details: e.toString(),
      }),
    };
  }
};