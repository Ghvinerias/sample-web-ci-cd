FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["sample-web/sample-web.csproj", "sample-web/"]
RUN dotnet restore "sample-web/sample-web.csproj"
COPY . .
WORKDIR "/src/sample-web"
RUN dotnet build "sample-web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "sample-web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "sample-web.dll"]
