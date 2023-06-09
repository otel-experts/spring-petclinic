FROM bellsoft/liberica-openjdk-alpine-musl:17
RUN mkdir /app
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
COPY --chown=javauser:javauser ./build/libs/spring-petclinic-3.1.0.jar /app/spring-petclinic-3.1.0.jar
ADD --chown=javauser:javauser https://github.com/signalfx/splunk-otel-java/releases/latest/download/splunk-otel-javaagent.jar /opt/splunk-otel-javaagent.jar
ENV JAVA_TOOL_OPTIONS=-javaagent:/opt/splunk-otel-javaagent.jar
WORKDIR /app
RUN chown -R javauser:javauser /app
USER javauser
CMD "java" "-javaagent:/opt/splunk-otel-javaagent.jar"  "-Dotel.javaagent.debug=true"  "-Dspring.profiles.active=mysql" "-Dsplunk.metrics.enabled=true" "-jar" "spring-petclinic-3.1.0.jar"
