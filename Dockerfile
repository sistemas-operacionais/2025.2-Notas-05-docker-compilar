FROM fedora:latest

# Atualizar o sistema e instalar ferramentas de desenvolvimento
RUN dnf install -y gcc glibc-devel make && \
    dnf clean all

# Criar o diretório /app que será compartilhado
RUN mkdir -p /app

# Definir /app como diretório de trabalho
WORKDIR /app

# Comando padrão para manter o container ativo
CMD ["/bin/bash"]

# Criar o diretório /app que será compartilhado
RUN mkdir -p /app

# Definir /app como diretório de trabalho
WORKDIR /app

# Comando padrão para manter o container ativo
CMD ["/bin/bash"]