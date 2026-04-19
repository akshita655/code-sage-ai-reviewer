export async function handler(event) {
  try {
    const { code, language } = JSON.parse(event.body);

    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${process.env.OPENROUTER_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: process.env.OPENROUTER_MODEL,
        messages: [
          {
            role: "system",
            content:
              "You are an expert code optimizer. Return ONLY improved code. No explanation. No markdown. No text.",
          },
          {
            role: "user",
            content: `Improve this ${language} code. Make it clean, optimized, and production-ready:\n\n${code}`,
          },
        ],
        max_tokens: 1500, // important for longer code
      }),
    });

    const data = await response.json();

    const result =
      data?.choices?.[0]?.message?.content || "No improved code generated.";

    return {
      statusCode: 200,
      body: JSON.stringify({
        result,
      }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: error.message,
      }),
    };
  }
}