from fastapi import FastAPI, HTTPException, Depends
from fastapi.responses import FileResponse
from pydantic import BaseModel
from typing import List
import asyncpg
import os
from datetime import datetime

app = FastAPI()

# --- Pydanticモデル定義 ---
class QueryLog(BaseModel):
    executed_at: datetime
    query_sql: str

class QueryPattern(BaseModel):
    pattern_sql: str

# --- データベース接続 ---
async def get_db_connection():
    conn = await asyncpg.connect(
        user=os.getenv("POSTGRES_USER", "user"),
        password=os.getenv("POSTGRES_PASSWORD", "password"),
        database=os.getenv("POSTGRES_DB", "mydb"),
        host=os.getenv("DB_HOST", "db") # Docker Compose内のサービス名
    )
    try:
        yield conn
    finally:
        await conn.close()

# --- APIエンドポイント ---

@app.get("/")
async def read_index():
    return FileResponse('createsql.html')

@app.post("/api/save_queries/")
async def save_queries(logs: List[QueryLog], patterns: List[QueryPattern], conn: asyncpg.Connection = Depends(get_db_connection)):
    try:
        # query_logsへの一括挿入
        if logs:
            await conn.executemany(
                "INSERT INTO query_logs (executed_at, query_sql) VALUES ($1, $2)",
                [(log.executed_at, log.query_sql) for log in logs]
            )

        # query_patternsへのUPSERT処理
        if patterns:
            for pattern in patterns:
                await conn.execute(
                    """
                    INSERT INTO query_patterns (pattern_sql, occurrence_count, last_seen)
                    VALUES ($1, 1, NOW())
                    ON CONFLICT (pattern_sql) DO UPDATE
                    SET occurrence_count = query_patterns.occurrence_count + 1,
                        last_seen = NOW();
                    """,
                    pattern.pattern_sql
                )

        return {"status": "success", "saved_logs": len(logs), "saved_patterns": len(patterns)}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/health")
def health_check():
    return {"status": "ok"}
