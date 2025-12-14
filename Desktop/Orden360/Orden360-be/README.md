# Orden360 FastAPI (Vercel)

Proyecto minimal para desplegar una API FastAPI en Vercel.

Características:
- FastAPI app en `app/main.py` (expuesta desde `api/index.py`)
- `vercel.json` para enrutar `/` al serverless function
- Tests con `pytest` + `httpx`

Cómo ejecutar localmente:

```powershell
# instalar dependencias
python -m pip install -r requirements.txt

# correr localmente con uvicorn
uvicorn app.main:app --reload

# correr tests
pytest -q
```

Despliegue a Vercel:

1. Inicializa el proyecto git y empuja a GitHub
2. Conéctalo en Vercel y despliega — Vercel detectará `vercel.json` y `requirements.txt`

O usando la CLI de Vercel (local):

```powershell
# instalar la CLI (si no está instalada)
npm i -g vercel

# iniciar sesión y desplegar
.
scripts\deploy.ps1
```

Nota: si quieres despliegues automáticos desde GitHub, conéctalo desde el dashboard de Vercel al repo y Vercel hará deploy en cada push al branch configurado.
