FROM mcr.microsoft.com/dotnet/sdk:7.0.102-jammy-arm64v8 AS build-env
WORKDIR /App

# Copy everything
COPY ./src/ ./
# Restore as distinct layers
RUN dotnet restore TestApp/TestApp.csproj
# Build and publish a release
RUN dotnet publish TestApp/TestApp.csproj -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0.2-jammy-arm64v8
WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT ["dotnet", "TestApp.dll"]