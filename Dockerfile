#FROM openjdk:8-jdk-alpine
#VOLUME /tmp
#EXPOSE 8080
#ADD target/*.jar app.jar
#ENTRYPOINT [ "sh", "-c", "java -jar /app.jar" ]

FROM openjdk:11-jre-slim as builder
WORKDIR application
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} ./
RUN java -Djarmode=layertools -jar hello-world-rest-api.jar extract

FROM openjdk:11-jre-slim
WORKDIR application
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]


