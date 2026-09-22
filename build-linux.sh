#!/usr/bin/env bash

read -p "Digite o caminho absoluto da pasta do projeto: " PROJECT_PATH

# Remove aspas se houver
PROJECT_PATH=$(echo "$PROJECT_PATH" | tr -d "'\"")

if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "\033[0;31mErro: O caminho especificado não existe!\033[0m"
    exit 1
fi

cd "$PROJECT_PATH" || exit
echo -e "\n\033[0;36mEntrando na pasta: $PROJECT_PATH\033[0m"

# 1. Verifica/Gera package.json
if [ ! -f "package.json" ]; then
    echo -e "\033[0;33mIniciando package.json...\033[0m"
    npm init -y > /dev/null
fi

# 2. Identifica se é TypeScript
IS_TS=false
if [ -f "tsconfig.json" ] || [ -n "$(find . -maxdepth 2 -name '*.ts' -print -quit 2>/dev/null)" ]; then
    IS_TS=true
fi

if [ "$IS_TS" = true ]; then
    echo -e "\033[0;33mProjeto TypeScript detectado. Instalando dependências de build...\033[0m"
    npm install --save-dev typescript pkg
else
    echo -e "\033[0;33mInstalando pkg...\033[0m"
    npm install --save-dev pkg
fi

# 3. Executa build ou compila TS
if grep -q '"build":' package.json; then
    echo -e "\033[0;33mExecutando npm run build...\033[0m"
    npm run build
elif [ "$IS_TS" = true ]; then
    echo -e "\033[0;33mCompilando TypeScript (npx tsc)...\033[0m"
    npx tsc
fi

# 4. Ponto de entrada
ENTRY_POINT=""
if [ -f "dist/index.js" ]; then
    ENTRY_POINT="dist/index.js"
elif [ -f "dist/app.js" ]; then
    ENTRY_POINT="dist/app.js"
elif [ -f "index.js" ]; then
    ENTRY_POINT="index.js"
else
    read -p "Não foi possível detectar o arquivo .js principal. Digite o caminho (ex: dist/index.js): " ENTRY_POINT
fi

# 5. Gerar executável para Linux
mkdir -p bin
echo -e "\033[0;32mGerando executável para Linux...\033[0m"
npx pkg "$ENTRY_POINT" --targets node18-linux-x64 --output "bin/app-linux"

if [ -f "bin/app-linux" ]; then
    echo -e "\n\033[0;32mExecutável gerado com sucesso em: $PROJECT_PATH/bin/app-linux\033[0m"
else
    echo -e "\n\033[0;31mFalha ao gerar o executável.\033[0m"
fi
