"""Vercel function entrypoint - exposes the ASGI app to Vercel.

Vercel detects ASGI apps by finding an `app` variable in the function file or files
reachable at build time. We import the application instance from `app.main` so
Vercel will serve it from the project root (and we can route root to it).
"""
from app.main import app  # exported ASGI app for Vercel

__all__ = ["app"]
