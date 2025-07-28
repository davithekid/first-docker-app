## 1 etapa- builder responsavel por compilar o projeto
## maven
FROM maven:3.9-amazoncorretto-17 AS builder

## esse workdir app é uma pasta do proprio docker (usado para guardar minha aplicação)
## estou fazendo com que o docker copie todo meu pom.xml e guarde dentro de app
WORKDIR /app
COPY pom.xml .

## isso baixa todas as dependencias do projeto
RUN mvn dependency:go-offline

## copia os codigos para dentro do meu container (app/src)
COPY src ./src

## compila o projeto (e pula os testes com o Dskiptests)
RUN mvn clean package -DskipTests


## 2 etapa - instancia de uma imagem leve do java
FROM amazoncorretto:21-alpine3.18

## define novamente o diretorio de trabalho
WORKDIR  /app
## copia o .jar gerado na etapa builder para meu container final
COPY --from=builder /app/target/*.jar app.jar

## porta de mapeamento
EXPOSE 8080

## define o comando de execução do container
ENTRYPOINT ["java", "-Dspring.h2.console.settings.web-allow-others=true", "-jar", "app.jar"]

