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

# Instala o cliente MySQL para execução de scripts SQL
RUN apk --no-cache add mysql-client

# Define o diretório de trabalho dentro do contêiner
WORKDIR /root/

# Copia o binário compilado da etapa de construção
COPY --from=builder /app/main .
COPY ./migrations /migrations

# Exponha a porta em que o aplicativo será executado
EXPOSE 8080

# Executa as migrações e inicializa o aplicativo
CMD ["sh", "-c", "mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < /migrations/001_create_orders_table.up.sql && ./main"]
