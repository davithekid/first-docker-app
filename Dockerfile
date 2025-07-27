    ## 1 etapa- builder responsavel por compilar o projeto
    ## usando imagem do maven
    FROM maven:3.9-amazoncorretto-17 AS builder

    ## esse workdir app é a pasta do proprio docker
    ## nessa parte estou fazendo com que a aplicacao docker copie todo meu pom.xml
    WORKDIR /app
    COPY pom.xml .
    ## isso baixa todas as dependencias do projeto
    RUN mvn dependency:go-offline

    ## copia os arquivos-fonte para dentro do meu container (app-src)
    COPY src ./src

    ## compila o projeto e gera o .jar (e pula os testes com o Dskiptests)
    RUN mvn clean package -DskipTests


    ## 2 etapa - instancia de uma imagem leve somente com o JRE17, sem mvn ou ferramentas de build
    FROM eclipse-temurin:17-jre
    ## amazoncorretoo:21-alpine3.18

    ## define novamente o diretorio de trabalho
    WORKDIR  /app
    ## copia o .jar gerado na etapa builder para meu container final
    COPY --from=builder /app/target/*.jar app.jar
    ## mapenando a porta
    EXPOSE 8080

    ## define o comando de execucao do container: vai rodar o jar com java
    ENTRYPOINT ["java", "-jar", "app.jar"]