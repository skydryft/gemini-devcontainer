---
name: gemini-api
description: >
  Activate this skill when you need to make Gemini API calls from application
  code — REST (curl), Python SDK, or Node.js SDK. Contains verified syntax,
  correct model names, and common mistakes to avoid.
---

# Gemini API Reference

Use these exact patterns. Do not improvise alternatives.

## Model Names (current)

| Model | ID |
|-------|----|
| Gemini 2.0 Flash | `gemini-2.0-flash` |
| Gemini 2.0 Pro | `gemini-2.0-pro` |
| Gemini 1.5 Flash | `gemini-1.5-flash` |
| Gemini 1.5 Pro | `gemini-1.5-pro` |

Always include the version number. `gemini-pro` and `gemini-flash` alone are wrong.

## REST API (curl)

Base URL: `https://generativelanguage.googleapis.com/v1beta`

### Generate content

```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [{"text": "Your prompt here"}]
    }]
  }'
```

### Streaming

```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:streamGenerateContent?alt=sse&key=${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [{"text": "Your prompt here"}]
    }]
  }'
```

### With system instruction

```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "system_instruction": {
      "parts": [{"text": "You are a helpful assistant."}]
    },
    "contents": [{
      "parts": [{"text": "Your prompt here"}]
    }]
  }'
```

### REST common mistakes

- WRONG: `/v1/models/...` — use `/v1beta/models/...`
- WRONG: `"message"` or `"prompt"` field — use `"contents"` > `"parts"` > `"text"`
- WRONG: `Authorization: Bearer` header with API key — use `?key=` query param
- WRONG: `"model"` in the request body — model goes in the URL path
- WRONG: `"role": "user"` at top level — role goes inside each content object

## Python SDK

```bash
pip install google-genai
```

```python
from google import genai

client = genai.Client(api_key="YOUR_API_KEY")
response = client.models.generate_content(
    model="gemini-2.0-flash",
    contents="Your prompt here",
)
print(response.text)
```

### With system instruction (Python)

```python
from google.genai import types

response = client.models.generate_content(
    model="gemini-2.0-flash",
    contents="Your prompt here",
    config=types.GenerateContentConfig(
        system_instruction="You are a helpful assistant.",
    ),
)
```

### Python common mistakes

- WRONG: `import google.generativeai as genai` — old SDK, do not use
- WRONG: `genai.configure(api_key=...)` — old SDK pattern
- WRONG: `model = genai.GenerativeModel(...)` — old SDK pattern
- RIGHT: `from google import genai` then `client = genai.Client(...)`
- The package is `google-genai`, NOT `google-generativeai`

## Node.js SDK

```bash
npm install @google/genai
```

```javascript
import { GoogleGenAI } from "@google/genai";

const ai = new GoogleGenAI({ apiKey: "YOUR_API_KEY" });

const response = await ai.models.generateContent({
  model: "gemini-2.0-flash",
  contents: "Your prompt here",
});
console.log(response.text);
```

### Node.js common mistakes

- WRONG: `@google/generative-ai` — old package name
- WRONG: `const model = genAI.getGenerativeModel(...)` — old SDK pattern
- RIGHT: `@google/genai` with `ai.models.generateContent(...)`

## Authentication

- **API Key (REST):** pass as `?key=` query parameter
- **API Key (SDK):** pass in client constructor
- **Environment variable:** `GEMINI_API_KEY` (conventional name, not auto-detected)
- **Vertex AI (GCP):** completely different auth — uses service accounts, not API keys
