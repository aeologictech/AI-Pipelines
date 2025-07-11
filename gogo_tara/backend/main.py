from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from llm_engine import ask_gpt
from tts import speak_text
import uvicorn

app = FastAPI()

app.add_middleware(
  CORSMiddleware,
  allow_origins=["*"],
  allow_credentials=True,
  allow_methods=["*"],
  allow_headers=["*"],
)

class Query(BaseModel):
  message: str

@app.post("/ask")
def ask(query: Query):
  response = ask_gpt(query.message)
  speak_text(response)
  return {"response": response}

if __name__ == "__main__":
  uvicorn.run(app, host="0.0.0.0", port=8000)



