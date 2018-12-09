FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /generator

COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj

COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

COPY . .

ENV TEAMCITY_PROJECT_NAME fake
RUN dotnet test tests/tests.csproj

RUN dotnet publish api/api.csproj -o /publish

FROM microsoft/dotnet:2.1-aspnetcore-runtime
COPY --from=build /publish /publish

WORKDIR /publish
ENTRYPOINT [ "dotnet", "api.dll" ]



