FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

WORKDIR /build

COPY . .

RUN mvn clean package -pl services/discovery-service -am -DskipTests -B

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

RUN addgroup -S spring && adduser -S spring -G spring

USER spring:spring

COPY --from=builder /build/services/discovery-service/target/*.jar app.jar

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "app.jar"]