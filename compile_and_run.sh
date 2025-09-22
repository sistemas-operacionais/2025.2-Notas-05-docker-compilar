#!/bin/bash

echo "=== Comandos para executar dentro do container ==="
echo

echo "Você está agora dentro do container minha_maquina_fedora!"
echo "Diretório atual: $(pwd)"
echo "Arquivos disponíveis:"
ls -la

echo
echo "=== Compilando o programa hello.c ==="
gcc -o hello hello.c

if [ $? -eq 0 ]; then
    echo "✅ Compilação bem-sucedida!"
    echo
    echo "=== Executando o programa hello ==="
    ./hello
else
    echo "❌ Erro na compilação do hello.c"
fi

echo
echo "=== Compilando o programa calculadora.c ==="
gcc -o calculadora calculadora.c -lm

if [ $? -eq 0 ]; then
    echo "✅ Compilação bem-sucedida!"
    echo
    echo "=== Executando a calculadora ==="
    ./calculadora
else
    echo "❌ Erro na compilação da calculadora.c"
fi

echo
echo "=== Informações do sistema ==="
echo "Sistema operacional:"
cat /etc/os-release | grep PRETTY_NAME
echo
echo "Versão do GCC:"
gcc --version | head -n 1
echo
echo "Arquivos executáveis criados:"
ls -la hello calculadora 2>/dev/null || echo "Nenhum executável encontrado"