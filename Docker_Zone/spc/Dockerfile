FROM amazoncorretto:17
LABEL author="vinayak"
LABEL Env="learning"
ARG DOWNLOAD_URL="https://khajareferenceapps.s3.ap-south-1.amazonaws.com/spring-petclinic-3.2.0-SNAPSHOT.jar"
RUN curl -O ${DOWNLOAD_URL}
EXPOSE 8080
CMD [ "java", "-jar", "spring-petclinic-3.2.0-SNAPSHOT.jar" ]