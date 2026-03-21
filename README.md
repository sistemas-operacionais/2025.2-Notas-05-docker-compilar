# 2025.2-Notas-05-docker-compilar
Notas de aula sobre como compilar e executar programas em um conteiner docker

## Tutorial Docker: Compilando e Executando Programas C

Este tutorial demonstra como criar uma imagem Docker baseada no Fedora Linux para compilar e executar programas em C, com compartilhamento de arquivos entre a máquina hospedeira e o container.

## Sumário

- [Arquivos do Tutorial](#arquivos-do-tutorial)
- [Pré-requisitos](#pré-requisitos)
- [Tutorial Passo a Passo](#tutorial-passo-a-passo)
  - [Nos labs do IFRN-CNAT](#nos-labs-do-ifrn-cnat)
  - [1. Criar a Imagem Docker](#1-criar-a-imagem-docker)
  - [2. Criar e Executar o Container](#2-criar-e-executar-o-container)
  - [3. Compilar e Executar o Programa C](#3-compilar-e-executar-o-programa-c)
  - [4. Exemplo de Uso Automatizado usando shellscript](#4-exemplo-de-uso-automatizado-usando-shellscript)
- [Comandos Docker Úteis](#comandos-docker-úteis)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Como Funciona o Compartilhamento](#como-funciona-o-compartilhamento)
- [Exemplo de Saída Esperada](#exemplo-de-saída-esperada)
- [Solução de Problemas](#solução-de-problemas)
- [Programas de Exemplo Incluídos](#programas-de-exemplo-incluídos)

## Arquivos do Tutorial

- [`Dockerfile`](https://github.com/sistemas-operacionais/2025.2-Notas-05-docker-compilar/blob/main/Dockerfile) - Arquivo de configuração da imagem Docker
- [`hello.c`](https://github.com/sistemas-operacionais/2025.2-Notas-05-docker-compilar/blob/main/hello.c) - Programa C de exemplo
- [`run_docker_tutorial.sh`](https://github.com/sistemas-operacionais/2025.2-Notas-05-docker-compilar/blob/main/run_docker_tutorial.sh) - Script automático para executar o tutorial
- [`compile_and_run.sh`](https://github.com/sistemas-operacionais/2025.2-Notas-05-docker-compilar/blob/main/compile_and_run.sh) - Script para compilar e executar dentro do container

## Pré-requisitos

- Docker instalado e em execução
- Permissões para executar comandos Docker

## Tutorial Passo a Passo

### Nos labs do IFRN-CNAT

1. Iniciar o windows
2. Executar o Docker desktop

### 1. Criar a Imagem Docker

1. Criar uma pasta para este tutorial `tutorial-docker-dir-compartilhado`
2. Criar um arquivo `Dockerfile` na pasta `tutorial-docker-dir-compartilhado`
3. Construir uma imagem nova para este tutorial com o nome `meu_fedora_dir_compartilhado`

A primeira etapa é criar a pasta (`tutorial-docker-dir-compartilhado`) e arquivo (`tutorial-docker-dir-compartilhado/Dockerfile`).

```Dockerfile
FROM fedora:latest

# Criar o diretório /app que será compartilhado
RUN mkdir -p /app
# Definir /app como diretório de trabalho
WORKDIR /app

# Atualizar o sistema e instalar ferramentas de desenvolvimento
RUN dnf update -y && \
    dnf install -y gcc glibc-devel make fish && \
    dnf clean all

# Comando padrão para manter o container ativo
CMD ["/bin/fish"]
```

- `RUN` executa comando (software) na imagem a ser construída
  - `&&` permite executar vários comandos em um mesmo `RUN`
  - `\` faz quebra de linha
  - `WORKDIR` especifica qual a pasta a ser aberta ao executar o container
  - `CMD` é o comando a ser executado após o container ser iniciado

A segunda etapa é criar uma imagem Docker baseada no Fedora:latest com as ferramentas de desenvolvimento necessárias.
Lembrar de acessar a pasta deste tutorial `tutorial-docker-dir-compartilhado` no terminal.

```bash
# Construir a imagem com o nome 'minha_imagem_fedora'
docker build -t meu_fedora_dir_compartilhado .
```

O Dockerfile contém:
- Base: `fedora:latest`
- Instalação de ferramentas de desenvolvimento (gcc, make)
- Criação do diretório `/app` compartilhado
- Configuração do diretório de trabalho

### 2. Criar e Executar o Container

Criar um container chamado 'minha_maquina_fedora' com compartilhamento de diretório:

```bash
# Executar o container em modo interativo
# O diretório atual será mapeado para /app dentro do container
docker run -it --name minha_maquina_fedora -v "$(pwd):/app" meu_fedora_dir_compartilhado /bin/fish
```

Parâmetros utilizados:
- `-it`: Modo interativo com terminal
- `--name minha_maquina_fedora`: Nome do container
- `-v "$(pwd)":/app`: Mapeia o diretório atual para /app no container
- `/bin/fish`: Executa o shell bash turbinado

### 3. Compilar e Executar o Programa C

1. Criar o arquivo `tutorial-docker-dir-compartilhado/hello.c`
2. Acessar o terminal com o container deste tutorial e executar os comandos abaixo


```c
#include <stdio.h>

int main() {
    printf("Olá! Este programa foi compilado e executado dentro do container Docker!\n");
    printf("Sistema: Fedora Linux\n");
    printf("Container: minha_maquina_fedora\n");
    return 0;
}
```

Dentro do container, execute os seguintes comandos:

```bash
# Verificar se você está no diretório /app
pwd

# Listar arquivos disponíveis
ls -la

# Compilar o programa hello.c
gcc -o hello hello.c

# Executar o programa compilado
./hello
```

Agora você pode tentar criar o arquivo `calculadora.c`, conforme código abaixo e compilar e executar no container.

```c
#include <stdio.h>
#include <math.h>

int main() {
    printf("=== Programa C Avançado - Calculadora ===\n");
    
    double a = 10.5, b = 3.2;
    
    printf("Número A: %.2f\n", a);
    printf("Número B: %.2f\n", b);
    printf("Soma: %.2f\n", a + b);
    printf("Subtração: %.2f\n", a - b);
    printf("Multiplicação: %.2f\n", a * b);
    printf("Divisão: %.2f\n", a / b);
    printf("Raiz quadrada de A: %.2f\n", sqrt(a));
    
    printf("\n=== Compilado e executado no container Docker! ===\n");
    return 0;
}
```

Por fim, para este tutorial, experimente modificar os arquivos, compilar e executar novamente.
Os arquivos são os mesmos para a máquina hospedeira e para o container.
Isso permite em ambiente de desenvolvimento ter modificações e testes no container antes de empacotá-los numa imagem para publicar o aplicativo.

### 4. Exemplo de Uso Automatizado usando shellscript

1. Criar o arquivo `tutorial-docker-dir-compartilhado/run_docker_tutorial.sh`
2. Criar o arquivo `tutorial-docker-dir-compartilhado/compile_and_run.sh`
3. Acessar o terminal do windows

`tutorial-docker-dir-compartilhado/run_docker_tutorial.sh`
```sh
#!/bin/bash

echo "=== Tutorial Docker - Compilar e Executar Programas C ==="
echo

# Passo 1: Construir a imagem Docker
echo "Passo 1: Construindo a imagem Docker 'meu_fedora_dir_compartilhado'..."
docker build -t meu_fedora_dir_compartilhado .

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
docker run -it --name minha_maquina_fedora -v "$(pwd)":/app meu_fedora_dir_compartilhado /bin/bash
```

`tutorial-docker-dir-compartilhado/compile_and_run.sh`
```sh
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
```

Para facilitar o uso, execute o script automático no terminal do windows:

```bash
# Na máquina hospedeira
./run_docker_tutorial.sh
```

Dentro do container, você pode usar o script de compilação:

```bash
# Dentro do container
./compile_and_run.sh
```

## Comandos Docker Úteis

### Gerenciar Containers

```bash
# Listar containers em execução
docker ps

# Listar todos os containers
docker ps -a

# Parar o container
docker stop minha_maquina_fedora

# Remover o container
docker rm minha_maquina_fedora

# Reconectar ao container (se ainda estiver em execução)
docker exec -it minha_maquina_fedora /bin/bash
```

### Gerenciar Imagens

```bash
# Listar imagens
docker images

# Remover a imagem
docker rmi meu_fedora_dir_compartilhado
```

## Estrutura do Projeto

```
.
├── Dockerfile              # Configuração da imagem Docker
├── README.md               # Este tutorial
├── hello.c                 # Programa C de exemplo
├── run_docker_tutorial.sh  # Script automatizado
└── compile_and_run.sh      # Script para compilação
```

## Como Funciona o Compartilhamento

O parâmetro `-v "$(pwd)":/app` cria um volume que mapeia:
- **Máquina hospedeira**: Diretório atual (onde estão os arquivos do projeto)
- **Container**: Diretório `/app`

Isso significa que:
- Arquivos criados na máquina hospedeira aparecem no container
- Arquivos criados no container aparecem na máquina hospedeira
- Modificações são sincronizadas em tempo real

## Exemplo de Saída Esperada

Quando você executar o programa, deverá ver algo como:

```
Olá! Este programa foi compilado e executado dentro do container Docker!
Sistema: Fedora Linux
Container: minha_maquina_fedora
```

## Solução de Problemas

### Container já existe
Se você receber erro de que o container já existe:
```bash
docker rm minha_maquina_fedora
```

### Imagem já existe
Para reconstruir a imagem:
```bash
docker rmi minha_imagem_fedora
docker build -t minha_imagem_fedora .
```

### Permissões de arquivo
Se houver problemas de permissão, ajuste as permissões dos scripts:
```bash
chmod +x *.sh
```

### Problemas de SSL/Certificados
Se ocorrerem erros de SSL durante a construção da imagem:
```bash
# Use o Dockerfile alternativo
docker build -f Dockerfile.ci -t minha_imagem_fedora .
```

### Container não inicia
Verificar se o Docker está em execução:
```bash
sudo systemctl status docker
sudo systemctl start docker  # se necessário
```

### Erro de compilação com bibliotecas matemáticas
Para programas que usam funções matemáticas (como sqrt), compile com `-lm`:
```bash
gcc -o calculadora calculadora.c -lm
```

## Programas de Exemplo Incluídos

### hello.c
Programa simples que demonstra o básico da compilação em C no container.

### calculadora.c
Programa mais avançado que utiliza bibliotecas matemáticas e demonstra operações aritméticas.

Para compilar a calculadora:
```bash
gcc -o calculadora calculadora.c -lm
./calculadora
```
