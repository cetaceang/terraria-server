FROM debian:bookworm-slim

# 版本参数 - 更新时只需修改这里
ARG VERSION=1452

# 安装依赖
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 下载并解压服务器
WORKDIR /opt
RUN wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-${VERSION}.zip \
    && unzip terraria-server-${VERSION}.zip \
    && rm terraria-server-${VERSION}.zip \
    && chmod +x /opt/${VERSION}/Linux/TerrariaServer.bin.x86_64

# 创建数据目录
RUN mkdir -p /root/.local/share/Terraria/Worlds

# 用环境变量保存版本号供运行时使用
ENV VERSION=${VERSION}
WORKDIR /opt/${VERSION}/Linux

EXPOSE 7777

# 启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
