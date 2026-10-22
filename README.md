# 匠魂尖塔 (Tinkers' Spire)

Minecraft **1.20.1** + Forge 47.4.10 + Tinkers' Construct **3.12.0.220** / Mantle **1.11.117**
的**纯数据包**肉鸽小游戏：自行生成关卡地形、发放奖励、生成匠魂原版材料的装备，**不新增任何材料、工具或方块**。

---

## 文档地图

| 文档 | 内容 |
| --- | --- |
| [`HANDOFF.md`](HANDOFF.md) | **先读这个** —— 上下文交接、环境事实、**已排除的错误路径**、待办 |
| [`docs/VERIFY.md`](docs/VERIFY.md) | 游戏内验证清单 V1~V7 与结论 |
| [`docs/E2E.md`](docs/E2E.md) | **端到端验收清单** —— 从开局到通关，每步都有打勾项 |
| [`docs/MP-TEST.md`](docs/MP-TEST.md) | **多人（2 客户端）测试清单** —— 开局构筑 / 封门 / 三选一 / 中途加入 / `/reload` |
| [`docs/RECOVERY.md`](docs/RECOVERY.md) | 文件写坏时怎么从 DSH 会话日志回放重建 |
| [`docs/TECH-VERIFIED.md`](docs/TECH-VERIFIED.md) | 反编译核验的技术事实（NBT 键名、战利品函数、注册表字段） |
| [`docs/PARTS.md`](docs/PARTS.md) | 全部工具槽位与部件对照表（写配置的硬约束） |
| `../匠魂尖塔-设计文档-完整整合版.md` | **主设计文档**（v0.6.62，权威；多人专项见 §13.11.6，商人货架见 §3.2.1，三选一候选见 §3.3 第一类，开局构筑每人一份见 §2.1，阵亡 / 旁观 / 复活跟队见 §13.11.3，节点封门 / 场景只建一次见 §3.1.2 与 §13.11.6 第（9）条，Boss `#FLOOR` 修正见 §7.6 / §13.5，**v0.6.26 奖励池 / 水晶排除 / 回血 / Boss 提示 / 出怪位置见 §3.3 / §6.3 / §3.1.2 / §7.6 / §7.4**，**v0.6.27 商人限购清零与货架按节点 / 服务节点锁行 / 共鸣与修复递增价 / Boss 前摇 / 移除地图书见 §3.2.1 / §3.1.2 / §3.1.2 + §3.6.1 / §7.6 / §2.4**，**v0.6.29 二层虚空修复 / 灰烬重生 / `tspire_src` / 丢下即出售 / 逐玩家提示见 §3.5 / §7.6 / §3.3 / §3.2.3 / §3.1.2**，**v0.6.30~31 淬火者燃烧蓄能见 §7.6**，**v0.6.32 路线 bug 根因 / 板斧刃奖励 / 锈刃督军重做见 §3.1.2 / §3.3 / §7.6**，**v0.6.33 商人货架 15 格 + 2 格镶板盔甲见 §3.2.1**，**v0.6.34 沼泽猎手三机制重做见 §7.6**，**v0.6.35 工匠「融合」见 §3.1.2**，**v0.6.36 裂颅者【战术突进】/【钉刺陷阱】见 §7.6**，**v0.6.37 织影巫师【尖牙阵】/【暗影帷幕】见 §7.6**，**v0.6.38 钴蓝决斗者【崩刃】/【玛玉灵回响】见 §7.6**，**v0.6.39 删除 6 只 Boss 的占位阶段机制（与真机制同阈值双触发）见 §7.6**，**v0.6.40 铭刻者【铭刻重写】/【强化剥离】见 §7.6**，**v0.6.41 修正铭刻者【铭刻重写】状态窗口见 §7.6**，**v0.6.42 熔核暴君【凋零剑压】/【熔核爆发】见 §7.6**，**v0.6.43 出售池修复 / 盔甲部件 / 函数加载失败修复见 §3.2.1 + §3.3 + §13**，**v0.6.44 奖励权重 / 装备池含盔甲 / HUD / Boss 奖励升层 / 沼泽猎手重做见 §3.3 / §3.1.2 / §7.6**，**v0.6.45 修正【标枪投掷】中毒效果 + 效果/粒子混淆校验见 §7.6 + §3.6.5**，**v0.6.46 修复 `/damage` 与 `/attribute` 加载失败 + 血量判定改 NBT + 11 项功能调整见 §3.6.5 / §7.6 / §3.3**，**v0.6.47 `merchant/sell` 堆叠计价（改生成器）/ `duelist_echo` 血量读取 / `Item.count` 大小写 bug 见 §3.2.3 + §7.6 + §3.6.5**，**v0.6.48 泥沼 `as`/`at` 根因 / 血量每 tick 显式同步 / `test/boss_probe` / 裂颅者三机制重做 / 第 2 层 Boss 血量 600→500 / 掠夺者原版弩见 §7.6 + §3.6.5 + §3.6.4 + §13.5 + §7.4**，**v0.6.49 掠夺者的弩写进 `gen-gear.ps1`（重跑生成器不再丢）/ `boss_probe` 覆盖 8 只 / 裂颅者【钉刺陷阱】"阶段血量门"经确认是文档写错（已改，代码不动）/【三连射】"三支箭 / 45° 扇形"尚未实现见 §7.4 + §3.6.4 + §7.6**，**v0.6.50 裂颅者【三连射】真·三支箭（`skullcrusher_volley`，8 桶近似）/ 钴蓝决斗者三机制重做为【死斗】【破釜】【决斗嘶吼】（旧【疾风连击】【崩刃】【玛玉灵回响】与 `duelist_blunt`/`duelist_echo` 已删）/ `validate.ps1` 规则 8→9 条（匠魂效果 id）见 §7.6 + §3.6.5**，**v0.6.51 【死斗】默认禁用（`#CFG_DUELIST_DEATHMATCH=0`）/ 删掉 `boss/active` 遗留的旧【疾风连击】块 / `battle_win` 清理 `tspire_arrow` 见 §7.6 + §3.6.5**，**v0.6.52 ★ 47 处 `playsound` 锚定修复（`in` 不换坐标 → 音效全在原点） / Boss 死后清召唤物 / 亡者征召 4→3 只 / 织影巫师四项（唤鬼 14s·5 血、尖牙阵 10s、暗影帷幕重做、发光收尾）见 §3.6.5 + §7.6**，**v0.6.53 织影巫师底怪最终 = 唤魔者 + `kill @e[type=vex,tag=!tspire_mob]` 只清原版恼鬼（`#CFG_WEAVER_KEEP_EVOKER=1`）见 §7.6**，**v0.6.54 奖励池改版（`rewards/special` 特殊池，298/348/151/191/6/6）/ 商人格 6→5 部件 + 1 特殊 / 出售表补 12 件盔甲 / 破甲重击追加抗性 / 第 3 层 1000→750 见 §3.3 + §3.2.1 + §3.2.3 + §7.6 + §13.5**，**v0.6.55 【死斗】重做（玩家掉血 + 3 格 + 10 秒冷却，默认开启）/ 新增 Boss 单挑入口 `test/boss_pick` + 9 个 `boss_pick_<id>` 见 §7.6 + §3.6.4**，**v0.6.56 铭刻者四项重做（时间铭刻 / 铭刻逆流 / 时间书虫 / 遗忘蚀刻，幻术师只拿原版弓）见 §7.6**，**v0.6.57 重铸之王三机制（再锻 / 金铸壁垒 / 王权征召，`boss_gear/recast_axe` 35 条）+ 熔核暴君三机制重做 + 占位阶段清零见 §7.6**，**v0.6.58 熔核暴君火焰改真方块（`fill … fire keep` / `air replace minecraft:fire`，代价：会烧掉落物）见 §7.6**，**v0.6.59 Boss 血量随人数缩放（200/250/300、350/450/500、500/600/750）+ 百分比门槛分数化（`#BNOW` vs `#TH_*`）/ 开局侧栏清理 / 泥沼 2 秒见 §13.5 + §3.6.5 + §7.6**，**另新增 `docs/TEST-CMDS.md`（全部测试指令清单）**，**v0.6.60 修掉 5 个"函数加载失败"（`skullcrusher_kb`/`recastking_push` 缺 `execute`、`moltenlord_lava_zone` 的 `run` 不在链尾、`recastking_summon` 的不存在粒子与多实体 `data merge`——这才是"BOSS 不放技能"的真凶）/ 淬火者【灰烬重生】误触发（全局假玩家门没框 Boss）/ Boss 测试场 `test/boss_arena_build` + `boss_arena_setup` 重写 / 怪物流血真凶 `tconstruct:nahuatl` 排除 / 沼泽猎手数值（泥沼半径 5·1.5 秒、毒 5 秒、现身 16 秒 + 落地压制）/ 空中箱子修复（生成器先清 chest）/ `validate.ps1` 规则 9→12 条 + 新增 `checklog.ps1` 见 §3.6.5 + §3.6.4 + §7.6 + §7.3 + §3.2.1**，**v0.6.61 #27 熔核暴君两个绝对门（300/425）改成随人数缩放的分数门（`#TH_60` 300/360/450、`#TH_85` 425/510/637，用 `#ML_WIDE`/`#ML_BURST` 标志位）/ 玩家对 #26·#21·#25 结案、#6·#7·#10·#18 条目删除 + 残留注释已清 见 §7.6 + §13.5 + §3.6.5**，**v0.6.62 玩家拍板直修四条：#31 铭刻者【时间书虫】漏网的 `..375` 绝对门改成 `#BNOW <= #TH_HALF`（恒定 50%）/ #9 `validate.ps1` 粒子计数规则覆盖带额外参数的粒子（`dust` 4、`dust_color_transition` 7、`block` 等各 1，仅 `vibration` 豁免）/ #13·#28 击退与金铸壁垒外推改成真·任意方向水平推进（`tspire_kb_rot` marker + `rotated ~ 0`，Y 恒为 0，旧 dx/dz 机删除）/ 新增 validate 规则 §4f 禁止写死血量门（规则 12→13 条）+ `test/boss_arena_setup` 清 `tspire_kb_rot` 残留 见 §7.6 + §3.6.5 + §3.6.4**，**待办请只看文档开头的「待办总表（唯一入口）」**） |
| `../forge-roguelike-gdd.md` | 旧方案（《匠魂肉鸽》），**已废弃**，仅作技术资料 |

