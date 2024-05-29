FROM amazoncorretto:17
LABEL author="vinayak"
LABEL Env="learning"
RUN curl -O https://khajareferenceapps.s3.ap-south-1.amazonaws.com/springpetclinic-3.2.0-SNAPSHOT.jar
EXPOSE 8080
CMD [ "java", "-jar", "springpetclinic-3.2.0-SNAPSHOT.jar" ]