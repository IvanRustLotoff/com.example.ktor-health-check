FROM gradle AS build
COPY src /home/app/src
COPY build.gradle.kts /home/app
COPY gradle.properties /home/app
COPY settings.gradle.kts /home/app
WORKDIR /home/app

COPY . .
RUN gradle clean build

# actual container
FROM openjdk
ENV ARTIFACT_NAME=com.example.ktor-health-check-all.jar
ENV APP_HOME=/home/app

WORKDIR $APP_HOME
COPY --from=build $APP_HOME/build/libs/$ARTIFACT_NAME .

ENTRYPOINT exec java -jar ${ARTIFACT_NAME}
