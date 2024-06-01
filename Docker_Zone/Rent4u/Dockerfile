FROM nginx:1.27
LABEL author="vinayak"
LABEL project="learning"
ARG DOWNLOAD_URL="https://www.free-css.com/assets/files/free-css-templates/download/page294/rent4u.zip"
RUN cd /tmp && curl -O ${DOWNLOAD_URL}
RUN apt update \
    && apt install unzip -y \
    && cd /tmp \
    && unzip rent4u.zip \
    && mv /tmp/rent4u-html /usr/share/nginx/html/rent4u
EXPOSE 80


