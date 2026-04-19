FROM eclipse-temurin:24-jdk AS builder

WORKDIR /job4j_devops

COPY build/libs/DevOps-1.0.0.jar DevOps-1.0.0.jar

RUN jar xf DevOps-1.0.0.jar

RUN jdeps --ignore-missing-deps -q \
    --recursive \
    --multi-release 24 \
    --print-module-deps \
    --class-path 'BOOT-INF/lib/*' \
    DevOps-1.0.0.jar > deps.info

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
COPY --from=builder /job4j_devops/DevOps-1.0.0.jar DevOps-1.0.0.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "DevOps-1.0.0.jar"]