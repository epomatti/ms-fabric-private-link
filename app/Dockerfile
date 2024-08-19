# syntax=docker/dockerfile:1

### Builder ###
FROM eclipse-temurin:21-jdk-jammy AS builder
WORKDIR /opt/app
COPY . .
RUN ./mvnw dependency:go-offline -Dhttps.protocols=TLSv1.2
RUN ./mvnw clean install

### Runtime ###
FROM eclipse-temurin:21-jre-jammy
WORKDIR /opt/app
COPY --from=builder /opt/app/target/*.jar /opt/app/*.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "*.jar", "--spring.profiles.active=fabric"]
