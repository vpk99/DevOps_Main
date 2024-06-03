FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
RUN git clone https://github.com/vpk99/nopCommerce-docker.git
RUN mkdir published
RUN cd nopCommerce-docker 
RUN dotnet publish  -c Release -o published/  nopCommerce-docker/src/Presentation/Nop.Web/Nop.Web.csproj

FROM mcr.microsoft.com/dotnet/aspnet:8.0
RUN useradd -d /app -m -s /bin/bash nop
USER nop
WORKDIR /nop
COPY --from=build --chown=nop:nop published/ /nop 
RUN cd /nop && mkdir logs && mkdir bin
EXPOSE 5000
CMD [ "dotnet", "Nop.Web.dll", "--urls", "http://0.0.0.0:5000" ]