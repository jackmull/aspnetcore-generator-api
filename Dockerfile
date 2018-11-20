FROM microsoft/aspnetcore-build:2 AS build-env

WORKDIR /generator

COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj

COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

COPY . .

ENV TEAMCITY_PROJECT_NAME fake
RUN dotnet test tests/tests.csproj

RUN dotnet publish api/api.csproj -o /publish

FROM microsoft/aspnetcore:2
COPY --from=build-env /publish /publish

WORKDIR /publish
ENTRYPOINT [ "dotnet", "api.dll" ]



