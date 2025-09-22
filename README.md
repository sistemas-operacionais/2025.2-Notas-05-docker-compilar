# 2025.2-Notas-05-docker-compilar
Notas de aula sobre como compilar e executar programas em um conteiner docker

## Tutorial Docker: Compilando e Executando Programas C

Este tutorial demonstra como criar uma imagem Docker baseada no Fedora Linux para compilar e executar programas em C, com compartilhamento de arquivos entre a máquina hospedeira e o container.

## Arquivos do Tutorial

- `Dockerfile` - Arquivo de configuração da imagem Docker
- `hello.c` - Programa C de exemplo
- `run_docker_tutorial.sh` - Script automático para executar o tutorial
- `compile_and_run.sh` - Script para compilar e executar dentro do container

## Pré-requisitos

- Docker instalado e em execução
- Permissões para executar comandos Docker

## Tutorial Passo a Passo

### 1. Criar a Imagem Docker

A primeira etapa é criar uma imagem Docker baseada no Fedora:latest com as ferramentas de desenvolvimento necessárias.

```bash
# Construir a imagem com o nome 'minha_imagem_fedora'
docker build -t minha_imagem_fedora .
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
docker run -it --name minha_maquina_fedora -v "$(pwd)":/app minha_imagem_fedora /bin/bash
```

Parâmetros utilizados:
- `-it`: Modo interativo com terminal
- `--name minha_maquina_fedora`: Nome do container
- `-v "$(pwd)":/app`: Mapeia o diretório atual para /app no container
- `/bin/bash`: Executa o shell bash

### 3. Compilar e Executar o Programa C

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

### 4. Exemplo de Uso Automatizado

Para facilitar o uso, execute o script automático:

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
docker rmi minha_imagem_fedora
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
