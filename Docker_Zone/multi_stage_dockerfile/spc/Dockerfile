FROM  maven:3.9.7-eclipse-temurin-17 AS build
RUN git clone https://github.com/vpk99/spring-petclinic-june24.git
RUN cd /spring-petclinic-june24 && mvn clean package

FROM amazoncorretto:17-alpine-jdk
RUN mkdir /spc && chown nobody /spc
USER nobody
WORKDIR /spc
COPY --from=build /spring-petclinic-june24/target/spring-petclinic-3.3.0-SNAPSHOT.jar /spc/spring-petclinic.jar
EXPOSE 8080
CMD [ "java", "-jar" , "spring-petclinic.jar"]