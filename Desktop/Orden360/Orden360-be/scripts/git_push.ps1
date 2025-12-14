<#
  Script para inicializar repo local, commitear y pushear al remoto indicado.
  Úsalo desde la raíz del proyecto (PowerShell):
    .\scripts\git_push.ps1 -RemoteUrl 'https://github.com/NicoFox01/Orden360-be.git' -CommitMessage 'Initial FastAPI (Vercel) scaffold'

  Nota: este script requiere que `git` esté instalado y configurado en tu máquina.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$RemoteUrl,

    [string]$CommitMessage = 'Initial FastAPI (Vercel) scaffold'
)

Set-PSDebug -Strict

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git no está disponible en este sistema. Instala git (https://git-scm.com/) y vuelve a ejecutar el script."
    exit 1
}

Write-Host "Inicializando repositorio si hace falta..."
if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
    git init
    Write-Host "Repositorio inicializado localmente."
} else {
    Write-Host "Ya existe un repositorio git en esta carpeta."
}

Write-Host "Comprobando remote 'origin'..."
$existing = (git remote get-url origin 2>$null) -ne $null
if ($existing) {
    Write-Host "Remote 'origin' ya existe: $(git remote get-url origin)"
    Write-Host "Si quieres reemplazarlo ejecuta: git remote set-url origin $RemoteUrl"
} else {
    git remote add origin $RemoteUrl
    Write-Host "Remote 'origin' añadido: $RemoteUrl"
}

Write-Host "Agregando archivos y realizando commit..."
git add -A
if (-not (git diff --cached --quiet)) {
    git commit -m "$CommitMessage"
} else {
    Write-Host "No hay cambios para commitear."
}

Write-Host "Ajustando branch principal a 'main' y empujando al remoto..."
git branch -M main

try {
    git push -u origin main
    Write-Host "Push realizado correctamente."
} catch {
    Write-Error "Falló el push. Probablemente necesites autenticarte. Intenta ejecutar 'git push -u origin main' manualmente y sigue las indicaciones o configura GitHub CLI (gh auth login) o un Personal Access Token (PAT)."
    exit 1
}

Write-Host "¡Listo! El repositorio debería estar en $RemoteUrl (comprueba en GitHub)."
