FROM maven:3.9.9-eclipse-temurin-23 AS build
WORKDIR /opt/k8s-test
COPY ./ /opt/k8s-test
RUN mvn package

FROM azul/zulu-openjdk-alpine:23-latest

COPY --from=build /opt/k8s-test/target/k8s-test-1.0-SNAPSHOT.jar /app/

EXPOSE 9400

ENTRYPOINT ["java", \
            "-jar", \
            "/app/k8s-test-1.0-SNAPSHOT.jar" \
]