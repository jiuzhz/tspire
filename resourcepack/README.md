# 《匠魂尖塔》Boss 战音乐资源包

这个资源包提供**本作原创的 Boss 战音乐**，配合数据包的"资源包模式"使用：
**一层 Boss → `strive`**、**二层 Boss → `lost lace`**（三层暂时仍用原版 pigstep）。

打包产物（`tools\build-rp.ps1` 生成）：`dist\tinkers-spire-resourcepack.zip`

---

## 1. 安装（客户端）

1. 把 `dist\tinkers-spire-resourcepack.zip` 复制到 `.minecraft\resourcepacks\`
   （或直接把 `resourcepack\` 这个文件夹整个放进去也行）；
2. 游戏里 **选项 → 资源包** → 启用它（放在默认包之上）；
3. 进游戏执行 **`/function tspire:music/rp_on`** —— 这一步**必须做**，理由见下面第 3 节；
4. 之后进 Boss 房就是你的曲子了；想切回原版唱片执行 `/function tspire:music/rp_off`。

> 多人/服务器：资源包是**客户端**的，每个玩家各自装、各自开 `rp_on` 才听得到；
> 数据包那侧 `#MUSIC_RP` 是**全局**开关（队长开一次即可，但没装包的人会听不到一层/二层的曲子）。

## 2. 曲目与文件

| 事件 | 文件 | 曲目 | 实测时长 | 数据包重播间隔 |
|---|---|---|---|---|
| `tspire:music.boss.tier1` | `assets/tspire/sounds/music/boss_tier1.ogg` | **strive** | 106.3 s | 108 s |
| `tspire:music.boss.tier2` | `…/boss_tier2.ogg` | **lost lace** | 172.2 s | 174 s |
| `tspire:music.boss.tier3` | `…/boss_tier3.ogg` | （还是占位音） | — | **三层暂用原版 pigstep（153 s）** |
| `tspire:music.victory` | `…/victory.ogg` | （占位） | — | 暂未接线 |
| `tspire:music.lobby` | `…/lobby.ogg` | （占位） | — | 暂未接线 |

- 格式：**Ogg Vorbis**（44.1 kHz 立体声最稳），其余格式不识别；
- 换曲子：**文件名不要改**，直接覆盖同名文件；
- **换完要重打包**（`tools\build-rp.ps1`）并重新装包；
- **换了不同长度的曲子**要告诉数据包侧一声（重播间隔写在 `functions/music/boss_len.mcfunction`），
  否则会出现"曲子还没放完又从头来"或"放完后空一段"。

## 3. 为什么必须手动 `/function tspire:music/rp_on`

1.20.1 **没有任何指令能检测"某个音效事件是否存在"**：
- 若把资源包曲子设成默认，**没装包的玩家**在 Boss 房会**静音**，日志里刷 `Unknown sound event`；
- 所以默认走**原版唱片**（人人都有），装了包的人再手动切到资源包模式；
- **`/reload` 会把模式重置回原版**（`load.mcfunction` 里把 `#MUSIC_RP` 置 0）—— 重载后要再执行一次 `rp_on`。

## 4. 目录结构

```
resourcepack/
├── pack.mcmeta                        # pack_format 15（1.20.1）
├── README.md                          # 本文件
└── assets/tspire/
    ├── sounds.json                    # 5 个事件
    └── sounds/music/
        ├── boss_tier1.ogg   ← strive      （1515 KB）
        ├── boss_tier2.ogg   ← lost lace   （2706 KB）
        ├── boss_tier3.ogg   （占位：匠魂短音效，待替换）
        ├── victory.ogg      （占位）
        └── lobby.ogg        （占位）
```