---

## 环境

| 项 | 值 |
| --- | --- |
| 测试存档 | `D:\舜\存档\shipin3\.minecraft\versions\1.20.1-Forge\saves\3_12_0_220` |
| 数据包安装位置 | `<存档>\datapacks\tinkers-spire\`（文件夹形式，迭代用）或 `.zip` |
| 匠魂 jar | 该实例 `mods\TConstruct-1.20.1-3.12.0.220.jar` |
| 解包数据（只读参考） | `D:\舜\存档\shipin3\TConstruct-1.20.1-3.12.0.220\` |
| Forge MDK（暂时不需要） | `D:\forge-1.20.1-47.4.10-mdk` |
| 命名空间 | `tspire`，维度 `tspire:tower` |

> ⚠️ 该实例同时装了 `tinkersdevotion-1.1.0.jar`。本方案不使用它，**测试时建议移除**，
> 否则它会替换怪物身上的装备，干扰 V2/V5/V7 的判定。

---

## 构建与测试

```powershell
# 打包成 zip（本机默认禁止运行 .ps1，需带 -ExecutionPolicy Bypass）
powershell -ExecutionPolicy Bypass -File tools\build.ps1

# 直接铺文件夹到测试存档（迭代更快，推荐）
powershell -ExecutionPolicy Bypass -File tools\deploy.ps1

# 重新生成各类预生成内容（改了材料池/槽位表之后必须跑）
powershell -ExecutionPolicy Bypass -File tools\gen-gear.ps1      # 怪物装备战利品表
powershell -ExecutionPolicy Bypass -File tools\gen-groups.ps1    # 遭遇组 + 骰子谓词
node tools\gen-runtime-map.js                              # 运行时随机地图
powershell -ExecutionPolicy Bypass -File tools\gen-rewards.ps1   # 战斗/宝箱奖池
powershell -ExecutionPolicy Bypass -File tools\gen-shops.ps1     # 商人：每层 8 份货架（共 24 份，v0.6.21 起每人各掷一份）
powershell -ExecutionPolicy Bypass -File tools\gen-starter.ps1    # 开局构筑的 6 份抽选方案
powershell -ExecutionPolicy Bypass -File tools\gen-reforge.ps1   # 重铸的 item modifier

# 离线校验（不启动游戏，抓悬空引用 / ID 写错 / 会让函数加载失败的写法）
powershell -ExecutionPolicy Bypass -File tools\validate.ps1
```

> ### ⚠️ 不要用 `Compress-Archive`
>
> Windows 上 `Compress-Archive` 会把 zip 内的条目名写成**反斜杠分隔**。Java 的 zip 读取器
> 把反斜杠当**普通文件名字符**，于是：Minecraft 能在 zip 根找到 `pack.mcmeta`
> （日志显示 `Found new data pack ... loading it automatically`，**看起来加载成功了**），
> 但它**读不到 `data/` 里的任何内容** → 函数标签不存在 → `load`/`tick` 不执行，**且不报任何错**。
> `tools/build.ps1` 已改为逐条目手动写入并强制 `/` 分隔符，结尾有校验。**改构建脚本时务必保留这个校验。**

游戏内：

```mcfunction
/reload

