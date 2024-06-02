FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
RUN git clone https://github.com/vpk99/nopCommerce-docker.git
RUN mkdir /published
RUN  cd /nopCommerce-docker && dotnet publish -c Release /src/Presentation/Nop.Web/Nop.Web.csproj -o /published

FROM mcr.microsoft.com/dotnet/aspnet:8.0
RUN useradd -d /app -m -s /bin/bash nop
WORKDIR /published
COPY --from=build --chown=nop published/ /published/
EXPOSE 5000
CMD [ "dotnet", "Nop.Web.dll", "--urls", "http://0.0.0.0:5000" ]