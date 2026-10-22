# 匠魂尖塔 · Tinkers' Spire

适用于 Minecraft 1.20.1 的匠魂主题尖塔数据包。包含随机地图、战斗与 BOSS、商人、工匠、神秘事件和新手教程。

## 下载与安装

1. 使用 Minecraft **1.20.1**、Forge **47.4.10**、Tinkers' Construct **3.12.0.220** 和 Mantle **1.11.117**。
2. 下载 [`release/tinkers-spire-v0.7.123.zip`](release/tinkers-spire-v0.7.123.zip)，原样放入世界的 `datapacks` 文件夹。不要把整个 GitHub 仓库当作数据包安装。
3. 进入世界并执行 `/reload`。首次安装后，退出并重新进入世界，以加载自定义尖塔维度。
4. 按游戏内消息选择加入队伍、开始游戏或进入新手教程。

可选音乐资源包：[`release/tinkers-spire-resourcepack.zip`](release/tinkers-spire-resourcepack.zip)，放入客户端 `resourcepacks` 并在游戏中启用。

建议在专用世界使用，并在更新前备份存档。更新时移除旧版本数据包压缩文件，避免多个版本同时加载。

## 项目文件

- `src/main/resources/`：数据包源码。
- `tools/`：生成、校验、构建和部署脚本。
- `resourcepack/`：可选音乐资源包源码。
- [`docs/设计文档.md`](docs/设计文档.md)：现行设计规则。
- [`docs/变更记录.md`](docs/变更记录.md)：逐版本变更记录。
- [`docs/TEST-CMDS.md`](docs/TEST-CMDS.md)：游戏内测试指令。
- [`docs/MP-TEST.md`](docs/MP-TEST.md)：多人测试清单。
- [`docs/PARTS.md`](docs/PARTS.md)：匠魂部件槽位对照。

仓库根目录的 `pack.mcmeta` 和 `minecraft/` 是上传项目之前仓库已有的文件；**发布数据包以 `release/` 中的压缩包为准**。