/function tspire:test/all              # 跑 V1~V7 验证
/function tspire:run/start             # 开始一局
/function tspire:test/map_demo         # 生成一层地图
/function tspire:test/shop_demo        # 直接看"你自己"的商人货架（v0.6.21 起每人一份）
/function tspire:test/artisan_reforge   # 直接看重铸
/function tspire:test/boss_demo_f1     # 直接看 Boss
```

> `/reload` 能热更函数与 JSON，但 **`dimension` / `dimension_type` 只在世界加载时注册**，
> 改了维度必须重进存档。

---

## 目录结构

```
tinkers-spire/
├── HANDOFF.md                  # 上下文交接（先读）
├── README.md
├── docs/
│   ├── VERIFY.md               # V1~V7 游戏内验证清单与结论
│   ├── E2E.md                  # 端到端验收清单
│   ├── MP-TEST.md              # 多人（2 客户端）测试清单
│   ├── TECH-VERIFIED.md        # 反编译核验结论
│   └── PARTS.md                # 工具槽位/部件对照表
├── tools/                      # 全部纯 ASCII（中文写在 .md / UTF-8 数据文件里）
│   ├── build.ps1               # 打包 zip
│   ├── deploy.ps1              # 铺文件夹到存档
│   ├── validate.ps1            # 离线校验器（改完先跑这个）
│   │                            # v0.6.22 新增规则：抓 `score <t> <obj> <op> <holder>` 后直接跟
│   │                            # if|unless|run 的写法（缺源计分板 → 整个函数加载失败）
│   │                            # v0.6.25 新增规则 §4c：mobs/ 与 boss/ 下不许写 `#FLOOR`
│   │                            # （写错值会让第 1 层 Boss 把人送到第 3 层）
│   ├── tc-source.txt           # 解包路径（中文，UTF-8 读取）
│   ├── target.txt              # 存档路径（中文，UTF-8 读取）
│   ├── shop-text.json          # 商人 UI 文案（中文在这里，不在 .ps1 里）
│   ├── offer-text.json         # 三选一 UI 文案（v0.6.22 新增；同上，不在 .ps1 里）
│   ├── gen-gear.ps1            # 怪物装备战利品表
│   ├── gen-groups.ps1          # 遭遇组 + roll/d1..d20 谓词
│   ├── gen-runtime-map.js     # 运行时随机地图
│   ├── gen-rewards.ps1         # 战斗/宝箱奖池 + 强化水晶
│   ├── gen-shops.ps1           # 24 份商人货架 + 购买/出售函数
│   └── gen-reforge.ps1         # 重铸的 item modifier + 按工具分支
└── src/main/resources/
    ├── pack.mcmeta             # pack_format 15
    └── data/
        ├── minecraft/tags/functions/{load,tick}.json
        └── tspire/
            ├── dimension/      # tspire:tower（仅世界加载时注册）
            ├── functions/
            │   ├── config/     # defaults.mcfunction —— 所有 #CFG_* 可调参数（改这里）
            │   ├── load / tick / run / map / mobs / boss / rewards
            │   ├── shop/       # 生成的货架（51 个函数）
            │   ├── artisan/    # 工匠菜单 + 重铸
            │   ├── merchant/   # buy/slot0..9, deliver_0..9, sell, sell_drop（v0.6.29 丢下即出售）
            │   └── test/       # 各类 demo 与验证（含 v0.6.29 起的 door_check / door_node 节点封门自检）
            ├── item_modifiers/reforge/  # 重铸：12 个 s<槽数>_f<层>.json
            ├── loot_tables/    # mob_gear / rewards / ...
            ├── predicates/roll/# d1..d20
            └── tinkering/tags/materials/compat_excluded.json
