FROM amazoncorretto:17
LABEL author="vinayak"
LABEL project="learning"
ARG GROUP="nobody"
ARG USER="nobody"
ARG HOMEDIR "/spc"
ARG DOWNLOAD_URL="https://khajareferenceapps.s3.ap-south-1.amazonaws.com/spring-petclinic-3.2.0-SNAPSHOT.jar"
USER ${USER}
ADD --chown=${USER}:${GROUP} ${DOWNLOAD_URL} ${HOMEDIR}/spring-petclinic-3.2.0-SNAPSHOT.jar
WORKDIR ${HOMEDIR}
EXPOSE 8080
CMD [ "java", "-jar", "spring-petclinic-3.2.0-SNAPSHOT.jar" ]