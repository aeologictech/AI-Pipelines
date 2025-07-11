from fastapi import FastAPI, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain.chains import RetrievalQA
from langchain.chat_models import ChatOpenAI
import os
import tempfile

# Load API Key
load_dotenv()
#OPENAI_API_KEY = os.getenv("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")

app = FastAPI()

# CORS for Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/ask")
async def ask_document(file: UploadFile, question: str = Form(...)):
# Save uploaded PDF to temp file
  temp = tempfile.NamedTemporaryFile(delete=False, suffix=".pdf")
  temp.write(await file.read())
  temp.flush()

  # Load and split
  loader = PyPDFLoader(temp.name)
  pages = loader.load()
  splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
  docs = splitter.split_documents(pages)

  # Embeddings and Vector Store
  embeddings = OpenAIEmbeddings(openai_api_key=OPENAI_API_KEY)
  db = FAISS.from_documents(docs, embeddings)

  # QA chain
  qa = RetrievalQA.from_chain_type(
    llm=ChatOpenAI(openai_api_key=OPENAI_API_KEY, model_name="gpt-3.5-turbo"),
    retriever=db.as_retriever(),
    return_source_documents=True
  )

  result = qa.run(question)
  return {"answer": result}

