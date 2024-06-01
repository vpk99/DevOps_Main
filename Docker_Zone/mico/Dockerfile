FROM nginx:1.27
LABEL author="vinayak"
ARG DOWNLOAD_URL="https://www.free-css.com/assets/files/free-css-templates/download/page293/mico.zip"
RUN cd /tmp && curl -O ${DOWNLOAD_URL}
RUN apt update \
    && apt install unzip -y\
    &&  cd /tmp  \
    && unzip mico.zip\
    && mv mico-html /usr/share/nginx/html/mico
EXPOSE 80