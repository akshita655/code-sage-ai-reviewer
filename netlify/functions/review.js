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
              "You are an expert senior software engineer and code reviewer. Return only valid JSON.",
          },
          {
            role: "user",
            content: `
You are reviewing code written in: ${language}.

Analyze the code according to ${language} best practices.

Return ONLY valid JSON in this format:
{
  "issues": ["issue 1", "issue 2", "issue 3", "issue 4"],
  "suggestions": ["suggestion 1", "suggestion 2", "suggestion 3", "suggestion 4", "suggestion 5"],
  "improvedCode": "full improved code here",
  "score": 85,
  "timeComplexity": "O(n)",
  "spaceComplexity": "O(n)",
  "complexityExplanation": "Short explanation"
}

Rules:
- Return raw JSON only.
- No markdown.
- No backticks.
- No explanation outside JSON.
- improvedCode must contain actual rewritten code, not a description.
- improvedCode must remain in ${language}.
- Do not convert the code into another language.
- If the input language is C, improvedCode must use valid C syntax.
- Keep the code readable.
- Keep issues and suggestions practical and short.
- score must be an integer from 0 to 100.
- timeComplexity and spaceComplexity should be Big-O if possible.

Code:
${code}
`,
          }
        ],
        temperature: 0.2,
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