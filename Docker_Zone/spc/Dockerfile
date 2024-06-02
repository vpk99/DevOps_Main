FROM openjdk:17
LABEL author="vinayak"
LABEL project="learning"
ARG GROUP="spc"
ARG USER="spc"
ARG GID=1000
ARG UID=1000
ARG HOMEDIR "/spc"
ARG DOWNLOAD_URL="https://khajareferenceapps.s3.ap-south-1.amazonaws.com/spring-petclinic-3.2.0-SNAPSHOT.jar"
RUN groupadd -g ${GID} ${GROUP} \
      && useradd -h ${HOMEDIR} -u ${UID} -G ${GROUP} -s /bin/bash  -D ${USER}
USER ${USER}
ADD --chown=${USER}:${GROUP} ${DOWNLOAD_URL} ${HOMEDIR}/spring-petclinic-3.2.0-SNAPSHOT.jar
WORKDIR ${HOMEDIR}
EXPOSE 8080
CMD [ "java", "-jar", "spring-petclinic-3.2.0-SNAPSHOT.jar" ]