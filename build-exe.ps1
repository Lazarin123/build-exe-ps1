# Promptea o usuário pelo caminho da pasta
$projectPath = Read-Host "Digite o caminho absoluto da pasta do projeto"

# Remove aspas se o usuário arrastou a pasta para o terminal
$projectPath = $projectPath.Trim('"').Trim("'")

if (-not (Test-Path -Path $projectPath)) {
    Write-Host "Erro: O caminho especificado nao existe!" -ForegroundColor Red
    exit
}

Set-Location -Path $projectPath
Write-Host "`nEntrando na pasta: $projectPath" -ForegroundColor Cyan

# 1. Verifica/Gera package.json
if (-not (Test-Path -Path "package.json")) {
    Write-Host "Iniciando package.json..." -ForegroundColor Yellow
    npm init -y | Out-Null
}

# 2. Instala TypeScript se houver arquivos .ts e tsconfig
$isTypescript = (Test-Path "tsconfig.json") -or (Get-ChildItem -Filter "*.ts" -Recurse -Depth 2 | Select-Object -First 1)

if ($isTypescript) {
    Write-Host "Projeto TypeScript detectado. Instalando dependencias de build..." -ForegroundColor Yellow
    npm install --save-dev typescript pkg
} else {
    Write-Host "Instalando pkg..." -ForegroundColor Yellow
    npm install --save-dev pkg
}

# 3. Executa build se houver script de build no package.json ou compila TS
$pkgJson = Get-Content "package.json" -Raw | ConvertFrom-Json

if ($pkgJson.scripts.build) {     Write-Host "Executando npm run build..." -ForegroundColor Yellow     npm run build } elseif ($isTypescript) {
    Write-Host "Compilando TypeScript (npx tsc)..." -ForegroundColor Yellow
    npx tsc
}

# 4. Identifica o ponto de entrada principal
$entryPoint =$null

if ($pkgJson.main -and (Test-Path$pkgJson.main)) {
    $entryPoint =$pkgJson.main
} elseif (Test-Path "dist/index.js") {
    $entryPoint = "dist/index.js"
} elseif (Test-Path "dist/app.js") {
    $entryPoint = "dist/app.js"
} elseif (Test-Path "index.js") {
    $entryPoint = "index.js"
} else {
    $entryPoint = Read-Host "Nao foi possivel detectar o arquivo .js principal. Digite o caminho dele (ex: dist/index.js)"
}

# 5. Gera o executavel
Write-Host "Gerando executavel a partir de $entryPoint..." -ForegroundColor Green
npx pkg $entryPoint --targets node18-win-x64 --output "bin/app.exe"

if (Test-Path "bin/app.exe") {
    Write-Host "`nExecutavel gerado com sucesso em: $projectPath\bin\app.exe" -ForegroundColor Green
} else {
    Write-Host "`nFalha ao gerar o executavel. Verifique os erros acima." -ForegroundColor Red
}