```

---

## 约定

- **`tools/*.ps1` 必须保持纯 ASCII**。Windows PowerShell 5.1 会把无 BOM 的 `.ps1` 按 ANSI 读取，
  中文字面量会**破坏语法**（而且是连锁报错，报错行往往不是出问题的那一行）。中文一律放：
  - 说明文档 → `.md`
  - 生成器要用的字符串 → UTF-8 的 JSON（如 `tools/shop-text.json`），用 `-Encoding UTF8` 读
  - 中文路径 → `tools/target.txt` / `tools/tc-source.txt`，同样 `-Encoding UTF8` 读
- **命令参数区只允许单个空格**。Brigadier 的 `Vec3Argument` 只吃一个空格，`~  ~` 会报
  `缺少"{"` 并让**整个函数加载失败**。
- **`function` 名字里的命名空间只写一次**：`tconstruct:tinkers_anvil`，不是 `minecraft:tconstruct:...`。
- **聊天栏可点击事件在 1.20.1 是驼峰** `clickEvent` / `hoverEvent`，且 hover 的文本字段叫 `contents`。
  写成 `click_event` / `hover_event`（1.21.5 的写法）会被**静默忽略**。
- **面向玩家的指令一律用 `@a[team=tspire_party]`**（设计文档 §13.11.5）；单人局就是队伍人数为 1 的特例。
- **`tic_materials` 数组长度必须与 `docs/PARTS.md` 的槽数严格一致**，多余槽位被静默跳过。
- 只新增文件，不覆盖匠魂原版定义。
- **想改数值先看** `src/main/resources/data/tspire/functions/config/defaults.mcfunction`（运行时可调）
  和 `tools/gen-*.ps1` 顶部的 `TUNABLE PARAMETERS` 段（生成期可调）。
  完整对照表见主设计文档 **§3.6 调参索引**。

---

## 当前进度

| 模块 | 状态 |
| --- | --- |
| 项目骨架 / 初始化 / 主循环 | ✅ |
| V1~V7 技术验证 | ✅ 全部有结论（见 `docs/VERIFY.md`） |
| 塔维度 + 锚点 + 三层平台 | ✅ |
| 节点地图生成（36 份预生成） | ✅ |
| 遭遇组与出怪（38 组 + 装备链路） | ✅ v0.6.26：编队生成位置改到**房间北侧（玩家正前方）** —— `tools/gen-groups.ps1` 的 `Get-Pos` 由 `$z = 1 + floor(Index/3)*2`（+Z = 南 = 玩家背后）改为 `$z = -1 - floor(Index/3)*2`（玩家南门进、往 −Z 走）；**v0.6.27 再往北推 2 格**：`Get-Pos` 改为 `$z = -3 - floor(Index/3)*2` |
| 战斗奖励（部件三选一 / 强化水晶 / 宝箱） | ✅ 三选一为 **预生成具体候选 + 可点击聊天菜单**（v0.6.22；`Lock` 宝箱只是视觉标志，菜单直接写**部件名 · 材料名**，每人各掷一个变体、各领一份）；**v0.6.23：随机奖励改成每人各骰一次**（`as @a[...] run loot give @s`，不再是 `loot give @a[...]` 的"骰一次发全队"），三选一界面彻底逐人（`offer_parts` 的全队广播已删）。**v0.6.26**：① 奖励池权重改为 **部件 22 / 修补 16 / 水晶 38 / 装备 8 / 金苹果 15（新增）/ 远古 0.5 / 投掷 0.5**（合计 100）；② 水晶池**删掉 8 个采掘类强化**（97 → 89 条，`luck` 保留）；③ 三选一不再只判定手持武器 —— 新增 **Pass A** 按优先级挑一件来源（**主手 → 胸甲 → 护腿 → 靴子 → 头盔**，都没有则回退通用池）写进 `#SRC`，**只穿护甲空手的玩家也能拿护甲部件** | **v0.6.29：来源判定重构** —— 新增逐人计分板 **`tspire_src`**：Pass A 在**菜单那一趟**把选中的来源编号复制到执行者身上（优先级加了**副手 -106**：主手 → 副手 → 胸甲 → 护腿 → 靴子 → 头盔），**发奖块只读 `@s tspire_src`**、不再在点击时重判手持物（旧写法会"看板斧菜单、发出手斧刃"）。**v0.6.32：补回 5 个漏掉的部件** —— `$partDefs` 手写表原本只有 10 项，漏了 `pick_head` / `hammer_head` / **`broad_axe_head`（板斧刃）** / `adze_head` / `large_plate`，于是这些工具的核心部件**永远抽不到**；补上后 `part_f1.json` **131 → 196 条** |
| 远程武器（自容箭袋 + 开局箭） | ✅ v0.6.26：**每一把发给玩家的弓 / 弩**都带 `tconstruct:bulk_quiver`（自容箭袋，物品 NBT `tic_modifiers:[…]`）—— 开局构筑 / 商人货架 / `mob_gear/weapon_f*`（战斗与宝箱奖励复用）三处都加；`run/give_kit` 额外发 **32 支箭**。原因：`bulk_quiver` 带 `check_standard_arrows: true`，**先吃背包里的普通箭**，不发箭则弓到手就是废铁 |
| 工匠节点（工匠砧 / 部件台 / 强化台 / 工作站 + **重铸**） | ✅ v0.6.26 回血调整：旧版 `instant_health` amplifier 4 = **64 点 = 必满血**（"回血太高"），现在 **进节点免费回 45%（9 点）** + 菜单花 **`#CFG_ARTISAN_HEAL_PAID_COST`（默认 25 金币）再回 25%（5 点）**；旧键 `#CFG_ARTISAN_HEAL_AMPLIFIER` 已删。新增 `artisan/heal_snapshot` / `heal_free` / `heal_paid`（`heal_snapshot` 已在 v0.6.27 删除）。因 `instant_health` 只有 4/8/16/32/64 档，9 点是**两段拼**（+8 再 +4−3），有 **±1 容差**，吸收会挡掉修正伤害。**v0.6.27 三项**：① **新增「共鸣」**（`artisan/resonate`）—— 30 金币、每局限一次，随机给 1 枚强化水晶；② **「修复」三项调整** —— 范围扩到**整个物品栏**（`container.0..35`，备用工具也修）、**每次附赠 32 支箭**、价格**递增**（基础 `#CFG_REPAIR_COST` 15 + 每修一次 `#CFG_REPAIR_COST_STEP` 5，新增键；本价算进新计分板 `@s tspire_repair_cost`，次数记 `@s tspire_repairs`，新函数 `artisan/repair_cost`）；③ **1 滴血进门不回血的根因修复** —— `#HP0` 是**共享假玩家**，旧写法"先全队 snapshot 再全队 heal"让低血玩家读到队友血量、**一点血都不回**，现把 snapshot 折进 `artisan/heal_free` 开头、`enter_artisan` 只跑**一圈** `as @a[team] run heal_free`，**`artisan/heal_snapshot` 已删除**。另：**菜单里的 `[重铸]` 入口自 v0.6.27 起暂时隐藏**（函数与生成器全保留）。**v0.6.28**：**「共鸣」与「融合」改为每个工匠节点各限一次**（用节点 marker 的 z 当钥匙，新计分板 `@s tspire_craft_node`；换一个工匠节点即重置，不再是"整局限一次"）；**部件制造台不再塞金质模具**，改在旁边的箱子里备好木制模具 + 毒液瓶（新增 `artisan/put_cast` + `map/build_workshop`）。**v0.6.35：融合已实现** —— 菜单新增 `[融合]`（`artisan/fuse` + `fuse_do`），**30 金币、每个工匠节点限一次**（`tspire_fuse_used`，与共鸣一致），主手 + 副手各持一枚材料部件 → 消耗两枚、得到**与主手同类型、材料取自下一层材料池**的一枚部件（f1 → 第 2 层池；f2 / f3 → 第 3 层池）。**注**：「两枚部件必须同级」这个前置条件**仍未校验**（见下方待办行） |
| 宝箱节点 | ✅ v0.6.26：除发一件匠魂装备外，**再回 20%（4 点）生命** —— 新增 `map/chest_heal`（`instant_health` 1 0 = 正好 4 点），`map/enter_chest` 用 `as @a[team=tspire_party]` **逐人结算** |
| 开局构筑（护甲 4 部位各三选一 + 武器五选二） | ✅ v0.6.23：**每人各掷自己那份方案**（`@s tspire_draft_l`，1..6），各看各的菜单、各选各的；共享的 `Lock` 箱子在取货前按点击者重摆。**同一部位允许重复**（三个候选独立随机抽，不再要求"三套各一"） |
| 开局物资（牛排 ×64 / 箭 ×32 / 工匠大百科 ×1） | ✅ **v0.6.28 更正**：v0.6.27 一度**误删了工匠大百科**（玩家真正想删的是**《尖塔地图》成书**），现已改回**照常发放 `tconstruct:encyclopedia`**；**《尖塔地图》成书不再发放**。牛排 ×64 与箭 ×32 照旧。**注**：v0.6.27 那批说明里"不再发工匠大百科""tellraw 漏改"两条说法**均已作废** |
| 塔内场景（大厅 + 节点房间 + 走廊照明 + Boss 房） | ✅ v0.6.25：服务节点（工匠 / 商人）的场景**只建一次**（节点 tag `tspire_node_built`）—— 重进不再重摆方块、商人村民不再被杀掉重召；`map/build_merchant_stall` 为新增的柜面函数。**v0.6.27**：该柜面函数再加一只**不锁的普通箱子**（`~-2 ~ ~-2`），供两名玩家互换装备 |
| 路线选择（相邻子节点解锁，一行只能走一条） | ✅ v0.6.25：**不能回头** —— `map/refresh_doors` 重写，只开 `tspire_node_avail` 与 `tspire_node_current`，**`tspire_node_done` 也封死**；封门用 `geometry.json` 的 **`sealBlock`**（默认抛光黑石砖，**可见**），临时战斗封锁 `terrain/lock` 仍用 `barrier`。`map/complete_node` **故意保留** `tspire_node_current`（否则结算时会把玩家关在屋里），玩家踏进下一节点后旧房才彻底封死。**v0.6.27 修"封口石没生效"**：此前只有普通节点跑 `map/node_begin`（负责锁本行），服务节点走 `map/enter_service` **只贴 `tspire_node_current`、从不锁行**，同行其余房间仍是 `tspire_node_avail`、门开着；现在 `enter_service` 结尾补 `execute as @e[tag=tspire_node_current,limit=1] unless entity @s[tag=tspire_node_done] run function tspire:map/node_begin`，**第一次进服务节点即按普通节点锁掉本行**。**v0.6.32 修「同一行其他房间还能进」的根因**：`map/unlock_next_row` 扫描的是**所有** `tspire_node_done` 节点，于是一个**旧节点**会反复解锁它下一行，把 `node_begin` 刚锁掉的**同行兄弟房间又开回来**；证词来自新增的 **`/function tspire:test/door_check`**（打印 40 格内每个节点的坐标 / tag / 南北门真实方块，第 2 行打完宝箱节点后同行其余房间仍是 `avail`、门是空气）。修法（`tools/gen-terrain.ps1`）：(a) `unlock_next_row` 开头**清扫** —— 对已有 done 的每行（1..16）把剩余 `avail` 打回 `locked` 再 `remove tspire_node_avail`；(b) 每条解锁规则加守卫 `unless 该行已有 done/current 节点` |
| 死亡 / 复活 / 全灭判负 | ✅ v0.6.24：阵亡 / 旁观 / 复活**不再把人踢出塔** —— 新增 `tspire:party/gather`（贴到队友身边：活着的塔内队友 → 任何塔内队友 → 当前节点 → 塔锚点），`party/die` / `party/revive_self` / `tick/player` 出图兜底三处都调它；`tick/second` 每秒按层重设重生点、并让身边 16 格内没有活队友的旁观者自动跟队。**`/spawnpoint` 在自定义维度上不可靠（MC-240812），不再单独依赖** |
| 实体上限（§13.12） | ✅ |
| 商人节点（15 格预生成货架 + 购买 + 出售 + 特价） | ✅ v0.6.21：货架改为**每人一份自己的**（`tspire_shop_f` / `tspire_shop_l`，1..8 份/层）+ **每人每格限购一次**（`tspire_buy0..9`）；`deliver` 不再清空货架格，队友互不影响。**v0.6.25 修两个 bug**：① **强化水晶可出售**（新增 `#CFG_SELL_CRYSTAL`，默认 12）；② **买入时以买主本人身份重摆货架**（旧写法用 `at @e[tag=tspire_node_current]` 定位，而那个 tag 在可复用节点上每 tick 被收掉 → 静默失效 → **两人买到的都是房主那份货**）。柜面（讲台/灯笼/村民）抽成 `map/build_merchant_stall`，**每个节点只建一次**。**v0.6.27 修"商人买不了东西"**：根因是 `run/reset_player` **没清** `tspire_buy0..9`，且 `map/enter_merchant` 只在 `@s tspire_shop_f != #FLOOR` 时重抽 —— **新一局仍在第 1 层时既不重抽也不清限购**，上一局的"已买过"被原样带进新局；现在 `reset_player` 清 `tspire_shop_f` / `tspire_shop_l` / **`tspire_shop_node`** / `tspire_buy0..9`（连带 `tspire_fuse_used` / `tspire_resonate_used` / `tspire_repairs` / `tspire_repair_cost`），**货架改用"当前节点"当钥匙**（节点 marker 的 z 坐标 → 新计分板 `@s tspire_shop_node`）：**换节点/换层/开新局才重掷，回到同一节点保持原样**。另新增**讲台旁的普通箱子**（`setblock ~-2 ~ ~-2 chest`，不锁，供玩家互换装备；讲台下的 `Lock` 商品箱照旧打不开）。**v0.6.29：「丢下即出售」实现** —— 新增生成的 `merchant/sell_drop`（价格表与 `merchant/sell` 相同），由 `tick/second` 对**商人 NPC 4 格内**的物品实体调用，按**堆叠数量**把钱付给 **16 格内最近的那名玩家**然后删除实体；**代价**：把工具丢在商人旁边想给队友 = 也算出售（交换装备请用普通箱子）。**v0.6.33：货架 10 → 15 格已实现** —— 15 格 = 6 部件 + 4 强化水晶 + **2 格镶板盔甲（必定）** + 2 匠魂装备 + 1 远古工具，逐人限购标记扩到 `tspire_buy0..14`（见 §3.2.1） |
| Boss（9 只 + 阶段 + 血条） | ✅ v0.6.25（**重大修正**）：`#FLOOR` 只允许 `run/start_run` / `run/floor_advance` 修改 —— 生成器与 8 个 `boss/spawn/*` 里写错的值已删除（第 2 层写 3、第 1 层写 2，导致**打第 1 层 Boss 被送到第 3 层**），`validate.ps1` 新增 §4c 离线规则兜住；同时 `run/battle_start` 对 **Boss 房跳过 `mobs/spawn_batch`**（Boss 房不再叠一整组普通编队）。**v0.6.26 技能提示强化**：`boss/active.mcfunction` 重写，每个技能都给 **(a) actionbar 加粗大字点名技能 + (b) 专属音效**，四个直接伤害 / 负面效果的技能再加 **(c) 一条聊天栏操作提示**（烈焰环「先退开」/ 毒标枪「别站桩」/ 镜像分身「分辩分身」/ 熔火地脉「换位」）；actionbar 覆盖不刷屏，聊天栏每冷却周期只发一次。**v0.6.27 加 2 秒前摇**：`boss/active` 重写，**每个技能**在触发阈值 `T` 前开一个 **40 tick（2 秒）窗口 `T-40..T-1`** —— (a) actionbar 预告「⚠ 【技能名】准备中」、(b) **每 tick** 给 Boss `slowness`（3 秒，amplifier 2）、(c) 用 **4 个 `end_rod` 粒子**在东西南四点画出技能半径；到 `T` 原有效果照旧触发。有环半径：淬火者 8 / 沼泽猎手 6 / 铭刻者 20 / 熔核暴君 6，自身增益与召唤类无环。**同批削弱沼泽猎手**：【毒标枪】半径 **12 → 6**、中毒 **5s → 3s**。**v0.6.29 淬火者【灰烬重生】实现**：新增 `health` 判据计分板 **`tspire_boss_hp`**，`boss/tick` 在 **HP ≤ 60（20%）且未复活过**时触发 `boss/quencher_rebirth` —— 因为 **1.20.1 拦不住实体死亡**，这是**「濒死触发」**（正常一刀砍不出 60 点，表现仍是"第一次快被打死时复活"）。**v0.6.30~31 淬火者【燃烧蓄能】（玩家指定，纯粒子版）**：每 **10 秒**在**每名队员脚下**各放一个 `tspire_firez` marker（位置**只在发动那一刻采样一次**、不跟随），半径 **5**；**2 秒前摇**（`boss/ring5` 12 点 `end_rod` 圈 + 中心光柱 + actionbar）→ **3 秒燃烧**（前 2 秒粒子，整段每 **5 tick** 对 5 格内玩家 `damage 1 in_fire`，共 **12 点**）；状态机 `#QZ` / `#QZ_T`，**`run/battle_win` 调 `quencher_zone_end`** 防残留。**纯粒子**是刻意的（真实火焰会烧掉落物），且 **1.20.1 没有"点燃实体"指令**；同批【灰烬重生】加了**传送回房间正中 + 回 40%（120/300）+ 召 2 只普通烈焰人（不带 `tspire_gear`）+ 粒子与 3 个音效**。**v0.6.32 锈刃督军三机制重做**（新文件 `boss/rusblade` + `rusblade_summon`/`pressure`/`smash`/`smash_go`）：**【重铸】废除 →【威压】**每 **15 秒**（8 格内缓慢 8s、8~64 格虚弱 10s）；**【亡者征召】**每 **12 秒**召 2 只僵尸、**HP < 50% 召 4 只**；**【破甲重击】**每 **28 秒**：先自我缓慢 10 持续 3s，**60 tick 后**再上速度 II + 力量 5s。三机制**各用各的冷却假玩家**（`#RUS_C1`/`#RUS_C2`/`#RUS_C3`）。**v0.6.34 沼泽猎手三机制重做**（新文件 `boss/mirehunter` + `mirehunter_mud`/`mirehunter_javelin`/`mirehunter_muddy`，旧【潮汐位移】/【溺水领域】废除）：**【泥沼】**3 格内持续缓慢 3 秒（逐人 `tspire_mire_in`，走出 4 格复位）；**【标枪投掷】**7 秒 / 半径 5 格 / 中毒 3 秒；**【淤泥附身】**HP ≤ 150 时每 15 秒抗性提升 II 5 秒。**v0.6.36 裂颅者补齐机制 2、3**（新文件 `boss/skullcrusher`）：**【战术突进】**每 15 秒扑到队员身旁 2 格（**不写死原案的"冲刺 8 格"—— 贴墙时会把 Boss 送进墙里窒息**）+ 3 格内 6 点伤害 / 弹开 2 格 / 缓慢 II 3 秒；**【钉刺陷阱】**HP ≤ 210 时每 20 秒以房间中心为基准、四个正方向各 6 格布 4 个（踩中减速 4 秒后一次性消耗）。**v0.6.37 织影巫师补齐机制 2、3**（新文件 `boss/shadowweaver`）：**【尖牙阵】**每 8 秒给**每名队员**脚下摆 3×3 尖牙（原版 `Warmup:20` = 1 秒前摇，**可躲**）；**【暗影帷幕】**HP ≤ 240 一次性：3 只恼鬼 + 隐身 5 秒（**故意不查 `#MOB_CAP`**，避免卡住重试刷屏）。**v0.6.38 钴蓝决斗者补齐机制 2、3**（新文件 `boss/duelist`）：**【崩刃】**HP ≤ 300 一次性，用 `/attribute` 修饰符实现"伤害减半 / 攻速翻倍"（**全项目第一次用 `/attribute`，尚未游戏内实测**，备用写法见代码注释）；**【玛玉灵回响】**被打约 25% 概率反弹，**按掉血分档近似（不是精确的 30%）**。**v0.6.39 删除 6 只已完成 Boss 的占位阶段**：`boss/phase.mcfunction` 的占位与真机制**同阈值双触发**（织影巫师的永久隐身顶掉【暗影帷幕】的 5 秒版、钴蓝决斗者的力量 II 冲掉【崩刃】的伤害减半、`!! PHASE 2 !!` 覆盖真机制 actionbar），已删掉那 6 个占位函数，只保留铭刻者 / 熔核暴君 / 重铸之王三个 —— **v0.6.40 铭刻者补齐机制 2、3**（新文件 `boss/inscriber` + `inscriber_rewrite`/`inscriber_reflect`/`inscriber_strip`（`inscriber_state_end` 已在 v0.6.41 删除））：**【铭刻重写】**每 6 秒随机切 1..4（**免疫** 抗性提升 V / **反弹** 3 格内每 0.5 秒 2 点魔法伤害 / **加速** 速度 II / **吸血** 生命恢复 III，各有 actionbar + 聊天提示；**v0.6.40 时**这三个效果写的是 8 秒，而 8 秒的收尾计时器 `#INS_STATE_T` 会被 6 秒的重掷清零（**死代码**，收尾函数从不执行），实际会重叠 2 秒 —— **v0.6.41 已修正：状态窗口与效果统一成 6 秒、不再重叠**）；**【强化剥离】**HP ≤ 300 一次性 —— **⚠️ 1.20.1 无法移除匠魂 modifier，所以实现成「25 秒虚弱 II + 挖掘疲劳 I」的暂时剥离、完全不碰玩家物品（与原案有实质偏差，已记入待办）**；同批**顺带删除占位阶段 `phase_inscriber`**（与【强化剥离】同阈值），`boss/phase.mcfunction` 现在只剩熔核暴君 / 重铸之王两行。**v0.6.42 熔核暴君补齐机制 2、3**（新文件 `boss/moltenlord` + `moltenlord_pressure`/`moltenlord_overload`/`moltenlord_burn`）：**【凋零剑压】**（被动，每 5 秒，`#MOL_C1`）3 格内**凋零 II 3 秒** + `tspire_hp ≤ 10` 的队员**额外 4 点**魔法伤害 —— **⚠️ 1.20.1 没有"攻击命中"事件，所以这是"每 5 秒一轮的贴身光环"、不是真的攻击附魔（与原案有实质偏差，已记入待办）**；**【熔核爆发】**HP ≤ 350 一次性进入**永久过载**（攻速 +50%，用 `/attribute`，**与崩刃同一个未实测的未知数**；随后每 5 秒自损 30 点，走 `magic` 以免被自身 armor 12 削掉）；同批**顺带删除占位阶段 `phase_moltenlord`**（同阈值），`boss/phase.mcfunction` 现在**只剩重铸之王一行**。**v0.6.43 / v0.6.44 的一批 Boss 侧修复**：**【融合】等三个函数原来因"加载失败"从来没生效过**（`fuse_do` 粒子数量与速度写反、`mirehunter_javelin` 用了不存在的粒子、`quencher_zone_burn` 的 `matches` 逗号列表非法）—— **"点了没反应"先看 `latest.log` 有没有 `Failed to load function`**；**淬火者【灰烬重生】**阈值 20%→**50%（150）**（原来会被一刀打死跳过）；**锈刃督军【亡者征召】**残血 4 只的判定原来被从未初始化的 `#RUS_DOUBLE` 挡住，已改成按 `tspire_boss_hp=..150` 判定；**【破甲重击】**周期 28→**24 秒**、爆发 **速度 II→III**；**沼泽猎手三机制第二次重做**（**【泥沼】**改主动每 12 秒布 3 片、累计 3 秒→缓慢 10 + Boss 速度 II、8 秒免疫；**【标枪投掷】**加 2 秒前摇；**【淤泥附身】→【泥沼现身】**，把 Boss 传到 12 格外玩家**朝房间中心 3 格**处，旧 `mirehunter_muddy` 已删除）—— **⚠️ 但【标枪投掷】当时因 `effect give` 把效果 ID 写成了粒子名 `minecraft:witch` 而加载失败、中毒不生效；该问题已在 v0.6.45 修好**（改回 `minecraft:poison`，并补了"效果 / 粒子混淆"两条离线校验规则）。**这 8 只现在 3/3 机制完成、阶段只由真机制负责；仍缺 1 只 / 2 个机制（重铸之王），它是唯一还在跑占位阶段的 Boss** |
| 楼层推进 / 胜利 / 计分 | ✅ |
| **本局结算界面**（`run/summary`：到达层数 / 通过节点 / 用时 / 剩余金币 / 本局阵亡 + `[ 再来一局 ]`） | ✅ v0.6.19（预览 `/function tspire:test/summary`） |
| **HUD**（bossbar 显示 层数 / 金币 / 生命，§13.7） | ✅ v0.6.19（每 5 秒刷新；不刷命令反馈） |
| 中断恢复（`/reload` 后接着打完进行中的一局，§13.2） | ✅ v0.6.19（`load` 不再清零 `#RUN_STARTED` / `#PICK_STAGE`；`storage` 存档写盘仍⬜） |
| **多人支持**（2 客户端专项修正，§13.11.6） | ✅ v0.6.20（`load/join` 改幂等 `add 0`；全队选完才开局；战斗开局拉全队进房；**中途加入 `run/join_mid`**；新登录自动入队；`run/start` 改用 `#RUN_STARTED` 守卫；自检 `/function tspire:test/mp_check`）+ **v0.6.21 追加：商人货架改"每人一份 + 每人每格限购一次"**（§3.2.1，取代 v0.6.20 "全队共享库存"的旧结论）+ **v0.6.22 追加：三选一改预生成具体候选（取代 v0.6.20 的"点击时现抽"）、`tspire_node_current` 唯一性规则（§3.1.2）、商人 `enter_merchant` 解析失败修复**；战斗拉人选择器加固 —— 验证清单见 `docs/MP-TEST.md` **+ v0.6.23 追加：开局构筑改"每人各掷自己那份方案"（删掉全局 `#LOADOUT`，菜单各看各的，见 §2.1）、随机奖励改每人各骰一次（`as @a[...] run loot give @s`）** |
| 护甲选择的**容器 GUI 版**（§13.6） | ⬜ 1.20.1 做不出只读容器，现为可点击聊天菜单 |
| 房间内部装饰 | ⬜ 只有外壳（墙/门/灯），战斗房是空房间 |
| **待办（v0.6.27 四项，v0.6.62 复核；完整清单见设计文档开头的「待办总表（唯一入口）」）** | ① 开局护甲 2 级材料 → ✅ **已实现（v0.6.28）**（`gen-starter.ps1` 的 `$ARMOR_TIER_OVERRIDE`，仅旅行者 / 黏液套装）；② 工匠「**融合**」：主手 + 副手各持一个材料部件 → 合成高一级部件（两个同级 → 高一级，两个 4 级 → 在 4 级里抽），30 金币、每局限一次（`tspire_fuse_used` 已建好且每局清零）→ ✅ **已实现（v0.6.35，`artisan/fuse` + `fuse_do`，菜单新增 `[融合]`，30 金币、每个工匠节点各限一次，产物与主手同类型、材料取自下一层材料池；「两枚部件必须同级」的前置条件仍未校验，见变更记录 v0.6.35 第 4 条）**；③ 商人出售改为「把物品丢到商人 NPC 处即判定出售」→ ✅ **已实现（v0.6.29，`merchant/sell_drop`）**；④ 商人货架 **10 格 → 15 格**（类型按比例），且售卖工具 / 装备的格位里**必定有 2 个卖镶板盔甲** → ✅ **已实现（v0.6.33，15 格 = 6 部件 + 4 强化水晶 + 2 镶板盔甲（必定）+ 2 匠魂装备 + 1 远古工具，逐人限购标记 `tspire_buy0..14`；见 §3.2.1）**。详见主设计文档 变更记录 v0.6.27 的待办表与 `HANDOFF.md` §7（5）（货架验收与实现说明见 `HANDOFF.md` §7（1））。**Boss 机制进度（v0.6.59 复核）**：**9 只全部 3/3（或更多）完成、再无占位阶段**：淬火者 / 锈刃督军 / 沼泽猎手（**泥沼 / 标枪投掷 / 泥沼现身**）/ 钴蓝决斗者（**死斗 / 破釜 / 决斗嘶吼**）/ 裂颅者（三连射 / 战术突进 / 钉刺陷阱）/ 织影巫师（**唤鬼 14s·5 血 / 尖牙阵 10s / 暗影帷幕 20s 重做；底怪 = 唤魔者**）/ 铭刻者（**时间铭刻 / 铭刻逆流 / 时间书虫 / 遗忘蚀刻**）/ 熔核暴君（**熔火地脉 / 凋零剑压 / 熔核爆发，真火焰**）/ 重铸之王（**再锻 / 金铸壁垒 / 王权征召**）。**血量 v0.6.59 起随人数缩放**：1 层 **200/250/300**、2 层 **350/450/500**、3 层 **500/600/750**（1/2/3+ 人），百分比门用 `#BNOW` vs `#TH_*`；**✅ v0.6.61 / v0.6.62 起全项目已无任何写死血量的门**（熔核暴君的 300/425 已在 v0.6.61 改成 `#TH_60`/`#TH_85`，铭刻者【时间书虫】漏网的 `..375` 已在 v0.6.62 改成 `#TH_HALF`），并新增 validate **§4f** 规则兜住这一类；**❌ 已作废（v0.6.62 复核）：旧版这里写着"仍缺 1 只 / 2 个机制 —— 重铸之王（破甲 / 王权征召），它是唯一还在跑占位阶段的 Boss（`boss/phase_recastking`）"** —— 重铸之王三机制**在 v0.6.57 就已落地**、占位文件**已删除**、`boss/phase.mcfunction` 现在**没有任何活跃逻辑**，**9 只 Boss 全部完成、整个项目再无占位阶段**。**⚠️ 但"已完成"不等于"真的在工作"**：v0.6.43/44 查出**三个函数因加载失败从来没生效**（【融合】/【标枪投掷】/淬火者燃烧伤害），另有**两个机制写了但触发不了**（【灰烬重生】阈值已放宽到 150、【亡者征召】残血 4 只的判定已修）。**新增待办**：① 铭刻者【强化剥离】**未按设计原案实现** —— 1.20.1 无法移除匠魂 modifier，现为"25 秒虚弱 II + 挖掘疲劳 I"的**暂时剥离（不碰玩家物品）**，见 §7.6 与变更记录 v0.6.40 第 3 条；② 熔核暴君【凋零剑压】**未按设计原案实现** —— 1.20.1 没有"攻击命中"事件，现为"每 5 秒一轮的贴身光环"（3 格内凋零 II 3 秒 + 残血额外 4 点），见 §7.6 与变更记录 v0.6.42 第 1 条；③ 沼泽猎手【泥沼】的三片位置是**"结构去重"而非均匀随机**（0..7 基准方向 + 3 / +6，距离固定 8 格），见 §7.6 与变更记录 v0.6.44 第 12 条；④ ~~【标枪投掷】仍未修好~~ → ✅ **v0.6.45 已修好**（`effect give … minecraft:witch` 改回 `minecraft:poison`；v0.6.44 交付时它加载失败、中毒不生效，见变更记录 v0.6.44 第 16 条与 v0.6.45）；⑤ `validate.ps1` 的"粒子数量必须是整数"是**启发式**规则（豁免 dust/block/item 等带额外参数的粒子）；**"效果 / 粒子互相写错"已在 v0.6.45 补上两条规则（`$effectIds` 33 项白名单，两个方向都查，且做过负向验证）**；⑥ **✅ v0.6.47 修掉两条**：`merchant/sell`（点击出售）现在也**按堆叠计价**（改的是生成器 `gen-shops.ps1`，两个模板分别读 `SelectedItem.Count` / `Item.Count`），`boss/duelist_echo` 改成 `data get entity … Health 1`（不再读计分板）；顺带挖出 **`Item.count` 小写 bug**（NBT 标签是 `Count`）—— 它让**"丢下即出售"从 v0.6.29 起一直不付钱也不消耗物品**，且 `validate.ps1` 补了**第 8 条规则**（必须用 `-cmatch`，否则会误报合法的 `Count`）；⑦ **v0.6.48 文档复核提的三条，v0.6.49 结案**：**(a) ✅ 裂颅者【钉刺陷阱】"阶段血量门"** —— 经确认**按 v0.6.48 新规格本就无门**（"每 12 秒触发"，与血量无关），**代码是对的、文档写错了**，§7.6 已删掉"HP ≤ 35%"、`boss/tick` 第 36–38 行注释已改（`boss/phase` 第 19 行仍是旧注释，纯注释），**不补门**；**(b) ✅ 掠夺者原版弩的分支已写进 `tools/gen-gear.ps1`**（按槽位分支），**实跑生成器验证生成物第 4–5 行仍是那两行，重跑不再丢**（同类事故第一次是 v0.6.47 的 `merchant/sell`）；**(c) 🔴 裂颅者【三连射】仍未实现"三支箭 / 45° 扇形"** —— 现在只有 actionbar + `entity.arrow.shoot` 音效 + 力量 II 2 秒，箭来自原版掠夺者的弩 AI，**是否真做等玩家决定**。另：`test/boss_probe` 已从 4 只补齐到 **8 只**（仍不含重铸之王）。三条在主设计文档待办表第 14 / 15 / 16 条；⑧ **v0.6.50 新增**：**(a) ⬜【三连射】的扇形只有 8 个方向桶**（无宏，每桶固定 ±10°，斜向最多偏约 22.5°）；**(b) ⬜ 钴蓝决斗者【死斗】用"每 2 秒贴身光环"近似"命中后流血"**（1.20.1 没有命中事件，**不挨打也会流血**）；**(c) 🔴 `boss/active` 第 34–40 行旧的【疾风连击】块没删** → 决斗者现在实际有**四条**机制在跑，且 `haste` 在 1.20.1 只影响挖掘、不影响攻速（建议删掉）；**(d) ⬜ `tspire_arrow` 没有任何清理者**（靠原版箭自然消失）。见主设计文档待办表第 17 / 18 / 19 条与 §7.6；⑨ **v0.6.51~v0.6.53 新增/结案**：**(a) ✅ v0.6.51** 旧【疾风连击】块已删、`tspire_arrow` 已由 `battle_win` 清理；**(b) ⚠️【死斗】v0.6.51 起默认禁用**（`#CFG_DUELIST_DEATHMATCH=0`，函数保留，改键即恢复）；**(c) 🔴 v0.6.52 的音效锚定只覆盖了 48/73 条** —— `boss/active` 里**六个 Boss 主动技能的音效**（烈焰环 / 三连射 / 唤鬼 / 镜像分身 / 熔火地脉 / 金铸壁垒）**仍在塔原点播放、玩家听不到**，另有 `mirehunter_mud_check` / `skullcrusher_charge_aim` / `phase_recastking` 三条同样未锚定（**共 9 条**，见待办表第 20 条）；**(d) 🔴 "Boss 死后清召唤物"在已部署源码里没找到**（`tick/tower` 仍是 8 行、全项目没有相关清理逻辑 → Boss 召的小怪仍会拖住"全灭"判定，见待办表第 24 条）；**(e) ⬜ 织影巫师"两套尖牙"并存**（原版 + 脚本【尖牙阵】），a/b/c 待玩家决定（待办表第 21 条）；**(f) ✅【破釜】随机性已核实均匀**（`d2=0.5`、`d3=0.333333`，三档各 1/3，**不是 bug**）；**(g) 🔴 织影巫师旧方案残留**：`boss/spawn/shadowweaver` 第 14/16/17 行注释仍写"默认卫道士 / NoAI / 清零 SpellTicks"、第 18 行 NBT 仍带 `SpellTicks:0`、`boss/shadowweaver` 第 4 行仍写"底怪已换成卫道士"（与同文件后文矛盾）。见主设计文档待办表第 20 / 21 / 22 / 23 / 24 条；⑩ **v0.6.54~v0.6.59 新增/变更**：**(a) ⬜ 铭刻者【铭刻逆流】回血是 32 点（规格 30，1.20.1 没宏算不出"当前+30"）**；**(b) ⚠️ 真火焰会烧掉落物**（玩家选了真火焰，这是代价，是否要防请定夺）；**(c) ✅ v0.6.61 #27 已实现：#27 的 300/425 改成分数门**（`#TH_60` = 300/360/450、`#TH_85` = 425/510/637，恒定 60%/85%）；**(d) ✅ v0.6.62 #13·#28 已修：击退 / 外推不再只走主轴** —— 裂颅者【战术突进】、重铸之王【金铸壁垒】都改成 **`tspire_kb_rot` marker + `rotated ~ 0` 的方向载体写法**（任意角度精确、Y 恒为 0），旧 dx/dz 机已删除；**(e) 🔴【死斗】当前默认开启**（`#CFG_DUELIST_DEATHMATCH=1`，如觉得强改回 0；**玩家 v0.6.62 仍未表态，仍挂在唯一入口**）；**(f) ✅ #30 已修（v0.6.60）**：「这件东西我不收。」提示；**(g) ✅ v0.6.61 其余裁决**：#26 真火焰烧掉落物**接受代价** / #21 织影巫师**保留双尖牙当特色** / #25 铭刻逆流**同意 32 点** / #6·#7·#10·#18（机制已废弃）**条目删除 + 残留注释已清**；**(h) ✅ v0.6.62 #31 已修**：`boss/inscriber_bookworm` 的 `scores={tspire_boss_hp=..375}`（750 血时代的硬编码，实际变成 75%/62.5%/50%）已改成 **`#BNOW <= #TH_HALF`**（源码在第 **13** 行，不是文档旧写的第 10 行）；**(i) ✅ v0.6.62 #9 已修**：`validate.ps1` 粒子计数规则**不再整类豁免带额外参数的粒子**（按 `dust` 4 / `dust_color_transition` 7 / `block` 等各 1 跳过前缀，仅 `vibration` 仍豁免）；**(j) ✅ v0.6.62 新增预防规则 §4f**：非 `test/` 下写死 `scores={…tspire_boss_hp=<数字>}` 一律 FAIL（**规则 12 → 13 条**），防住 #27 / #31 这类事故再犯。**待办以文档开头「待办总表（唯一入口）」为准** |
