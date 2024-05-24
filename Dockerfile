# Etapa de construção
FROM golang:1.19-alpine AS builder

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos go.mod e go.sum e instala as dependências
COPY go.mod go.sum ./
RUN go mod download

# Copia o código-fonte do projeto
COPY . .

# Compila o aplicativo
RUN go build -o main ./cmd/ordersystem/main.go

# Etapa de execução
FROM alpine:latest

# Define o diretório de trabalho dentro do contêiner
WORKDIR /root/

# Copia o binário compilado da etapa de construção
COPY --from=builder /app/main .

# Exponha a porta em que o aplicativo será executado
EXPOSE 8080

# Define o comando de inicialização do contêiner
CMD ["./main"]
