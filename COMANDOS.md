# Comandos Docker - Referência Rápida

Este arquivo contém uma lista de comandos úteis para trabalhar com Docker neste projeto.

## Construindo a Imagem

```bash
# Comando básico
docker build -t minha_imagem_fedora .

# Forçar reconstrução (sem cache)
docker build --no-cache -t minha_imagem_fedora .

# Ver o progresso detalhado
docker build --progress=plain -t minha_imagem_fedora .
```

## Executando o Container

```bash
# Comando básico com volume compartilhado
docker run -it --name minha_maquina_fedora -v "$(pwd)":/app minha_imagem_fedora /bin/bash

# Executar sem nome fixo (container temporário)
docker run -it --rm -v "$(pwd)":/app minha_imagem_fedora /bin/bash

# Executar em background (daemon)
docker run -d --name minha_maquina_fedora -v "$(pwd)":/app minha_imagem_fedora
```

## Gerenciando Containers

```bash
# Listar containers ativos
docker ps

# Listar todos os containers
docker ps -a

# Parar um container
docker stop minha_maquina_fedora

# Iniciar um container parado
docker start minha_maquina_fedora

# Conectar a um container em execução
docker exec -it minha_maquina_fedora /bin/bash

# Remover um container
docker rm minha_maquina_fedora

# Remover um container em execução (forçado)
docker rm -f minha_maquina_fedora
```

## Gerenciando Imagens

```bash
# Listar imagens
docker images

# Remover uma imagem
docker rmi minha_imagem_fedora

# Remover imagens não utilizadas
docker image prune

# Ver informações detalhadas da imagem
docker inspect minha_imagem_fedora
```

## Comandos de Compilação (dentro do container)

```bash
# Compilar programa simples
gcc -o hello hello.c

# Compilar com bibliotecas matemáticas
gcc -o calculadora calculadora.c -lm

# Compilar com debug
gcc -g -o hello_debug hello.c

# Compilar com otimização
gcc -O2 -o hello_optimized hello.c

# Ver informações do compilador
gcc --version

# Ver informações do sistema
cat /etc/os-release
uname -a
```

## Limpeza Geral

```bash
# Remover todos os containers parados
docker container prune

# Remover todas as imagens não utilizadas
docker image prune -a

# Limpeza completa do sistema Docker
docker system prune -a
```