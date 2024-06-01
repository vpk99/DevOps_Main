FROM mcr.microsoft.com/dotnet/sdk:8.0
LABEL author="vinayak"
RUN mkdir /app
WORKDIR /app
COPY **/ubuntu/trail /app
EXPOSE 5000
CMD [ "dotnet", "Nop.Web.dll", "--urls", "http://0.0.0.0:5000" ]