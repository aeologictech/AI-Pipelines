import openai
from command_runner import run_command

openai.api_key = "your-openai-api-key"

def ask_gpt(prompt: str) -> str:
    if prompt.lower().startswith("run") or prompt.lower().startswith("open"):
        return run_command(prompt)
    
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are Jarvis, a helpful assistant."},
            {"role": "user", "content": prompt}
        ]
    )
    return response['choices'][0]['message']['content']
