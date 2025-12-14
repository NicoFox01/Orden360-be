from fastapi import FastAPI

app = FastAPI(title="Orden360 API (Vercel)")


@app.get("/", tags=["root"])
async def read_root():
    return {"message": "Hola desde FastAPI en Vercel!"}


@app.get("/health", tags=["health"])
async def health_check():
    return {"status": "ok"}
