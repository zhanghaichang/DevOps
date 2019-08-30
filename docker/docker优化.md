# Docker镜像优化


```shell
FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["API/API.csproj", "API/"]
RUN dotnet restore "API/API.csproj"
COPY . .
WORKDIR "/src/API"
RUN dotnet build "API.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "API.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "API.dll"]
```
它分为四个阶段，分别是`base、build、publish和final`。

* base阶段：上面已经分析了这里不再详述。

* build阶段：

FROM microsoft/dotnet:2.1-sdk AS build以microsoft/dotnet:2.1-sdk为基础镜像

WORKDIR /src工作目录为/src

COPY ["API/API.csproj", "API/"]把Dockerfile所在目录的API/API.csproj文件复制到容器的/src/API/中

RUN dotnet restore "API/API.csproj"在当前镜像的基础上执行dotnet restore "API/API.csproj"，把API项目的依赖项和工具还原，并输出结果。

dotnet restore这条命令是使用 NuGet 还原依赖项以及在 project 文件中指定项目特殊的工具执行对依赖项和工具的还原。

COPY . .

WORKDIR "/src/API"切换工作目录到/src/API，可以用WORKDIR API替代，但明显第一种方法更直观。

RUN dotnet build "API.csproj" -c Release -o /app执行dotnet build "API.csproj" -c Release -o /app，以Release模式生成API项目及其所有依赖项并把生成的二进制文件输出到/app目录。



* publish阶段：

FROM build AS publish以上一阶段build为基础镜像

RUN dotnet publish "API.csproj" -c Release -o /app执行dotnet publish "API.csproj" -c Release -o /app，以Release模式把API应用程序及其依赖项打包到/app目录以部署到托管系统。



* final阶段:

FROM base AS final以上阶段base为基础镜像

WORKDIR /app以/app为工作目录

COPY --from=publish /app .把publish阶段生成的/app目录下的文件和文件夹复制到/app目录。

这样做的原因是，上阶段的产物是不会带到下一阶段。

