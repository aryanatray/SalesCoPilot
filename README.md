# SalesCoPilot – Multi-Agent AI Automation Platform

A complete RAG, SQL Intelligence, Comparison Engine & NDA Analysis system built on n8n, LangChain, Qdrant & Gemini.

## 📌 Overview
SalesCoPilot is a production-grade, multi-agent AI backend designed to serve enterprise sales, marketing, customer success, and legal teams.  
It uses **n8n** as the orchestration layer and integrates:

- Google Gemini 2.5 Pro / Flash
- Qdrant Vector Database
- PostgreSQL structured chat history
- LangChain multi-agent architecture
- Secure REST APIs (n8n webhooks)

The system powers:
- Intelligent Q&A from internal documents  
- SQL-based customer analytics  
- Product & competitor comparisons  
- SWOT + PESTLE analysis  
- NDA contract review & clause-level risk scoring  
- Source document lookup  
- Session-based chat with memory & persistence  

## ⚙️ Key Features

### ✔ SalesCoPilot Main Agent
Handles internal product discovery, RAG answers, meeting prep, contextual responses, and fallback web search.  
Uses Gemini, document vector store, search web, and source information tools.

### ✔ Customer Data RAG SQL Agent
Dynamic SQL generation with schema discovery, table definition lookup, safe read-only SQL execution, and data normalization.

### ✔ Comparison Agent
Creates structured feature and product comparisons, competitive analysis, and auto web-searching when internal data is insufficient.

### ✔ SWOT & PESTLE Agent
Generates executive-level business insights with risk scoring and actionable recommendations.

### ✔ NDA Analyzer
Clause-level analysis of uploaded NDAs, comparison with standard templates, risk scoring, and redline suggestions.

### ✔ Source Lookup Engine
Fetches file metadata and SharePoint URLs from Qdrant vector DB.

### ✔ File Processing Pipeline
Extraction of PDF/TXT files, deduplication, metadata storage, and submission to NDA analysis engine.

## 🗄 Database Schema (PostgreSQL)
Stores sessions, interactions, logs, chat messages, conversation history, and SharePoint sync checkpoints.

## 🔌 API Endpoints

| Endpoint | Method | Purpose |
|---------|--------|---------|
| /query_uat | POST | Main chat API |
| /get_session_id_uat | GET | List sessions |
| /edit_title_uat | PUT | Rename chat |
| /feedback_uat | POST | Store feedback |
| /get_conversation_uat | GET | Full session history |
| /delete_session_uat | DELETE | Delete session |
| /nda_analyzer | POST | Upload NDA |
| /check_file | POST | File duplication check |

## 🚀 How to Run

### 1. Clone Repo
```
git clone https://github.com/your-repo/salescopilot.git
cd salescopilot
```

### 2. Set Environment Variables
```
GEMINI_API_KEY=xxxx
QDRANT_API_KEY=xxxx
POSTGRES_URL=xxxx
N8N_WEBHOOK_SECRET=xxxx
```

### 3. Import n8n Workflow  
Go to n8n → Import JSON → select workflow.

### 4. Start n8n
```
docker-compose up -d
```

### 5. Test API
```
curl -X POST http://localhost:5678/webhook/query_uat
```

## 🧪 NDA Analyzer Demo
Upload:
```
POST /nda_analyzer
file: NDA.pdf
```

Returns risk score, clause diff, source citations, and negotiation actions.

## 🛠 Tech Stack
- n8n
- LangChain
- Google Gemini Models
- Qdrant VectorDB
- PostgreSQL
- Node.js

## 🏁 Conclusion
This project demonstrates a production-ready multi-agent AI system with RAG, SQL intelligence, document analysis, and conversational memory—ideal for enterprise deployment and portfolio use.
