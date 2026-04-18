FROM gradle:jdk24 as builder
RUN mkdir job4j_devops
WORKDIR /job4j_devops

COPY build.gradle.kts settings.gradle.kts gradle.properties ./
COPY gradle/libs.versions.toml gradle/libs.versions.toml
RUN gradle --no-daemon dependencies

COPY . .
RUN gradle --no-daemon clean build -x test

RUN jar xf /job4j_devops/build/libs/DevOps-1.0.0.jar
RUN jdeps --ignore-missing-deps -q \
    --recursive \
    --multi-release 24 \
    --print-module-deps \
    --class-path 'BOOT-INF/lib/*' \
    /job4j_devops/build/libs/DevOps-1.0.0.jar > deps.info
RUN jlink \
    --add-modules $(cat deps.info) \
    --strip-debug \
    --compress 2 \
    --no-header-files \
    --no-man-pages \
    --output /slim-jre

FROM debian:bookworm-slim
ENV JAVA_HOME /user/java/jdk24
ENV PATH $JAVA_HOME/bin:$PATH
COPY --from=builder /slim-jre $JAVA_HOME
COPY --from=builder /job4j_devops/build/libs/DevOps-1.0.0.jar .
ENTRYPOINT java -jar DevOps-1.0.0.jar
