#!/bin/bash

echo "=== Tutorial Docker - Compilar e Executar Programas C ==="
echo

# Passo 1: Construir a imagem Docker
echo "Passo 1: Construindo a imagem Docker 'minha_imagem_fedora'..."
docker build -t minha_imagem_fedora .

if [ $? -eq 0 ]; then
    echo "✅ Imagem construída com sucesso!"
else
    echo "❌ Erro ao construir a imagem"
    exit 1
fi

echo
echo "Passo 2: Criando e executando o container 'minha_maquina_fedora'..."
echo "O container será executado em modo interativo com o diretório atual mapeado para /app"
echo

# Passo 2: Executar o container em modo interativo
docker run -it --name minha_maquina_fedora -v "$(pwd)":/app minha_imagem_fedora /bin/bash