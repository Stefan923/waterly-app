FROM maven:3.6.3-openjdk-17 AS build-project
ADD . ./docker-waterly
WORKDIR /docker-waterly

RUN mvn clean install

FROM openjdk:17-oracle
EXPOSE 8080

COPY --from=build-project /docker-waterly/target/waterly-0.0.1-SNAPSHOT.jar ./docker-waterly.jar
CMD ["java", "-jar", "docker-waterly.jar"]