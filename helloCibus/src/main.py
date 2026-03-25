from fastapi import FastAPI
from fastapi.responses import PlainTextResponse, JSONResponse

app = FastAPI(title="helloCibus", version="1.0.0")


@app.get("/", response_class=PlainTextResponse)
def root() -> str:
    return "Hello, I'm Cibus service"


@app.get("/health", response_class=JSONResponse)
def health() -> dict:
    return {"status": "ok", "service": "helloCibus"}
