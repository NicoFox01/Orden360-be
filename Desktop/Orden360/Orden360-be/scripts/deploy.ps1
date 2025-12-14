#!/usr/bin/env pwsh
# Despliega la app en Vercel usando la CLI.
# Pre-requisitos: instalar la CLI de Vercel (npm i -g vercel)

Write-Host "Iniciando despliegue a Vercel..."
vercel login
vercel --prod
