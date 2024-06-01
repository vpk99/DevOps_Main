FROM mcr.microsoft.com/dotnet/sdk:8.0
LABEL author="vinayak"
RUN apt update \
    && apt install unzip -y \
    && mkdir /app
ARG WORKDIR=/app
WORKDIR ${WORKDIR}
ARG DOWNLOAD_URL="https://github.com/nopSolutions/nopCommerce/releases/download/release-4.70.1/nopCommerce_4.70.1_NoSource_linux_x64.zip"
ADD ${DOWNLOAD_URL} /app 
RUN unzip nopCommerce_4.70.1_NoSource_linux_x64.zip \
    && mkdir bin \
    && mkdir logs
EXPOSE 5000
CMD [ "dotnet", "Nop.Web.dll", "--urls", "http://0.0.0.0:5000" ]