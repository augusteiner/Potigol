
FROM openjdk:9-jdk-slim AS builder

RUN apt-get update -q \
    && apt-get install -qy wget

WORKDIR /src

ADD project ./project/
ADD sbt .

RUN ./sbt -v update

ADD build.sbt .

RUN ./sbt -v update

ADD . .
RUN ./sbt clean assembly

FROM openjdk:9-jdk-slim

WORKDIR /opt/potigol

COPY --from=builder /src/jar/potigol.jar .

RUN chmod a+x potigol.jar \
    && ln -s $PWD/potigol.jar /usr/local/bin/potigol

CMD [ "java", "-jar", "/opt/potigol/potigol.jar" ]
