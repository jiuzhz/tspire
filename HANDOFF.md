# 上下文交接（HANDOFF）

> 给下一个接手的人（或下一次对话的自己）。**先读这一页，再读设计文档。**

---

## 1. 这个项目是什么

《匠魂尖塔》——Minecraft 1.20.1 + 匠魂3 的**纯数据包**肉鸽小游戏。三层塔、杀戮尖塔式节点地图、
敌人穿匠魂装备、玩家用匠魂材料构筑。

**核心约束**：不新增材料、不新增工具、不新增方块。只用匠魂3 原版内容 + 数据包。

---

## 2. 权威文档（唯一真实来源）

| 文档 | 地位 |
| --- | --- |
| `D:\dswork\匠魂尖塔-设计文档-完整整合版.md`（v0.6.62） | ✅ **主设计文档，权威**（多人专项见 §13.11.6；商人货架见 §3.2.1；三选一候选见 §3.3 第一类；**开局构筑每人一份见 §2.1**；**阵亡 / 旁观 / 复活跟队与出图兜底见 §13.11.3**；**节点封门 / 场景只建一次 / 封条可见见 §3.1.2 与 §13.11.6 第（9）条**；**Boss `#FLOOR` 修正见 §7.6 / §13.5**；**v0.6.26 的奖励池权重 / 水晶排除名单 / 工匠与宝箱回血 / Boss 技能提示 / 出怪位置 / `#SRC` 见 §3.3 / §6.3 / §3.1.2 / §7.6 / §7.4**；**v0.6.27 的商人限购清零与货架按节点 / 服务节点锁行 / 工匠共鸣与修复递增价 / Boss 2 秒前摇 / 沼泽猎手削弱 / 移除地图书见 §3.2.1 / §3.1.2 / §3.1.2 + §3.6.1 / §7.6 / §7.6 / §2.4**；**v0.6.29 的二层虚空修复 / 淬火者灰烬重生 / 三选一 `tspire_src` / 商人丢下即出售 / 逐玩家节点提示见 §3.5 / §7.6 / §3.3 第一类 / §3.2.3 / §3.1.2**；**v0.6.30~31 的淬火者燃烧蓄能（纯粒子版）见 §7.6**；**v0.6.32 的路线 bug 根因（`unlock_next_row` 清扫 + 守卫）/ 板斧刃奖励缺失 / 锈刃督军三机制重做见 §3.1.2 / §3.3 第一类 / §7.6**；**v0.6.33 的商人货架 15 格 + 2 格镶板盔甲见 §3.2.1**；**v0.6.34 的沼泽猎手三机制重做见 §7.6**；**v0.6.35 的工匠「融合」见 §3.1.2**；**v0.6.36 的裂颅者【战术突进】/【钉刺陷阱】见 §7.6**；**v0.6.37 的织影巫师【尖牙阵】/【暗影帷幕】见 §7.6**；**v0.6.38 的钴蓝决斗者【崩刃】/【玛玉灵回响】见 §7.6**；**v0.6.39 删除 6 只 Boss 的占位阶段机制（与真机制同阈值双触发）见 §7.6**；**v0.6.40 铭刻者【铭刻重写】/【强化剥离】见 §7.6**；**v0.6.41 修正铭刻者【铭刻重写】状态窗口见 §7.6**；**v0.6.42 熔核暴君【凋零剑压】/【熔核爆发】见 §7.6**；**v0.6.43 出售池修复 / 盔甲部件 / 函数加载失败修复见 §3.2.1 + §3.3 + §13**；**v0.6.44 奖励权重 / 装备池含盔甲 / HUD / Boss 奖励升层 / 沼泽猎手重做见 §3.3 / §3.1.2 / §7.6**；**v0.6.45 修正【标枪投掷】中毒效果 + 效果/粒子混淆校验见 §7.6 + §3.6.5**；**v0.6.46 修复 `/damage` 与 `/attribute` 加载失败 + 血量判定改 NBT + 11 项功能调整见 §3.6.5 / §7.6 / §3.3**；**v0.6.47 `merchant/sell` 堆叠计价（改生成器）/ `duelist_echo` 血量读取 / `Item.count` 大小写 bug 见 §3.2.3 + §7.6 + §3.6.5**；**v0.6.48 泥沼 `as`/`at` 根因 / 血量每 tick 显式同步 / `test/boss_probe` / 裂颅者三机制重做 / 第 2 层 Boss 血量 600→500 / 掠夺者原版弩见 §7.6 + §3.6.5 + §3.6.4 + §13.5 + §7.4**；**v0.6.49 掠夺者的弩写进 `gen-gear.ps1`（重跑不再丢）/ `boss_probe` 覆盖 8 只 / 裂颅者【钉刺陷阱】"阶段血量门"经确认是文档写错（已改、代码不动）/【三连射】"三支箭 / 45° 扇形"尚未实现见 §7.4 + §3.6.4 + §7.6**；**v0.6.50 裂颅者【三连射】真·三支箭（`skullcrusher_volley`，8 桶近似）/ 钴蓝决斗者三机制重做为【死斗】【破釜】【决斗嘶吼】（旧文件已删）/ `validate.ps1` 9 条规则（匠魂效果 id + 正则误伤修正）见 §7.6 + §3.6.5**；**v0.6.51 【死斗】默认禁用（`#CFG_DUELIST_DEATHMATCH=0`）/ 删掉旧【疾风连击】块 / `battle_win` 清 `tspire_arrow` 见 §7.6**；**v0.6.52 ★ 47 处 `playsound` 锚定（`in` 不换坐标）/ Boss 死后清召唤物 / 亡者征召 4→3 / 织影巫师四项 + `shadowweaver_glow` 见 §3.6.5 + §7.6**；**v0.6.53 织影巫师底怪 = 唤魔者 + `kill @e[type=vex,tag=!tspire_mob]` 见 §7.6**；**v0.6.54 奖励池改版（`rewards/special`）+ 商人格 5 部件 + 1 特殊 + 出售补 12 件盔甲 + 破甲重击抗性 + 3 层 1000→750 见 §3.3 / §3.2.1 / §3.2.3 / §7.6 / §13.5**；**v0.6.55 【死斗】重做（默认开启）+ Boss 单挑入口 `test/boss_pick` 见 §7.6 / §3.6.4**；**v0.6.56 铭刻者四项重做见 §7.6**；**v0.6.57 重铸之王三机制 + 熔核暴君三机制重做 + 占位阶段清零见 §7.6**；**v0.6.58 火焰改真方块见 §7.6**；**v0.6.59 Boss 血量随人数缩放 + 百分比门槛分数化（`#BNOW` vs `#TH_*`）+ 开局侧栏清理 + 泥沼 2 秒见 §13.5 / §3.6.5 / §7.6**；**另新增 `docs/TEST-CMDS.md`（全部测试指令）**；**v0.6.60 修 5 个"函数加载失败"（"BOSS 不放技能"的真凶）/ 淬火者【灰烬重生】误触发 / Boss 测试场 `boss_arena_build`+`boss_arena_setup` / 怪物流血真凶 `tconstruct:nahuatl` / 沼泽猎手数值 / 空中箱子 / `validate.ps1` 12 条 + 新增 `checklog.ps1` 见 §3.6.5 + §3.6.4 + §7.6 + §7.3 + §3.2.1**；**v0.6.61 #27 熔核暴君两个绝对值门（300/425）改成随人数缩放的分数门（`#TH_60` 300/360/450、`#TH_85` 425/510/637；用 `#ML_WIDE`/`#ML_BURST` 标志位）/ 玩家裁决 #26 接受真火焰代价 · #21 保留双尖牙 · #25 同意 32 点 · #6·#7·#10·#18 条目删除并清残留注释 见 §7.6 + §13.5 + §3.6.5**；**待办以设计文档开头「待办总表（唯一入口）」为准**） |
| `D:\dswork\tinkers-spire\docs\MP-TEST.md` | ✅ **多人（2 客户端）测试清单** —— 排查多人问题先看它 |
| `D:\dswork\tinkers-spire\docs\VERIFY.md` | ✅ 游戏内验证清单 V1~V7 与结论 |
| `D:\dswork\tinkers-spire\docs\TECH-VERIFIED.md` | ✅ 反编译核验的技术事实 |
| `D:\dswork\tinkers-spire\docs\PARTS.md` | ✅ 全工具槽位/部件对照表（写配置的硬约束） |
| `D:\dswork\forge-roguelike-gdd.md` | ❌ **已作废**（旧《匠魂肉鸽》方案，三幕 18 层 / 120 分钟 / 词条系统） |
| `D:\dswork\forge-roguelike\` | 🟡 旧项目代码，**仅作技术资料参考**，不要在其上继续开发 |

---

## 3. 环境事实

| 项 | 值 |
| --- | --- |
| 测试存档 | `D:\舜\存档\shipin3\.minecraft\versions\1.20.1-Forge\saves\3_12_0_220` |
| 数据包安装位置 | `<存档>\datapacks\tinkers-spire.zip`（当前为空） |
| 实例 mods | 63 个，含 `TConstruct-1.20.1-3.12.0.220.jar`、`Mantle-1.20.1-1.11.117.jar` |
| ⚠️ 干扰项 | 同时装了 `tinkersdevotion-1.1.0.jar` —— 本方案不用它，**测试前建议移除** |
| 解包数据（只读） | `D:\舜\存档\shipin3\TConstruct-1.20.1-3.12.0.220\`（含 `assets/`、`data/`、`.class`） |
| Forge MDK | `D:\forge-1.20.1-47.4.10-mdk`（**仅在 V1/V2 失败需要写模组时才用**） |
| JDK / IDE | `D:\jdk-21_windows-x64_bin`、`D:\IntelliJ IDEA 2026.2.3` |
| 网络 | 出站 HTTPS 被拦截（TLS 返回 000），**不能下载依赖**；Gradle 缓存已预热 |

---

## 4. 已核验的关键技术事实（决定架构）

1. **工具 NBT 权威数据源是 `tic_materials`**（`ListTag<StringTag>`，槽位顺序），`tic_stats` 是派生缓存。
   → 可以用纯命令凭空构造工具。
2. **匠魂自带 `tconstruct:add_tool_data` 战利品函数** —— 原生动态组装工具（随机材料）。
   → **动态组装零代码**，「必须写辅助模组」的旧假设被推翻。
3. **匠魂自带 `tconstruct:mob_equipment` 数据包注册表** —— 指定怪物生成时的匠魂装备。
   ⚠️ **但 V5 实测：它对 `/summon` 生成的怪不生效**（挂在 Forge `MobSpawnEvent.FinalizeSpawn` 上）。
   实际走的是 **`summon` 空手怪 + `loot replace entity @s weapon.mainhand loot <表>`**（V7 通过）。
4. **材料数组长度必须等于工具槽数**，否则多余槽位被**静默跳过**（不报错、面板偏低）。
5. `pack_format` = **15**；材料 tag 注册表在 `data/<ns>/tags/materials/`（不是 `tags/items/`）。
6. 强化水晶 `tconstruct:modifier_crystal` **真实存在**，由强化调配台的「强化提取」或附魔转换产出。

---

## 5. 本次（v0.6.2）对主设计文档做的校正

这三类错误**会直接写进代码**，已全部修正：

| # | 问题 | 修正 |
| --- | --- | --- |
| 1 | **部件构成多处错误**：剑的"绑定结"、匕首的"工具手柄×2"、镰刀的"镰刀头"、板斧的"大板"、长弓的"大板"、旅行者盾牌的"铜+木"、喷流刃的 4 部件 | 全部按 `tool_definitions/*.json` 实测重写，并补**槽数**列 |
| 2 | 材料档位写成「零~五级」，实际**只有 tier 0~4**；"远古"是 `redirect` 别名材料而非档位 | 删除五级；第 3 层改为**三~四级** |
| 3 | `mob_equipment` 材料类型写成 `tconstruct:randomized`（内部类名，注册 ID 是 `tconstruct:random`）；且该注册表本身对 `/summon` 无效（V5） | 改用 `tconstruct:random` + `summon`/`loot replace` 链路 |

---

## 6. 当前代码状态

**已完成**

- `pack.mcmeta`（pack_format 15）、`load`/`tick` 函数标签
- `tspire:load` —— 计分板、`tspire_party` 队伍、gamerule、bossbar
- `tspire:tick` —— 1 秒节拍 + 玩家级 tick
- **塔维度** `tspire:tower`（`piglin_safe:true`，避免猪灵在塔里变僵尸猪灵）+ 锚点 (0,64,0)、三层平台
- **节点地图**：`tools/gen-maps.ps1` 生成 36 份楼层预设 + 按层抽取函数，节点按彩色地砖区分类型
- **遭遇组**：`tools/gen-groups.ps1` 生成 38 组 + 44 个抽取函数 + `roll/d1..d20` 谓词
- **怪物装备**：`tools/gen-gear.ps1` 生成战利品表与 `mobs/equip_f{1,2,3}`（`summon` + `loot replace entity`）
- **战斗奖励**：`tools/gen-rewards.ps1` 生成部件池、强化水晶表、远古/投掷武器表、宝箱三选一
- **三选一（v0.6.18 重做；v0.6.22 已被"预生成具体候选"取代 —— 读下方 v0.6.22 第 2 条）**：宝箱刷在**当前节点 marker** 位置并 `setblock ... minecraft:chest{Lock:"tspire_sealed"}` **锁死**，
  玩家**物理上打不开**（冒险模式也挖不掉）。三个候选照旧按**队里第一名玩家手持工具**抽取
  （`rewards/offer_held` → `offer_held_f<层>`，没有可改造工具时回退 `rewards/part_f<层>`），
  用 `loot replace block ~ ~ ~ container.0|1|2 loot tspire:rewards/part_for/<工具>_f<层>` 填进箱子；
  再由 `offer_parts` 向 `@a[team=tspire_party]` 打印**可点击聊天菜单** `[候选 1] [候选 2] [候选 3]`，
  按钮跑 `rewards/offer_take_0/1/2` → 在宝箱位置跑 `offer_give_0/1/2`，把第 n 格**复制**进该玩家第一个空闲快捷栏格
  （沿用 `merchant/deliver_<n>` / `run/take_<n>` 的 9 步 `store success score #OK` 写法），并置 `tspire_offer=1`。
  **因为箱子是 Lock 的，领取是复制不是取走**：箱子留在原地让队友各领一份，每人凭 `tspire_offer`（`tspire:load` 里声明）只能领一次；
  整箱清空 + 全员 `tspire_offer` 归零都在 `offer_parts` 开头做。
  旧的每 tick 检查 `rewards/check_offer`（`tick/tower` 里的调用）与 `rewards/close_offer` **已删除**。
- **工匠节点**：`map/build_workshop` 摆工匠砧 / 部件制造台 / 强化调配台 / **工作站**（`tconstruct:crafting_station`），外围石砖围墙挂灯；
  `artisan/menu` 弹菜单，**「重铸」已实现**（`artisan/reforge` → item modifier 改手上工具的 `tic_materials`，
  保留强化/升级/耐久，默认 30 金币，生成器 `tools/gen-reforge.ps1`）
- **商人节点**：`tools/gen-shops.ps1` 预生成 24 份货架（3 层 × 8 份），**15 格商品**（v0.6.33 起；此前 10 格）+ 价格 + 特价，
  `merchant/buy/slot0..14` 购买、`merchant/deliver_0..14` 交付、`merchant/sell` 出售
  - **v0.6.21：货架改成"每人一份"，不再全队共享**。见下面"商人（v0.6.21 改为每人一份）"一节。
- **Boss**：9 只 + 按层抽取 + 阶段切换 + 血条
- **推进/胜负**：`run/{floor_start,next_floor,win}` 等
- **开局三选一武器**：`gui/pick_weapon`（聊天栏）+ `run/pick_weapon_{1,2,3}` +
  `run/begin_run`（第一个选完的人负责建塔）；战利品表 `tspire:starter/{sword,dagger,crossbow}`
- **死亡 / 复活**：`tick/player` 用 `deathCount` 计分板抓阵亡 → `party/die`（旁观）→
  `run/battle_win` 调 `party/revive`（战后复活，`#CFG_REVIVE_HP_PERCENT` 默认 25% 血）；
  全队阵亡走 `run/lose`。重生点由 `run/enter_tower` 的 `spawnpoint` 设在塔里
  （**⚠️ v0.6.24：这条已不足以保障**——`/spawnpoint` 在自定义维度上不可靠，见下方 v0.6.24 与「已排除的错误路径」）
- **本局结算界面（v0.6.19 新增）**：`run/win` / `run/lose` 先置 `#RESULT tspire_timer`（1 = 通关 / 0 = 失败）再调 `run/summary`。
  界面 = 金色 `========== 本局结算 ==========` 表头 + 结果行 + **逐人**（`execute as @a[team=tspire_party] run tellraw @s`）的
  到达层数 / 通过节点 / 用时（秒） / 剩余金币 / 本局阵亡次数，末尾一个加粗黄色的可点击 `[ 再来一局 ]`（跑 `/function tspire:run/start`）。
  新增结算计分板 `tspire_time`（`tick/second` 每秒 +1）/ `tspire_nodes`（`map/complete_node` +1）/ `tspire_death_total`（`party/die` +1），
  三个都在 `tspire:load` 声明、`run/reset_player` 里逐人清零；前两个**只在 `#RUN_STARTED == 1` 时累加**。
  预览：`/function tspire:test/summary`（用当前分数打印通关版，不动进度；`test/start_check` 的输出里有按钮）。
  `run/win` 里「（结算界面尚未实现…）」那句占位文案已删除；`run/win` 改为 `execute in tspire:tower run kill ...`，
  并**先清掉残留的 Lock 宝箱方块再杀 marker**（`run/force_start` 同理，且不再设已作废的 `#NODE_COOLDOWN`）。
- **HUD（v0.6.19 重新启用）**：`tick/hud` 重写并**重新挂回 `tick/second`**（此前那行调用因刷屏被注释）。
  每 5 秒一次，且只在 `#RUN_STARTED == 1` 且队里有人时跑；标题 `尖塔 · 第 N 层 · 金币 N · 生命 N/20`，血条值 = 生命（`max 20`）。
  可见性：`tspire:load` / `run/start_run` / `run/win` / `run/lose` 隐藏；`run/begin_run` 显示并**立刻刷一次**（`#TICK_HUD` 预置 4）；
  **`tick/hud` 每次刷新也会 `visible true`** —— 因为 `tspire:load` 会重建 bossbar 并置 `visible false`，不加这一句的话
  中途 `/reload` 回来 HUD 会一直不显示（正好破坏中断恢复），这也是 v0.6.19 修掉的一个边界。
  旧的 `tick/hud_text` 已删除。
- **`/reload` 中断恢复（v0.6.19）**：`tspire:load` 不再清零 `#RUN_STARTED` / `#PICK_STAGE`（`#NODE_COOLDOWN` 行也删了），
  这两个值只在 `run/start_run` / `run/force_start` 里改 —— 所以 `/reload` 不会掐死进行中的一局（§13.2）。
- **多人（2 客户端）专项修正（v0.6.20，设计文档 §13.11.6，验证清单 `docs/MP-TEST.md`）**：
  1. **`load/join` 改成幂等的 `add 0`**：原来是一串 `scoreboard players set @s tspire_phase 0` / `tspire_gold 0`，
     而 `tspire:load` 每次 `/reload` 都会调它 —— 等于**每次 reload 清空所有人的 phase 与金币**（静默掐死一局）。
     现在统一 `scoreboard players add @s <obj> 0`（只物化缺失分数，不动已有进度）；**每局重置仍在 `run/reset_player`**。
  2. **`run/confirm_weapons` 要求全队选完**：把队里 `tspire_wcount != 2` 的人数算进 `#PICK_LEFT`，
     **`#PICK_LEFT == 0` 才 `begin_run`**；否则提示「你的武器选好了，等其他队友选完就开局。」。
     （旧写法 `if score @s tspire_wcount matches 2 run begin_run` 会让**第一个选完的人腰斩全队构筑**。）
  3. **三选一奖励改为按点击者自己的手持工具现抽**：新增 `rewards/offer_roll` + `rewards/offer_roll_f<层>`，
     **以点击者身份**抽取并 `loot give @s`；三个按钮 = 该玩家自己工具的**三个部件槽位组**
     （`loot_tables/rewards/part_for/<工具>_f<层>_<1|2|3>.json`，按 `部件序号 % 3` 拆分，空组**回退整表**，**共 198 张**；
     `#OFFER_SLOT` 1/2/3 选组）。**旧的未拆分 `part_for/<工具>_f<层>.json` 已删除。**
     Lock 宝箱照旧生成、照旧填"第一名玩家"的三组，**现在纯粹是视觉道具**（谁都打不开）。
     （**v0.6.22 这条又被取代**：`offer_roll` 与 198 张拆分表也删了，改成生成期预生成具体候选 —— 见下方 v0.6.22 第 2 条。）
  4. **战斗开始时把队友拉进竞技场**：`run/battle_start` 加
     `execute as @a[team=tspire_party] at @e[tag=tspire_node_current,limit=1] unless entity @s[distance=..8] run tp @s ~ ~ ~2`
     —— 战斗由第一个进房间的人触发，`terrain/lock` 只锁当前房间，慢的队友会被关在走廊里。
     （**v0.6.22 加固**：选择器改成 `@e[tag=tspire_node_current,tag=!tspire_node_reusable,limit=1]` +
     `if entity @s[distance=8..200]`，防残留的服务节点抢走 `limit=1`。）
  5. **中途加入（新增 `run/join_mid` / `run/join_mid_do`）**：`join_mid_do` **先把队伍站位记成 `tspire_joindest` marker，再 `team join`**
     （顺序反了 `@a[team=tspire_party,limit=1]` 可能选中新来的这位）→ phase 5 / `layer = #FLOOR` / `gold = #CFG_START_GOLD` /
     `wcount 2` / 本局统计清零 → 传送到 marker → spawnpoint → 冒险模式 → 发 `tspire:mob_gear/weapon_f<层>` + 四件 `*_f<层>` + 工匠大百科。
  6. **新登录玩家自动入队**：`tick/second` 每秒 `execute as @a[team=!tspire_party,gamemode=!spectator] run function tspire:load/join`
     —— 原来 `load/join` 只在 `/reload` / 开服跑，后来登录的人根本不在 `tspire_party` 里。
  7. **`run/start` 守卫改用 `#RUN_STARTED`**：== 1 时拒绝，并给两个按钮（加入这一局 → `run/join_mid`、强制重开 → `run/force_start`）；
     `phase 5` 检查保留作兜底。旧的 `@s tspire_phase` 守卫在多人下会让**第二个玩家把全队重置**。
  8. **新增自检 `test/mp_check`**：打印 `#PARTY_SIZE` / `#RUN_STARTED` / `#FLOOR` / `#BATTLE_ACTIVE` / `#LOADOUT` / `#PICK_STAGE`，
     逐人一行（phase / layer / gold / wcount / dead / tspire_offer / tspire_service），再列出未入队的非旁观玩家；
     （**v0.6.23**：`#LOADOUT` 已删除，改打**执行者自己**的 `tspire_draft_l`，并加打 `tspire_ov`。）
     已从 `test/start_check` 输出挂上入口。**打印别人的分数要先用 `tag @s add tspire_mp_probe` 记住执行者**
     （`execute as <其他人>` 之后原来的 `@s` 就没了），再 `execute as @a[team=tspire_party] run tellraw @a[tag=tspire_mp_probe] [...]`。
  9. **新增文档 `docs/MP-TEST.md`**：2 客户端测试清单（怎么进第二个人 / 构筑 / 封门 / 三选一 / 商人 / 阵亡复活 / 结算 / reload 与中途加入 / 已知未做项）。
- **商人（v0.6.21 改为每人一份，设计文档 §3.2.1 / §13.11.6）**：用户定案**「每个人的商店不一样，每人每格限购一次」**。
  **这一节取代了 v0.6.20 "全队共享、有限库存"的旧结论**（旧结论当时被列为"未决项"，现已拍板）。
  1. **货架归属搬到玩家身上**：新增 `tspire_shop_f`（这份货架是为哪一层抽的）/ `tspire_shop_l`（**1..8** 货架编号），
     以及 **10 个逐人限购标记 `tspire_buy0`..`tspire_buy9`**，全部在 `tspire:load` 声明。
     全局的 `#SHOP_L` / `#SHOP_F` **不再是货架归属**，只剩生成/调试用途。
  2. **`shop/pick_f<层>` 重写**：不再写 `#SHOP_L`，改为把 **1..8 均匀掷**（沿用既有 `tspire:roll/d8..d1` 谓词链）进 `@s tspire_shop_l`，
     置 `@s tspire_shop_f = <层>`，并把 `@s tspire_buy0..9` 归零。**它不摆货**。
  3. **摆货与菜单拆开**：新增生成的 `shop/f<层>_l<编号>_fill.mcfunction`（= 旧的摆货主体：杀旧 `tspire_shop` marker →
     `~ ~-2 ~` 重召 → `setblock chest{Lock:"tspire_sealed"}` → 填 `container.0..9` → 写 `#PRICE0..9`，**不含菜单**）。
     旧的合并版 `shop/f<层>_l<编号>.mcfunction` **已从生成器输出删除**（无人调用）。
  4. **新增生成的 `merchant/open_own.mcfunction`**：`unless score @s tspire_shop_f = #FLOOR` 就先替这人掷一份，
     再按他自己的货架摆柜台；**它不设执行位置**，调用方要包 `at @e[tag=tspire_node_current,limit=1]`。
  5. **新增生成的 `merchant/open_menu.mcfunction`**：按执行者自己的货架打菜单；`merchant/menu.mcfunction` 只剩一层薄包装
     （`function tspire:merchant/open_menu`），**作为稳定入口保留**。
  6. **`merchant/buy/slot<n>` 三段式**：(a) `@s tspire_buy<n> == 1` → 「这一格你已经买过了（每人每格限购一次）。」；
     (b) 否则 `at @e[tag=tspire_node_current,limit=1] run function tspire:merchant/open_own` **按买主自己的货架重摆**
     —— 保证**箱子内容与 `#PRICE<n>` 都属于点按钮的人**，不串价；(c) 照旧库存/金币检查后交付。
  7. **`merchant/deliver_<n>` 不再清空货架格**（旧写法 `item replace block ~ ~ ~ container.<n> with air`），
     改为 **`scoreboard players set @s tspire_buy<n> 1`**。**"售罄"从此纯粹是玩家自己的状态**，货架格永远不空。
  8. **`map/enter_merchant` 不再用全局 `#SHOP_ROLL` / `tspire_node_stocked` 做库存门禁**：只在 `@s tspire_shop_f != #FLOOR`
     时替进门的人掷货架并摆柜台（**换层自动覆盖**），然后调 `tspire:merchant/menu`；再进同一节点只是重开自己那份没变的菜单。
  9. **新文案键 `alreadyBought`** 写在 `tools/shop-text.json`（UTF-8）。
  10. **`test/shop_demo` 同步更新**（先置 `@s tspire_shop_f 0` 强制重掷 → 在玩家处 `open_own` → 弹 `merchant/menu`）；
      **`test/mp_check`** 逐人一行追加打印 **货架层 / 货架编号 / 第1格已买 / 第2格已买**。
  11. **`docs/MP-TEST.md` §4 已按新行为重写**（别人写的，本文件只引用）。
- **实战（2 客户端）后修四个 bug（v0.6.22，设计文档 §变更记录 / §2.1 / §3.3 第一类 / §3.1.2 / §3.2.1 / §13.11.6）**：
  1. **开局构筑同一部位出现两条一模一样的装备说明**（两个独立原因）：
     (a) `tools/gen-starter.ps1` 对每个部位的 3 个候选**各掷一次**，同一套装能在一格里出现两三次
     （如头盔位两条「旅行者护目镜」）；现在改对套装池做**洗牌排列** `@($ARMOR_SETS | Sort-Object { Get-Random })`，
     **每个部位的三个选项必来自三套不同套装**；
     **⚠️ (a) 已在 v0.6.23 回退** —— 玩家确认"一格里重复出现同一套装"是设计内行为，
     三个选项重新改回**独立随机抽、允许重复**（见下方 v0.6.23 第 2 条）；(b) 的 `#DUP` 守卫**保留**；
     (b) `run/apick_<S>_<T>` 点**已经选过的部位**时既提示「这个部位已经选过了。」**又把整份护甲菜单重发一遍**
     （重发那行只看 `@s tspire_arm<S> matches 1`，而它在"刚选完"与"点了已选项"两种情况下都成立）；
     现在先把该标记**在这次点击之前**的状态存进临时假玩家 `#DUP`，只有 `#DUP == 0` 才重发。`run/wpick_<i>`（武器）同修。
  2. **三选一环节看不到奖励是什么** → 候选改成**生成期预生成的具体物品**：对每个 (手持工具 × 层 × 变体=4)
     烘焙一组确定的三件，每层产出一个 `tspire:rewards/offer_f<1|2|3>`：`#OFFER_SLOT == 0` 打印
     **真实部件名 + 材料名**（带悬停），`== 1/2/3` 给出**与菜单完全一致**的那一件。每人用新计分板
     `@s tspire_ov`（1..4，`rewards/offer_variant` 掷）选自己的变体 → 队友看到的候选组各不相同、
     且各按**自己手持的工具**生成。`offer_parts` 只剩：清旧箱 → 房间正中放 `Lock` 箱当**视觉标志**
     （**不再装东西**）→ 复位 `tspire_offer`/`#OFFER_SLOT` → 逐人掷变体并打印菜单；`offer_take_0/1/2`
     **先提示「已领取」再置标记**。**删除** `offer_held*` / `offer_roll*` / `offer_give_*` / `offer_build`
     与整个 `loot_tables/rewards/part_for/`（**198 张**）；文案在新文件 `tools/offer-text.json`；
     `gen-rewards.ps1` 新增 `$lang` / `Lang` / `ItemName` / `MatName` / `JsonStr` 与 `$OFFER_VARIANTS = 4`。
  3. **打到第三行被传回第二行的工匠节点**（`tspire_node_current` **不唯一**）：修 `map/enter`（开头强制清场）、
     `map/enter_service`（打 tag 前清）、`map/player_check`（**每 tick 无条件**收回可复用节点上的 current）、
     `run/battle_start`（拉人选择器加固成 `tag=!tspire_node_reusable` + `distance=8..200`）。规则见设计文档 §3.1.2。
  4. **第四行商人节点走进去没反应**（`enter_merchant` 第 47 行解析失败 → **整个函数不加载**）：
     `unless score @s tspire_shop_f = #FLOOR` 漏了**源计分板**，改成 `= #FLOOR tspire_timer`；
     `tools/gen-shops.ps1` 的 `Emit-Roll-If-Needed` 同步修。顺手删掉 `enter_merchant` 结尾没人读的
     `tag … add tspire_node_stocked` 死代码与过期头注释。
  5. **`tools/validate.ps1` 新增离线规则（§4b）**：抓 `score <t> <obj> <op> <holder>` 后直接跟
     `if|unless|run`（即**缺源计分板**）→ 直接判失败；**加完当场抓到第二处**（`merchant/open_own`）。
- **玩家复盘 v0.6.22 后的两处修正 + 随机奖励每人各骰一次（v0.6.23，设计文档 §2.1 / §3.1.2 / §3.3 / §13.11.6）**：
  1. **开局构筑改成"每人一份自己的方案"（本次核心）**。旧的 `#LOADOUT` 是**全队共用的假玩家**：
     `starter/pick` 掷一次、`starter/l<k>` 置入，菜单 / 清武器都按它分支 —— 多人下两人看到**同一份选项**。
     现在：**`#LOADOUT` 与 `starter/pick` 已删除**；新增计分板 **`tspire_draft_l`（1..6）**
     （`tspire:load` 声明、`run/reset_player` 清零）；新增生成的 **`starter/roll`** 逐人均匀掷。
     `starter/l<k>` 拆成 **`starter/l<k>_fill`**（只做：杀旧 marker → 重召 → `setblock chest{Lock:...}` → 填 `container.0..16`，
     **没有菜单、不置 `#PICKED`、不碰 `#LOADOUT`**），合并版 `l<k>` 已从生成器输出删除；
     新增生成的 **`starter/own_fill` / `own_armor_menu` / `own_weapon_menu`** 按 `@s tspire_draft_l` 分支
     （**它们不设执行位置，调用方自己包 `at`**）。`run/apick_<S>_<T>` / `run/wpick_<i>` 在 `run/take_<idx>`
     **之前**先 `at @e[tag=tspire_starter,limit=1] run function tspire:starter/own_fill`，
     把那只共享的 `Lock` 箱子**按点击者自己的方案重摆一遍**再复制 —— 这就是"两人从同一只箱子里各拿自己那两套"的关键。
     `start/open_armor_menu` / `open_weapon_menu` 变成 `starter/own_*_menu` 的薄包装；
     `start/enter_draft` = 逐人 `starter/roll` → 用队里第一名的方案摆一次箱子（纯视觉）→ 逐人弹自己的护甲菜单；
     `run/reset_weapons` 改按 `@s tspire_draft_l`；`test/start_check` / `test/mp_check` 改打**执行者自己**的
     `tspire_draft_l`（`mp_check` 另加打印 `tspire_ov`，即三选一的候选组）。
  2. **回退 v0.6.22 的"三个选项必须是三种不同套装"**：`tools/gen-starter.ps1` 回到
     **三个候选各自从套装池独立随机抽**，所以**一格内出现两条相同装备是预期行为**
     （与下面「「三选一」不等于「三种各来一个」」一致，v0.6.22 反而违背了它）。
     **v0.6.22 第 1 条 (b) 的 `#DUP` 守卫仍然有效**（点已选项只提示、不重发菜单），没有回退。
  3. **随机奖励每人各骰一次**：`rewards/battle` 与 `map/enter_chest` 原来是
     `loot give @a[team=tspire_party] loot <表>` —— **只骰一次**，把同一份结果发给所有目标（实测"人人奖励相同"）。
     两处都改成 `execute as @a[team=tspire_party] run loot give @s loot <表>`；`run/join_mid_do` 本来就是 `loot give @s`。
  4. **`rewards/offer_parts` 结尾那条面向全队的广播提示已删除**，三选一界面彻底逐人（每人的菜单行自带说明）。
- **阵亡 / 旁观 / 复活不再把人踢出塔（v0.6.24，设计文档 §13.11.3 / §13.10.1）**：
  玩家实测「死亡时的出生点有问题，为什么直接会回到主世界？死亡旁观时还有复活时需要传送到队友身边，避免出图」。
  **证据**：`latest.log` 里玩家阵亡那一刻维度管线反复在 `tspire:tower => minecraft:overworld` 之间翻转；
  根因是 **`/spawnpoint` 在自定义维度上不可靠**（Mojang 追踪单 **MC-240812**「/spawnpoint is inconsistent」）。
  改动：
  1. **新增 `party/gather.mcfunction`（`tspire:party/gather`）** —— 把**执行者**传到队伍所在处。
     优先级链（临时 marker `tspire_gather_pt` 逐级短路）：① 活着且在塔里的队友
     （`scores={tspire_dead=0},nbt={Dimension:"tspire:tower"}`）→ ② 任何在塔里的队友 →
     ③ `tspire_node_current` → ④ `tspire_anchor`；最后 `tp @s @e[tag=tspire_gather_pt,limit=1]` 并清理。
     **实现要点**：选择器没法简单排除执行者自己，所以先给自己打临时 tag `tspire_gather_self`，
     再用 `tag=!tspire_gather_self` 从队友里挑，收尾移除。
  2. **`party/die`** 在 `gamemode spectator` 之后**紧接着**调 `tspire:party/gather`
     —— 否则 `doImmediateRespawn` 先把人塞到（可能等于主世界世界出生点的）重生点，旁观者看不到战况。
  3. **`party/revive_self`** 结尾调 `tspire:party/gather` —— 复活落在**队友身边**，不是过期 / 塔外的重生点。
  4. **`tick/player` 出图兜底**：`#RUN_STARTED == 1` 且 `phase 5` 且 `unless entity @s[nbt={Dimension:"tspire:tower"}]`
     → 立刻 `tspire:party/gather`，**下一 tick 拉回，绝不把人踢出这张图**。
  5. **`tick/second` 每秒两件事**：(a) **重生点保活**：按当前层逐人重设
     `in tspire:tower ... spawnpoint @s 0 64 10` / `0 96 10` / `0 128 10`（重登 / 换维度会丢）；
     (b) **旁观者跟队**：`as @a[team=tspire_party,scores={tspire_dead=1..}] ... unless entity @a[team=tspire_party,scores={tspire_dead=0},nbt={Dimension:"tspire:tower"},distance=..16] run tspire:party/gather`
     —— 身边 16 格内没有活队友的旁观者被挪到队伍身边。
  6. **`docs/MP-TEST.md` §5 已按新行为重写**（别人写的，本文件只引用）。
  > 注：`scores={tspire_dead=0}` 要求该分数**已经存在**，它由 `tspire:load/join`
  > （`scoreboard players add @s tspire_dead 0`）与 `run/reset_player` 物化。
- **节点封门 / 场景只建一次 / 封条可见（v0.6.25，设计文档 §3.1.2 / §3.5.5 / §3.5.7 / §13.11.6 第（9）条）**：
  1. **服务节点的场景只生成一次**：新增节点 tag **`tspire_node_built`**。
     `map/enter_artisan` 用 `execute unless entity @e[tag=tspire_node_current,tag=tspire_node_built] at @e[tag=tspire_node_current] run function tspire:map/build_workshop`
     守卫 `map/build_workshop`，然后 `tag @e[tag=tspire_node_current] add tspire_node_built`；
     商人的柜面（讲台 + 石砖墩 + 灯笼 + **商人村民**）从 `map/enter_merchant` 抽成新函数
     **`map/build_merchant_stall`**，用同样方式守卫 —— **重进不再重摆方块、村民不再被杀掉重召**
     （玩家反馈：「每个节点生成相应的场景方块后就不再重新生成了，避免玩家多次到达监测点，导致方块刷新」）。
     tag 挂在该节点 marker 上，`map/build_floor` 重建整层会清 marker，**所以每层都是全新的"建一次"**。
  2. **不能回头**：`map/refresh_doors` **重写** —— 只开 `tspire_node_avail` 与 `tspire_node_current`，
     **其余全封，包括 `tspire_node_done`**（旧实现把已完成节点显式留开，这正是玩家能走回去的原因）。
  3. **`map/complete_node` 故意不摘 `tspire_node_current`**：结算时玩家还站在房间里，
     立刻摘 tag 会让 `refresh_doors` 把人**关在屋内**。保留 current 让北门开着，
     等玩家踏进下一个节点时由 `map/enter` 统一清掉旧 current，**那时旧房间才彻底封死**。
     （`complete_node` 里那句 `remove tspire_node_current` 的注释写着"不要恢复这一行"。）
  4. **封条改成可见的石头**：`tools/geometry.json` 新增 **`"sealBlock": "minecraft:polished_blackstone_bricks"`**，
     `tools/gen-terrain.ps1` 读进 `$sealBlock`，生成的 `map/seal_doors.mcfunction` 填它（不再是 `barrier`），
     `map/unseal_doors` 照旧填空气。**`terrain/lock` / `terrain/unlock`（临时战斗封锁）故意继续用 `barrier`**，
     否则打过的房间会看起来像被永久封死。
- **商人两个 bug（v0.6.25，设计文档 §3.2.1 / §3.2.3 / §13.11.6 第（6）条）**：
  1. **强化水晶卖不掉**：`tconstruct:modifier_crystal` **不在任何收购清单里**，卖它只打印
     「主手没有可出售的匠魂物品。」。新增可调参数 **`#CFG_SELL_CRYSTAL`（默认 12，在 `config/defaults.mcfunction`）**，
     生成的 `merchant/sell.mcfunction` 补一条对应规则；`tools/shop-text.json` 的 `sellHover`
     现在写明「强化水晶 12 金币」。
  2. **两个人买到的都是房主那份货**：`merchant/buy/slotN` 原来用
     `at @e[tag=tspire_node_current,limit=1]` 给 `tspire:merchant/open_own` 定位 ——
     这个 tag 在**可复用服务节点上是短暂的**（`map/player_check` 每 tick 收掉），
     于是"按买主自己的货架重摆"**静默没执行**，买家复制的就是共享箱里剩下的那份货
     （= 最后走进来的那个人那份）。改成**以买主本人身份、不带位置前缀**：
     `execute if score @s tspire_buy<N> matches 0 run function tspire:merchant/open_own`
     （`merchant/deliver_<n>` 本来就会重新解析 marker）。改在 `tools/gen-shops.ps1`。
- **Boss 层数错乱 + Boss 房刷普通怪（v0.6.25 重大，设计文档 §7.6 / §13.5）**：
  玩家反馈「我在打一层的boss为什么出现的3层的boss？而且还会刷出普通怪物节点的怪物」。
  **根因**：`tools/gen-groups.ps1` 与 **9 个手写 `boss/spawn/*.mcfunction` 里的 8 个**都含
  `scoreboard players set #FLOOR tspire_timer <N>`，而 **N 写错了** —— 第 2 层 `duelist` 写 3、
  第 1 层 `rusblade` / `mirehunter` 写 2（只有 `quencher` 本来就没有这一行）。
  于是第 1 层打到 `rusblade` / `mirehunter` 时 `#FLOOR` 中途变 2 → 击杀后 `run/floor_advance` +1 得 3 →
  **`run/next_floor` 直接建第 3 层、把全队传到 Y=128**；`mobs/equip` 读 `#FLOOR`，所以 Boss 装备档位也错了。
  修法：**8 个 Boss 文件删掉那一行**；`tools/gen-groups.ps1` **不再为怪物组输出这一行**；
  `tools/validate.ps1` **新增规则 §4c**：`mobs/` 与 `boss/` 下**禁止写 `#FLOOR`**，
  只有 `run/start_run` 与 `run/floor_advance` 可以（通过时打印 `ok  mobs/ and boss/ never write #FLOOR`）。
  另一半：`run/battle_start` 对 **Boss 节点跳过 `tspire:mobs/spawn_batch`**
  （`execute unless entity @e[tag=tspire_node_current,tag=tspire_type_boss] run function …`），
  Boss 房不再叠一整组普通编队；Boss 的小怪仍由 `boss/active` 自己召唤。
- **实体上限**：`mobs/cap`（算 `#MOB_CAP` / `#MOB_COUNT`）+ `mobs/spawn_batch`（出怪闸门），
  Boss 的召唤小怪也全部加了闸门，读 `#CFG_MOB_CAP_BASE` / `#CFG_MOB_CAP_PER_PLAYER`
- **八项玩家反馈的机制 / 数值调整（v0.6.26，设计文档 §变更记录 / §2.3 / §2.4 / §3.1.2 / §3.3 / §3.6 / §6.3 / §7.4 / §7.6）**：
  1. **强化水晶池删掉"采掘类"强化（8 个）**：塔里没有矿，`smelting` / `haste` / `blasting` /
     `lightspeed` / `hydraulic` / `silky` / `exchanging` / `autosmelt` 抽到就是死奖励。
     `tools/gen-rewards.ps1` 新增 `$modExcluded` 过滤，水晶表 **97 → 89 条**，
     打印 `crystal modifiers after exclusion: slotless=8 upgrade=38 defense=10 ability=33`，
     **任何分类被滤空直接 throw**。**`luck` 刻意保留**（它还带抢夺）。
  2. **战斗奖励池重新平衡**：`battle_random_f<1|2|3>`（`rolls: 2`）权重改为
     **部件 22 / 修补 16 / 水晶 38 / 装备 8 / 金苹果 15（新增）/ 远古 0.5 / 投掷 0.5**，合计 100。
     因为同时删了没用的采掘水晶，**抽到"有用水晶"的实际概率提升远大于 30→38 本身**。
  3. **Boss 技能提示强化**：`boss/active.mcfunction` 重写 —— 每个技能都给
     **(a) actionbar 加粗大字点名技能**（各 Boss 不同颜色）**(b) 专属音效**（`master` 声道），
     四个**直接伤害 / 负面效果**的技能再加 **(c) 一条聊天栏操作提示**
     （淬火者烈焰环「先退开」/ 沼泽猎手毒标枪「别站桩」/ 铭刻者镜像分身「分辩分身」/ 熔核暴君熔火地脉「换位」）。
     actionbar 覆盖不刷屏，聊天栏每冷却周期只发一次。
  4. **怪物生成位置改到房间北侧（玩家正前方）**：`tools/gen-groups.ps1` 的 `Get-Pos`
     由 `$z = 1 + floor(Index/3)*2`（**+Z = 南 = 玩家背后**）改成 `$z = -1 - floor(Index/3)*2`
     —— 玩家南门进、往 −Z 走，现在编队**迎面**出现在前方。
  5. **三选一不再只判定手持武器**：`tools/gen-rewards.ps1` 新增 **Pass A**，按优先级挑**一件**来源物品写进假玩家 **`#SRC`**
     —— **主手 → 胸甲(102) → 护腿(101) → 靴子(100) → 头盔(103)**，`0` = 身上没有可改造装备 → 回退通用材料池。
     菜单 / 发奖块门禁改为 `if score @s tspire_ov matches <变体> if score #SRC tspire_timer matches <工具编号>`。
     **是"按优先级选一件"不是并集**：手上有可改造工具时仍优先手上那把。
     于是**只穿护甲、空手的玩家也能拿到护甲部件**。
  6. **工匠节点回血调整**：旧版 `instant_health` amplifier 4 = `4<<4` = **64 点 = 必满血**（玩家反馈"回血太高"）。
     现在 **进节点免费回 45%（9 点）** + 菜单里花 **`#CFG_ARTISAN_HEAL_PAID_COST`（默认 25 金币）再回 25%（5 点）**；
     旧键 **`#CFG_ARTISAN_HEAL_AMPLIFIER` 已删除**。新增 **`artisan/heal_snapshot` / `heal_free` / `heal_paid`**，
     `map/enter_artisan` 逐人 snapshot + free，`artisan/menu` 多一个 `[回血]` 按钮。
     **档位原理**：`instant_health` 只有 `4<<amplifier` = **4/8/16/32/64** 这几档，做不出"正好 9"，
     所以是**两段拼**：amplifier 1（+8）+ amplifier 0（+4）再 `damage @s 3 minecraft:magic`（−3）= 净 +1 → 合计 +9；
     因此有 **±1 容差**（`#HP0` 9~11 时只有 +8，差 1 点）。付费档 amplifier 1（+8）再 `damage 3` = 正好 +5。
     **吸收会挡掉那 3 点修正伤害**，导致修正式回血偏多（已知副作用）。付费档**先扣钱再回血**。
  7. **弓补上"自容箭袋"**：`tconstruct:bulk_quiver`（`modifier.tconstruct.bulk_quiver` = 自容箭袋）
     现在加在**每一个发给玩家的弓 / 弩**上，走物品 NBT `tic_modifiers:[{name:"tconstruct:bulk_quiver",level:1}]`：
     `tools/gen-starter.ps1` 新增 `Quiver-Nbt` 助手；`tools/gen-shops.ps1` 同一个助手（两个装备分支都用）；
     `tools/gen-gear.ps1` 的 `New-Entry` 追加一个 `minecraft:set_nbt` 物品函数
     （因为 `mob_gear/weapon_f*` 也被战斗奖励 / 宝箱节点复用）。**`run/give_kit` 新增 `minecraft:arrow` ×32**。
     原因：`bulk_quiver` 带 **`check_standard_arrows: true`**，**先吃玩家背包里的箭** ——
     不发箭等于远程武器从第一秒就是废铁。**没有**预填箭袋内部存储（那个 NBT 键在模组数据文件里没暴露）。
  8. **宝箱节点新增回血**：`map/enter_chest` 除发装备外，还调新增的 **`map/chest_heal`**
     （`effect give @s instant_health 1 0 true` = **正好 4 点 = 20%**），用
     `execute as @a[team=tspire_party] ...` **逐人结算**；聊天栏补上「（并恢复 20% 生命）」。
  9. **过程记录**：改 `tools/gen-rewards.ps1` 时**又把中文写进了 `.ps1` 注释**，PS 5.1 按 ANSI 读无 BOM 脚本 →
     注释 mojibake 吞掉下一行 → 解析死在下一行（`Missing ')' in method call`）。
     由 `tools/validate.ps1` 既有的"`.ps1` 纯 ASCII"检查抓到（**13 行非 ASCII**）。**这是第三次，见下方「已排除的错误路径」。**
- **三个 bug 根因修复 + 六项新机制（v0.6.27，设计文档 §变更记录 / §2.4 / §3.1.2 / §3.2.1 / §3.2.2 / §3.2.3 / §3.6.1 / §7.4 / §7.6）**：
  1. **bug「商人买不了东西」= 上一局的限购标记被带进新局**（**A**）。`latest.log` 在 23:41:11/12/16/30/44
     反复出现同样两行：`这一格你已经买过了（每人每格限购一次）。` + `已执行函数tspire:merchant/buy/slot5中的9条命令`
     —— **只有 9 条命令 = 拒绝分支**（真买成功是 78 条）。两个原因叠加：
     (a) `run/reset_player` **从没清** `tspire_buy0..9`；(b) `map/enter_merchant` 只在 `@s tspire_shop_f != #FLOOR`
     时重抽货架，**新一局还在第 1 层时这个条件为假** → 既不重抽、也就不清标记。
     修法：**`run/reset_player` 现在清** `tspire_shop_f` / `tspire_shop_l` / **`tspire_shop_node`** / `tspire_buy0..9`，
     并顺带清新增的 `tspire_fuse_used` / `tspire_resonate_used` / `tspire_repairs` / `tspire_repair_cost`；
     **`map/enter_merchant` 改用「当前节点」当货架钥匙** —— 把节点 marker 的 z 坐标
     （`data get entity @e[tag=tspire_node_current,limit=1] Pos[2] 1`）存进新计分板 **`@s tspire_shop_node`**，
     只有它变化才重抽（`pick_f<层>` 重抽时会一并清空 `tspire_buy0..9`）。
     **一行只走一个节点，所以 z 就足以当节点身份。** 效果：走进**另一个**商人节点 = 全新货架；
     回到**同一个**节点 = 货架 / 价格 / 限购状态都不变。
  2. **bug「只剩一滴血进工匠 / 宝箱节点会死」= 共享假玩家 `#HP0` 被队友血量覆盖**（**B**）。
     旧 `map/enter_artisan` 先对全队跑一圈 `artisan/heal_snapshot`、**再**跑一圈 `artisan/heal_free`，
     第二圈开始时 `#HP0` 里已是**最后一名队友**的血量 → 低血玩家被判成"血够多" → **一点血都不回** →
     一个中毒 / 凋零 tick 就带走他。修法：**snapshot 折进 `artisan/heal_free` 开头**
     （`scoreboard players operation #HP0 tspire_timer = @s tspire_hp`），`enter_artisan` 只留**一圈**
     `execute as @a[team=tspire_party] run function tspire:artisan/heal_free`；
     **`artisan/heal_snapshot.mcfunction` 已删除**。
     **教训：共享假玩家只能放"全队同一个值"，逐人的中间量一律不能放上去。**
  3. **bug「走过宝箱 / 商人 / 工匠节点后同行其他房间还能进去」= 服务节点从没锁行**（**C**）。
     只有普通节点跑 `map/node_begin`（负责锁本行），服务节点走 `map/enter_service`，**只贴了 `tspire_node_current`**，
     于是同行其余房间仍是 `tspire_node_avail`、门开着 —— 表现就是"封口石没生效"。
     修法：`map/enter_service` 结尾补
     `execute as @e[tag=tspire_node_current,limit=1] unless entity @s[tag=tspire_node_done] run function tspire:map/node_begin`
     —— **第一次进服务节点就按普通节点锁行**（幂等；已 `done` 不重复）。
  4. **战斗房怪物再往北 2 格**（**D**）：`tools/gen-groups.ps1` 的 `Get-Pos` 由
     `$z = -1 - floor(Index/3)*2` 改为 **`$z = -3 - floor(Index/3)*2`**。
  5. **删除开局"地图书"**（**E**）：`run/give_kit` **不再发 `tconstruct:encyclopedia`**（玩家叫它"地图书"，说没用）。
     牛排 ×64、箭 ×32 照发。**遗留漏改**：`run/give_kit` 末尾的 tellraw 宣告行里**仍写着「工匠大百科 ×1」**，需要清掉。
     > **⚠️ v0.6.28 更正（本条已作废）**：玩家澄清要删的是**《尖塔地图》成书**，不是工匠大百科。
     > `run/give_kit` 现在**照常发 `tconstruct:encyclopedia`**（代码注释写着"上一版误删了工匠大百科"），
     > 末尾 tellraw 也**本来就是对的**（不是漏改）。见本文件 §7 (6)。
  6. **沼泽猎手削弱**（**F**）：`boss/active` 里【毒标枪】半径 **12 → 6**、中毒 **5s → 3s**，
     actionbar 预告与聊天栏提示都改成"**6 格**内"。
  7. **商人讲台旁的普通箱子**（**G**）：`map/build_merchant_stall` 现在还会
     `setblock ~-2 ~ ~-2 minecraft:chest` —— 一只**不锁、谁都能开**的箱子，方便两名玩家互换装备
     （讲台下那只 `Lock` 商品箱照旧打不开，两者是两回事）。
  8. **工匠「共鸣」**（**H**）：新增 `artisan/resonate.mcfunction` + 菜单 `[共鸣]` 按钮 ——
     花 **30 金币**、**每局限一次**（`@s tspire_resonate_used`），`loot give @s loot tspire:rewards/crystal`
     给 **1 枚随机强化水晶**（池子沿用 v0.6.26 已剔除采掘类的那张表）。钱不够 / 本局已用过都会提示且**不扣钱**。
  9. **工匠「修复」三项调整**（**I**）：`artisan/repair` + `repair_do` + **新增 `artisan/repair_cost`**：
     (a) 范围由 6 个装备槽扩大到**整个物品栏**（`item modify entity @s container.0..35 tspire:repair`，**备用工具也修**）；
     (b) 每次修复**额外给 32 支箭**；(c) 价格改成**递增**：基础 `#CFG_REPAIR_COST`（15）+
     每修一次 `#CFG_REPAIR_COST_STEP`（**新增配置键，默认 5**），**本局内累加**。
     因为 1.20.1 **没有宏、`tellraw` 又读不了运算结果**，本价必须先落到计分板：
     新增 **`@s tspire_repair_cost`**（本价）与 **`@s tspire_repairs`**（本局已修次数），
     **菜单显示 / 扣钱 / 金币不足提示都读 `tspire_repair_cost`**。
 10. **Boss 技能 2 秒前摇**（**J**）：`boss/active.mcfunction` **重写** —— **每个技能**在触发阈值 `T` 之前
     都开一个 **40 tick（2 秒）窗口 `T-40..T-1`**，窗口内 (a) actionbar 打 `⚠ 【技能名】准备中 —— …`，
     (b) **每 tick** 给 Boss `minecraft:slowness`（3 秒，amplifier 2），
     (c) 用 **4 个 `minecraft:end_rod` 粒子**在东西南北四点画出技能半径（`~±r ~1 ~` / `~ ~1 ~±r`）。
     到 `T` 时原有效果照旧触发（自带 actionbar + 音效，四个危险技能另发聊天栏提示）。
     **有环的半径**：淬火者 8、沼泽猎手 6、铭刻者 20、熔核暴君 6；
     **自身增益 / 召唤类（锈刃督军 / 钴蓝决斗者 / 裂颅者 / 织影巫师 / 重铸之王）没有环**，只有预告 + 减速。
     窗口与触发阈值都是**写死的 tick 数**（没有宏），**改冷却必须同步改窗口**。
 11. **过程记录**（**K**）：`tools/gen-groups.ps1` 里**又**把中文写进 `.ps1` 注释（**第四次**），
     仍由 `validate.ps1` 的"纯 ASCII"检查抓到；另外得到一条**新教训**：
     **`latest.log` 是 GBK / ANSI 编码**，按 UTF-8 读全是乱码 —— 见下方「已排除的错误路径」。
 12. **`artisan/menu.mcfunction` 的 `[重铸]` 入口已暂时隐藏**（需求方要把它挪到别的模块）：
     功能与代码全在（`artisan/reforge*`、`tools/gen-reforge.ps1`、`item_modifiers/reforge/*`），
     只是菜单里不再挂按钮。**注意**：设计文档 §3.1.3 描述的仍是重铸的实际行为。
- **二层初始房间背后的虚空 + 四项修正（v0.6.29，设计文档 §3.5 / §7.6 / §3.3 第一类 / §3.2.3 / §3.1.2）**：
  1. **二层一进图，出生点背后是虚空（根因）**：出生 / 构筑点在 **z = +10**（`run/enter_tower`），
     而旧公式 `$southEdge = rowSpacing - roomWall` = 24 - 8 = **12** —— 出生点**落在大厅之外**，
     地板与岩体到 z=12 就收口，玩家背后没有实体方块。修法：`tools/geometry.json` 新增
     **`southPad: 16`**（唯一开关），`$southEdge = rowSpacing - roomWall + southPad` = **32**；
     大厅**地板 / 岩体 / 开挖**全部向南延到 z=32；`map/build_hall` 再补一堵
     **2 格厚的 `deepslate` 南墙**（z=33..34）；forceload 目标范围扩到 **`-48 -416 48 32`**
     （写进 `tools/geometry-forceload.txt`）。
     ⚠️ **待对账**：`run/start_run` / `map/clear_all` / `test/map_demo` 里**手写的三处 forceload 仍是
     `-48 -448 48 16`**（南边界比目标少 16 格），改其一要三处一起改。
  2. **淬火者【灰烬重生】实现（设计文档 §7.6 第三机制）**：新增 `health` 判据计分板 **`tspire_boss_hp`**；
     `boss/spawn/quencher` 生成时开始跟踪它并清 `#QUENCH_REV`；`boss/tick` 在
     **HP ≤ 60（= max_health 300 的 20%）且未复活过**时调 **`boss/quencher_rebirth`**。
     **1.20.1 拦不住实体死亡（没有死亡事件、也阻止不了实体消失），所以这是「濒死触发」不是「死亡触发」**——
     正常一刀砍不出 60 点，表现仍是"第一次快被打死时复活"。**这个取舍是刻意的。**
  3. **三选一奖励来源重构（新计分板 `tspire_src`）**：`tools/gen-rewards.ps1` 的 Pass A 优先级改为
     **主手 → 副手（槽 -106）→ 胸甲 102 → 护腿 101 → 靴子 100 → 头盔 103**；
     并在**菜单那一趟（`#OFFER_SLOT == 0`）**把编号复制进 `@s tspire_src`，
     **发奖块只读 `@s tspire_src`**。原因：旧写法在**点击那一刻**重判手持物，
     于是"看菜单时拿板斧、点按钮前换别的"会发错部件（实测：板斧菜单发出手斧刃）。
  4. **商人「丢下即出售」**：新增生成的 **`merchant/sell_drop.mcfunction`**（价格表与 `merchant/sell` 相同），
     由 `tick/second` 对**商人 NPC 4 格内**的物品实体调用；按**堆叠数量**把钱付给 **16 格内最近的那名玩家**，
     然后删除该实体。**取舍要记住**：**把匠魂工具丢在商人旁边想交给队友 = 会被当成出售**；
     交换装备请用商人房间里的普通箱子（`~-2 ~ ~-2`）。
  5. **节点提示改成逐玩家**：`map/enter_artisan` / `map/enter_merchant` 的进入提示与音效
     由 `@a[team=tspire_party]` 改成 **`@s`** —— 只有触发节点的那名玩家看到 / 听到。
- **淬火者两项（v0.6.30 / v0.6.31，设计文档 §7.6）**：
  1. **【燃烧蓄能】（玩家指定的新机制，纯粒子版）**：每 **10 秒**（`boss/tick` 的 `#QUENCH_CD` = 200 tick）
     发动一次，**在每名队员脚下各放一个 `tspire_firez` marker**（位置**只在发动那一刻采样一次**，
     之后玩家跑开不跟随），半径 **5**。**2 秒前摇**（`boss/ring5` 的 **12 点 `end_rod` 粒子环**
     + 中心蓄能光柱 + actionbar 警告）→ **3 秒燃烧**（前 2 秒火焰 / 岩浆 / 烟粒子，
     整段 3 秒每 **5 tick** 对 5 格内玩家 `damage 1 minecraft:in_fire`，**共 12 点**）。
     状态机 `#QZ` / `#QZ_T` 在 `boss/quencher_zone`；新函数
     `boss/quencher_charge` / `quencher_zone` / `ring5` / `quencher_zone_ignite` /
     `quencher_zone_burn` / `quencher_zone_end`。**`run/battle_win` 会调 `quencher_zone_end`**，
     Boss 中途死亡不会留下火焰/卡死状态。
     **它是纯粒子版（玩家明确要求不要真实火焰方块版本，免得烧掉掉落物）**；
     **1.20.1 没有"点燃实体"的指令**，所以"燃烧" = 粒子 + 定期伤害，玩家**不会真的着火**。
     （`boss/quencher_charge` 的旧头注释仍写着"铺真实火焰"，**以设计文档为准**。）
  2. **v0.6.31 两处加强**：燃烧蓄能**改成覆盖全队**（不再只锁最近的一名玩家）、粒子数上调
     （前摇圈 8 → **12 点**）；【灰烬重生】表现强化 —— **传送到房间正中**、回 **40%（120/300）**、
     召 **2 只普通烈焰人**（**不带 `tspire_gear`**）、补粒子与 **3 个音效**。
- **三条根因 / 重做（v0.6.32，设计文档 §3.1.2 / §3.3 第一类 / §7.6）**：
  1. **路线 bug 根因：`map/unlock_next_row` 扫描的是"所有 `tspire_node_done` 节点"**，
     于是一个**旧节点**会**反复解锁它下一行**，把 `map/node_begin` 刚锁掉的**同行兄弟房间又开回来**
     （表现 = 封口石没生效）。**证词**：`/function tspire:test/door_check` 在第 2 行打完宝箱节点后显示
     同行其余房间仍是 `avail`、门是空气，而所有 `locked` 房间都正确封死。
     **修法（都在 `tools/gen-terrain.ps1`）**：(a) `unlock_next_row` 开头**清扫** —— 对已有 done 的每一行
     （1..16）把该行剩余 `avail` 打回 `locked` 并 `remove tspire_node_avail`；
     (b) **每条解锁规则加守卫 `unless 该行已有 done/current 节点`**。
     **`test/door_check` / `test/door_node` 从此是路线问题的标准取证手段**（打印 40 格内每个节点的
     坐标 / tag / 南北门真实方块）。
  2. **板斧刃奖励缺失（根因）**：`tools/gen-rewards.ps1` 的 `$partDefs` 是**手写的 10 项表**，
     漏了 `pick_head` / `hammer_head` / `broad_axe_head` / `adze_head` / `large_plate`
     —— 于是**用到这些部件的工具永远拿不到自己的核心部件**（最典型的就是板斧的刃）。
     已补上这 5 项（`stat` 均 `tconstruct:head`）；`part_f1.json` **131 → 196 条**，
     `broad_axe_head` 现在确实在里面。**这是一类 bug：手维护的部件表会静默漏项。**
  3. **锈刃督军三机制重做（玩家指定）**，新文件 `boss/rusblade`（由 `boss/tick` 每 tick 调用）
     + `boss/rusblade_summon` / `rusblade_pressure` / `rusblade_smash` / `rusblade_smash_go`：
     **【重铸】废除**，换成 **【威压】** 每 **15 秒**（8 格内 **缓慢 8 秒**，8~64 格 **虚弱 10 秒**）；
     **【亡者征召】** 每 **12 秒**召 2 只僵尸，**HP < 50%（≤150/300）召 4 只**；
     **【破甲重击】** 每 **28 秒** —— 先给自己 **缓慢 10 持续 3 秒**，**60 tick 后**再上 **速度 II + 力量 5 秒**。
     三个机制**各有一个冷却假玩家**（`#RUS_C1` / `#RUS_C2` / `#RUS_C3`），
     第二拍另用 `#RUS_SMASH` / `#RUS_SMASH_T`；`boss/spawn/rusblade` 现在跟踪 `tspire_boss_hp`
     并清零这些标记；`boss/active` 里**旧的锈刃督军三机制已删除**。
- **v0.6.33 ~ v0.6.39（设计文档 §变更记录 / §3.2.1 / §3.1.2 / §7.6）**：
  1. **v0.6.33 商人货架 15 格**：`$SHOP_PART_COUNT` 6 / `$SHOP_CRYSTAL_COUNT` 4 / **`$SHOP_PLATE_COUNT` 2**（`$PLATE_ITEMS`，镶板套装，**必定 2 格**）→ **15 格 = 6 部件 + 4 水晶 + 2 镶板盔甲 + 2 匠魂装备 + 1 远古**；
     逐人限购标记扩到 **`tspire_buy0..tspire_buy14`**（`load.mcfunction` 新增 `buy10..14`，`shop/pick_f*` 与 `run/reset_player` 一并清零）。
  2. **v0.6.34 沼泽猎手三机制重做**：新文件 `boss/mirehunter` + `mirehunter_mud` / `mirehunter_javelin` / `mirehunter_muddy`；
     **【潮汐位移】→【泥沼】**（3 格内缓慢 3 秒、逐人 `tspire_mire_in`、走出 4 格复位）、**【标枪投掷】**（7 秒 / 5 格 / 中毒 3 秒）、**【溺水领域】→【淤泥附身】**（HP ≤ 150 每 15 秒抗性 II 5 秒）；`boss/active` 里旧的两条已删。
  3. **v0.6.35 工匠节点「融合」**：菜单新增 `[融合]`，新函数 `artisan/fuse` + `fuse_do`（+ `fuse_read` / `fuse_check` / `fuse_give`）
     与 30 张战利品表 `artisan/fuse/<部件>_f2|f3`；**30 金币、每个工匠节点各限一次**（`tspire_fuse_used`），
     产物**与主手同类型、材料取自下一层材料池**；**「两枚部件必须同级」的前置仍未校验**（待办）。
  4. **v0.6.36 裂颅者补机制 2、3**：新文件 `boss/skullcrusher` + `skullcrusher_charge` / `skullcrusher_traps` / `skullcrusher_trap_check`；
     **【战术突进】**每 15 秒（`#SKU_C2`，预警 280..299 = **20 tick**）+ **【钉刺陷阱】**HP ≤ 210 每 20 秒（`#SKU_C3`，房间中心四正方向各 6 格）；
     **原案"冲刺 8 格"故意不写死**（贴墙会窒息）→ 改成"扑到队员身旁 2 格"。**【三连射】未动**。
  5. **v0.6.37 织影巫师补机制 2、3**：新文件 `boss/shadowweaver` + `shadowweaver_fangs` / `shadowweaver_veil`；
     **【尖牙阵】**每 8 秒（`#WEA_C1`，3×3 `evoker_fangs`、原版 `Warmup:20` = 1 秒、**可躲**）+ **【暗影帷幕】**HP ≤ 240 一次性（`#WEA_VEIL`，3 只恼鬼 + 隐身 5 秒，**故意不查 `#MOB_CAP`**）。**【唤鬼】未动**。
  6. **v0.6.38 钴蓝决斗者补机制 2、3**：新文件 `boss/duelist` + `duelist_blunt` / `duelist_echo`；
     **【崩刃】**HP ≤ 300 一次性 —— 用 **`/attribute` 修饰符**（`attack_damage multiply_total -0.5` / `attack_speed multiply_total 1.0`，固定 UUID）
     **⚠️ 全项目第一次用 `/attribute`，尚未游戏内实测**；**【玛玉灵回响】**被打 25%（`tspire:roll/d4`）反弹，**按掉血分档近似（Δ≥20→6 / 10~19→3 / 1~9→1），不是精确 30%**。**【疾风连击】未动**。
  7. **v0.6.39 删除占位阶段机制**：`boss/phase.mcfunction` 的通用占位阶段与真机制**同阈值双触发**（织影巫师永久隐身顶掉【暗影帷幕】、
     钴蓝决斗者力量 II 冲掉【崩刃】、`!! PHASE 2 !!` 覆盖真机制提示），已删除 6 个占位函数
     （`phase_quencher` / `phase_rusblade` / `phase_mirehunter` / `phase_duelist` / `phase_skullcrusher` / `phase_shadowweaver`），
     **只保留铭刻者 / 熔核暴君 / 重铸之王三个**（真机制未实现；**其中铭刻者那个在 v0.6.40 也删掉了，见下一项**）；`tspire_phase2` 只有 phase 文件在用。顺手修掉尖刺文案"四角" → "四个正方向（每面墙中间）"。
  8. **v0.6.40 铭刻者补机制 2、3**：新文件 `boss/inscriber` + `inscriber_rewrite` / `inscriber_reflect` / `inscriber_strip`
     （`inscriber_state_end` 当时也建了，**v0.6.41 已删除**，见下一项）；
     **【铭刻重写】**每 6 秒（`#INS_C1`）用 `tspire:roll/d4|d3|d2` **均匀掷 1..4** 写进 `#INS_STATE`
     （**1 免疫** 抗性 V / **2 反弹** 3 格内每 0.5 秒 2 点魔法伤害 / **3 加速** 速度 II / **4 吸血** 生命恢复 III，各有 actionbar + 聊天提示），
     **⚠️ v0.6.40 时的实际情况**：三个原版效果写的是 **8 秒**，而 8 秒的收尾计时器 `#INS_STATE_T` **会被 6 秒的重掷清零、到不了 160**
     → `inscriber_state_end` **从不执行**，两次状态的效果**重叠约 2 秒**（**v0.6.41 已修正**）；
     **【强化剥离】**HP ≤ 300 一次性 —— **⚠️ 1.20.1 无法移除匠魂 modifier**（只能由匠魂方块写入、没有移除用的 item function、没有宏拼 NBT），
     所以实现成 **25 秒虚弱 II + 挖掘疲劳 I 的「暂时剥离」，不碰玩家物品**（**已记入待办**）；
     同批**顺带删除占位阶段 `phase_inscriber`**（与【强化剥离】同阈值），`boss/phase.mcfunction` 当时**只剩熔核暴君 / 重铸之王两行**（**v0.6.42 又删掉了熔核暴君的那个，现在只剩重铸之王一行**）。**【镜像分身】未动**。
  9. **v0.6.41 修正铭刻者【铭刻重写】的状态窗口**：`#INS_STATE_T` 那个 **160 tick（8 秒）收尾计时器是死代码**
     （每 120 tick 的重掷都会把它清零，**永远到不了 160** —— **写 v0.6.40 文档做源码复核时发现的**）。
     修法：**删掉 `#INS_STATE_T` 的收尾块与整个 `inscriber_state_end.mcfunction`**，状态窗口**就定义为那 6 秒**
     （`inscriber_rewrite` 自己先清 `#INS_STATE` / `#INS_REFL_T` 再写新状态 → **任一时刻只有一个状态**），
     并把三个原版效果 **8 秒 → 6 秒**（`resistance 6 4` / `speed 6 1` / `regeneration 6 2`）、
     四段 actionbar / 聊天提示里的"8 秒"全改成"6 秒"；`boss/spawn/inscriber` **不再初始化 `#INS_STATE_T`**。
     全包 grep 确认 `#INS_STATE_T` / `state_end` 只剩说明性注释。
  10. **v0.6.42 熔核暴君补机制 2、3**：新文件 `boss/moltenlord` + `moltenlord_pressure` / `moltenlord_overload` / `moltenlord_burn`；
     **【凋零剑压】**（被动，每 5 秒 `#MOL_C1`）3 格内**凋零 II 3 秒**（`wither` amplifier 1）+ **`tspire_hp ≤ 10` 的队员额外 4 点 `magic`** 伤害，
     **⚠️ 1.20.1 没有"实体攻击命中"事件 → 实现成"每 5 秒一轮的贴身光环"，"+50%" 也算不出，改成残血固定多 4 点（与原案有实质偏差，已记入待办）**；
     **【熔核爆发】**HP ≤ 350 一次性（`#MOL_OVER`）进入**永久过载**：攻速 +50% 用 **`/attribute`**（`generic.attack_speed` `multiply_total 0.5`，UUID `0e5a3c1a-0003-…-0003`，**与【崩刃】同一个尚未实测的未知数**），
     并由 `moltenlord_burn` 每 5 秒自损 **30 点**（走 `magic` 以免被自身 armor 12 削掉）；
     同批**顺带删除占位阶段 `phase_moltenlord`**（`Health ≤ 350` 与【熔核爆发】同阈值），`boss/phase.mcfunction` **现在只剩重铸之王一行**。**【熔火地脉】未动**。
- **v0.6.43 / v0.6.44（玩家长清单：出售池 / 奖励池 / HUD / 沼泽猎手重做）**：
  11. **v0.6.43 出售池修复 + 盔甲部件 + 一批"函数加载失败"真 bug**：
      **(a) 出售池**：`gen-shops.ps1` 的出售清单以前是**手写的 10 项**、`$partDefs` 只有 9 项，所以
      `small_axe_head` / `pick_head` / `hammer_head` / `broad_axe_head` / `adze_head` / `large_plate` **卖不掉**（玩家报的两个就在里面）。
      现在 `$partDefs` **19 项**（15 + 4 个盔甲镶板）、**`$partItems` 由它派生**，可售部件 **10 → 19**（`sell.mcfunction` 里 19 条 `#CFG_SELL_PART`）。
      **(b) 三选一盔甲部件**：两张 `$partDefs` 都漏了 `helmet_plating` / `chestplate_plating` / `leggings_plating` / `boots_plating`，
      盔甲工具解析出的部件列表为空 → **盔甲根本没进可抽池**；补齐后可用工具 **22 → 30**、`part_f1.json` **196 → 216** 条、融合表 **30 → 38** 张。
      **(c) 三个函数加载失败（`latest.log` 抓到的，等于从来没工作过）**：`artisan/fuse_do`（粒子**数量与速度写反** → "无效的整型数据 0.5" → **【融合】点了没反应**）、
      `boss/mirehunter_javelin`（`minecraft:poison` 不是 1.20.1 的粒子 → 【标枪投掷】从未生效）、
      `boss/quencher_zone_burn`（`matches 1,6,11,…` 逗号列表非法 → 燃烧伤害从未生效）；同类粒子参数错误共 **23 行**（`validate.ps1` 注释的统计）。
      **(d) `validate.ps1` 新增三条规则**：粒子数量必须是整数、`particle` 禁止 `minecraft:poison`、`matches` 不许逗号列表。
      **(e) 其它**：共鸣文案"每局限一次" → "每个工匠节点限一次"（两处）；工匠节点箱子加**末影黏液水晶 ×8 + 湿海绵 ×8**；
      【威压】缓慢 → **缓慢 II**；【燃烧蓄能】/【尖牙阵】的选择器加 `scores={tspire_dead=0}`（**旁观者不再触发**）；
      修补件先从奖励池移除（v0.6.44 连表一起删）。
  12. **v0.6.44 奖励权重 / 装备池含盔甲 / HUD / Boss 奖励升层 / 沼泽猎手重做**：
      **(a) 权重**（`gen-rewards.ps1`，1000 分制）：**水晶 352 / 部件 302 / 装备 155 / 金苹果 179 / 远古 6 / 投掷 6**（水晶 38→35.2、部件 22→30.2、装备 8→15.5）。
      **(b) 装备池含盔甲**：新增 `rewards/gear_f1..f3`，从 weapon + head/chest/legs/feet 抽（weight 武器 2、四甲各 1 → 约 33% 武器 / 67% 盔甲）。
      **(c) 强化分类份额 50/30/15/5 → 30/20/25/25**；**商人水晶池同步过滤**（`$CRYSTAL_POOL` 22 → 19）。
      **(d) 三选一改"50/50 概率混抽"**（新假玩家 `#SRC_ARM`，先掷 d2 决定先看手还是先看护甲，第一组不中就回落另一组）。
      **(e) HUD**：侧栏金币（`tspire_hud_gold` + `setdisplay sidebar`，`tick/player` 每 tick 抄 `@s tspire_gold`）+ TAB 血量（`setdisplay list tspire_hp`）。
      **(f) Boss 奖励升层**：新假玩家 `#REW_F` = `#FLOOR`（Boss 房 +1，上限 3），随机奖励与三选一同规则。
      **(g) 修两个"写了但从来没生效"的机制**：【灰烬重生】阈值 20%（60）→ **50%（150）**（原来的窗口会被一刀直接打死跳过）；
      【亡者征召】残血 4 只的判定原来被**从未初始化的 `#RUS_DOUBLE`** 挡住 → 改成直接按 `tspire_boss_hp=..150` 判定。
      **(h) 【破甲重击】** 周期 28 → **24 秒**、爆发 **速度 II → III**；【燃烧蓄能】粒子改沿**半径 5 的 12 个点**、叠大烟柱。
      **(i) 沼泽猎手三机制全面重做**（详见设计文档 §7.6）：【泥沼】改为**主动 12 秒布 3 片**（结构去重、半径 4、10 秒、累计 3 秒 → 缓慢 10 + Boss 速度 II + 8 秒免疫）；
      【标枪投掷】加 **2 秒前摇**（`#MIRE_C2` 100..139）；【淤泥附身】→ **【泥沼现身】**（24 秒，把 Boss 传到 12 格外那名玩家**朝房间中心 3 格**处，旧 `mirehunter_muddy` 已删）；
      `load.mcfunction` 新增 `tspire_mud_t/imm/in`。
      **⚠️ (j) v0.6.44 交付时这一条是坏的**：`boss/mirehunter_javelin` 第 20 行 `effect give … minecraft:witch` **把效果 ID 写成了粒子名** →
      该函数**加载失败**，【标枪投掷】的中毒不生效、冷却也不归零。**已在 v0.6.45 修好**（改回 `minecraft:poison`），见下一项。
  13. **v0.6.45 修正【标枪投掷】的中毒效果 + 补"效果 / 粒子混淆"校验**：
      **(a) 根因**：v0.6.43 修"`minecraft:poison` 不是粒子"时用了**全局替换 `poison → witch`**，
      把 `mirehunter_javelin` 里那一行 **`effect give`** 也换掉了 —— **`witch` 是粒子、不是状态效果** →
      命令无法解析 → **整个函数加载失败**（于是中毒不发生，而且同文件的 `#MIRE_C2 = 0` 也不执行、7 秒冷却永远不再开始）。
      **(b) 修法**：只改一个词 → **`minecraft:poison 3 0 true`**（并把"上面那行粒子 `witch` 是对的"写进注释）；
      现在【标枪投掷】正常加载 → 5 格内中毒 3 秒 → 冷却归零 → 7 秒一轮循环。
      **(c) `validate.ps1` 再加两条规则**（在 v0.6.43 三条之上）：新增 **`$effectIds`（33 个 1.20.1 状态效果）**白名单；
      **Rule A** = `effect give … minecraft:<id>` 必须在这张表里；**Rule B** = `particle minecraft:<id>` 不许在这张表里
      —— **"效果 / 粒子互相写错"两个方向都被离线兜住了**。
      **(d) 负向验证（本轮唯一真的跑过的验证）**：临时写一个只含 `effect give @s minecraft:witch 3 0 true` 的探针函数 →
      `validate.ps1` **确实 FAIL**（`'minecraft:witch' is not a 1.20.1 status effect (is it a particle?) -- kills the whole function at load`）；删掉探针再跑 → **PASS**。
      **全量 validate 现为 PASS**（那 33 项覆盖了当前用到的全部效果；将来用到名单外的会 FAIL 报错 = 自纠偏）。
  14. **v0.6.46 修复两个"加载失败"成因 + 血量判定改 NBT + 11 项玩家要求**：
      **(a) `/damage` 只接受单个实体**：多选选择器（`damage @a[…] N <type>`）**加载期就报「只允许一个实体」** →
      **整个函数静默不加载**。受影响 3 个文件 14 行：【燃烧蓄能】的 12 行灼烧伤害、【反弹】的反伤、【凋零剑压】的残血伤害
      —— **这三处伤害从来没生效过**。改成 `as @a[…] run damage @s …`。
      **(b) `/attribute` 在 1.20.1 加载期被拒**（`multiply_total` 不被接受）→ v0.6.38【崩刃】与 v0.6.42【熔核爆发】**从来没生效**。
      **彻底弃用**：崩刃 → `weakness 999999 1`（虚弱 II，攻击 14 → 约 6 ≈ −57%）+ `speed`；熔核爆发 → `speed`。
      **"攻速"在 1.20.1 没有效果能表达 = 刻意的降级实现**（已记待办）。
      **(c) 血量判定全部改 NBT**：`tspire_boss_hp`（`health` 判据计分板）**不可靠** ——
      证据是 NBT 版的占位阶段触发过、而所有基于该计分板的血量门**一次都没触发**（【灰烬重生】/【泥沼现身】/【亡者征召】）。
      8 处改成 `nbt={Health:..X.0f}`。**结论：本项目一律用 NBT `Health` 判血量。**
      **(d) 【泥沼】"只有特效没有效果"**：`scores={tspire_mud_imm=0}` 对**没有该分数**的玩家不匹配（中途进队 / 复活的人）→
      在 `mirehunter_mud_check` 开头加兜底 `scoreboard players add @a[team=tspire_party] tspire_mud_t 0`（imm / in 同样）。
      **(e) `validate.ps1` 再加两条（共 7 条）**：Rule E = `damage @a/@e[…]` 没有 `limit=1` → FAIL；Rule F = **任何 `attribute …` → FAIL**。
      **(f) 10 项玩家要求**：构筑阶段回满血（`instant_health 1 9` = 2048 点）；战斗金币 **8~12**（新 `rewards/gold_roll` = 7 + d5，逐人）；
      **BOSS 击杀 +100 金币（以前只写在文档里、代码从来没实现）**；宝箱 **15~20 金币 + 45% 水晶**（`d2` 且非 `d10` = 0.5×0.9）；
      出售**按堆叠**计价（`sell_drop` 读 `Item.count`）；**`maille`** 入池（`part_f1` 216→228、融合表 38→40、出售 19→20 项，工具数仍 30）；
      工匠节点**每人每节点只免费回血一次**（`artisan/heal_once` + `tspire_heal_node`）；标枪半径 **5 → 7**；
      怪物池 **evoker → vindicator、vex → pillager**（且掠夺者只用原版弩：`equip_f*` 加 `type=!minecraft:pillager`）；
      结算界面新增 `[ 退出 ]`（`run/quit`）。
      **(g) 过程教训**：给 `$partDefs` 加 `maille` 时**第一次把 `boots_plating` 顶掉了**（工具数 30 → 29），
      靠对比生成器输出的统计数字与部署前后的 `offer_f1.mcfunction` 才发现 —— **生成器局部替换必须复查相邻行**。
      **(h) ⚠️ 本轮两条漏改（已记待办）**：**`merchant/sell`（点击出售）没做按堆叠计价**（仍"付 1 个、清整叠"）；
      **`boss/duelist_echo` 仍读 `tspire_boss_hp` 计分板**（【玛玉灵回响】可能从来没触发）。
  15. **v0.6.47 修掉上一轮漏掉的两条 + 挖出 `Item.count` 大小写 bug**（文档侧复核指出的，两条都成立）：
      **(a) `merchant/sell` 的堆叠计价**：v0.6.46 确实手改过它，**但随后为了加 `maille` 又跑了一次 `gen-shops.ps1`** ——
      而 `merchant/sell` 是**生成物**，手改被原样覆盖。现在**改生成器**：`tools/gen-shops.ps1` 的**两个出售模板**
      分别读 **`SelectedItem.Count`**（点击 `[出售]`）与 **`Item.Count`**（丢下出售），**单价 × 数量**后再加钱。
      `merchant/sell` 现在是第 **46–48** 行三步（模板注释 43–45 行）：`#SELLN` **先默认置 1** → `data get … SelectedItem.Count` → `#SELL *= #SELLN` ✓
      （`sell_drop` 是第 **49–51** 行，读 `Item.Count`）。
      **教训：生成的函数不能直接改，必须改生成器。**
      **(b) `boss/duelist_echo` 的血量读取**：修复脚本改 `rusblade_summon` 时抛了 **COUNT MISMATCH 中断**，
      排在它后面的 `duelist_echo` **从未被执行**。现在第 19 行是
      `execute store result score #DUE_NOW tspire_timer run data get entity @e[tag=tspire_boss_duelist,limit=1] Health 1`（**不再读计分板**）。
      **(c) `Item.count` 大小写 bug（更严重，顺带挖出）**：`sell_drop` 读的是 **`Item.count`（小写 c）**，而 NBT 标签是 **`Count`** →
      读取失败 → `#SELLN` 保持 0 → `#SELL *= 0` → **"丢下即出售"从 v0.6.29 起一直没付钱、也没消耗物品**。
      已改成 **`Count`**，并把目标计分板**先默认置 1**（将来读取失败最坏也只退回"按单个计价"，不会变成 0）。
      **(d) `validate.ps1` 第 8 条规则**：`Item.count` / `SelectedItem.count`（小写）→ **FAIL**；
      **必须用 `-cmatch`** —— PowerShell 的 `-match` **默认忽略大小写**，第一版把合法的 `Item.Count` 也误报了。
  16. **v0.6.48 泥沼判定根因 + 血量每 tick 显式同步 + 裂颅者重做 + 第 2 层 Boss 血量 500**：
      **(a) 🔴 本轮最有价值的根因：【泥沼】"只有特效没效果"是 `as` 不换位置。** 判定写的是
      `execute as @e[tag=tspire_mud] as @a[…,distance=..4]` —— **`as` 只换执行者、不换执行位置**（那是 `at` 的作用），
      所以 `distance=..4` 是在**当时的执行位置**（`boss/tick` = 塔里的原点）算的，**没有任何玩家会匹配**；
      粒子一直正常是因为那几行有 `at @s`。已改成 **`as @e[…] at @s as @a[…]`**（`mirehunter_mud_check` 第 43 行）。
      **教训：按位置判定（`distance=`）的 `execute as` 后面必须跟 `at @s`。**
      **(b) 血量判定改成"每 tick 自己写"**：v0.6.46 改成 `nbt={Health:..Xf}` 后**玩家反馈仍不触发**。
      现在 `boss/tick` 第 11–18 行对 **8 只 Boss** 各写一行
      `execute if entity @e[tag=…] store result score @e[tag=…] tspire_boss_hp run data get entity @e[tag=…,limit=1] Health 1`，
      门再读这个计分板 —— **值是我们自己刚写的，一定是本 tick 的真实血量**（一次覆盖"计分板不同步"与"NBT 范围匹配不成立"两种可能）。
      **(c) 新诊断函数 `test/boss_probe`**：一次打印每只 Boss 的真实 `Health` 与同步后的 `tspire_boss_hp`、各冷却假玩家、
      逐玩家的 `tspire_mud_*` 与场上 `tspire_mud` / `tspire_spike2` 数量。**排查静默不触发先跑它。**
      **(d) 裂颅者三机制重做**：【三连射】3 → **8 秒**（`#BOSS_TIMER` 窗口改成 120..159 / 160）；
      【战术突进】15 → **16 秒**，**前摇 2 秒（280..319，每 tick 转向最近玩家、只在落点出粒子）**，
      到 320 传送到 **`tspire_skull_dash`** 落点（沿朝向 5 格、每 tick 重算），落点 4 格内 **水平击退 5 格 + 4 点伤害 + 虚弱 + 缓慢 II**；
      **新增 `boss/skullcrusher_kb`**：把"玩家相对 Boss"的位移按 `Pos`×100 拆成 dx/dz，**谁大沿谁推 5 格、Y 一定不变**
      （玩家报过"被击退到出图"）—— **代价是斜向击退退化成轴向击退，已记待办**；
      【钉刺陷阱】改 **5 个点 / 半径 2 / 每 12 秒 / 整批 10 秒**（`#SKU_T2` 0..200，新文件 `skullcrusher_trap_end` 清场），
      踩中 = **3 点伤害 + 缓慢 10（amp 9）3 秒 + 强制看向 Boss + 该枚消失**，判定改成**逐枚独立**
      （旧写法用全局假玩家 `#SPIKE_HIT` → **任意一枚被踩、5 枚全被 kill**）。**新增标签 `tspire_spike2` / `tspire_skull_dash`。**
      **(e) 第 2 层三只 Boss 血量 600 → 500**，阈值同步：崩刃 **300 → 250**、暗影帷幕 **240 → 200**。
      **(f) 掠夺者空手修复**：`/summon` 出来的掠夺者本来就没有装备；v0.6.46 加了 `type=!minecraft:pillager` 后就空手了。
      现在 `mobs/equip_f{1,2,3}` **显式发一把原版弩**（`item replace … weapon.mainhand with minecraft:crossbow`）。
      **🔴 但这条只写在生成物里、没写进 `gen-gear.ps1`** —— 下次跑生成器会被冲掉，**已记待办**（**✅ v0.6.49 已从源头修掉，见下面第 17 条 (a)**）。
  17. **v0.6.49 三条复核项的收尾**（上一轮文档侧提出的三条，本轮结案）：
      **(a) ✅ 掠夺者的弩写进生成器**：`tools/gen-gear.ps1` 的装备循环改成**按槽位分支** ——
      `weapon.mainhand` 生成**两行**（pillager 发 `minecraft:crossbow`、其余 `type=!minecraft:pillager` 走
      `loot replace … mob_gear/weapon_f<floor>`），其余三个护甲槽照旧。**已实跑 `gen-gear.ps1` 验证**：
      `mobs/equip_f{1,2,3}` 第 **4–5 行**就是这两行，**重跑生成器不再冲掉**（v0.6.47 `merchant/sell` 的同类事故这次从源头修掉）。
      **(b) ✅ `test/boss_probe` 覆盖 8 只**：原来只打 quencher / rusblade / mirehunter / skullcrusher，
      现补齐 duelist / shadowweaver / inscriber / moltenlord（`Health=` 行 **8 行**，源码第 16–23 行）。
      **⚠️ 仍不含重铸之王**（它还在跑占位阶段）。
      **(c) ✅ 裂颅者【钉刺陷阱】的"阶段血量门"结案：文档有错、代码没问题。** 玩家 v0.6.48 的新规格原文是
      "【钉刺陷阱】…… 技能每 12 秒触发"，**没有血量条件**；文档里"HP ≤ 35%"是 v0.6.36 的残留，**已在 §7.6 删除/作废**，
      `boss/tick` 第 36–38 行注释改成「16s（前摇 2s）/12s，**陷阱没有血量门**」。**不补门。**
      **(d) 🔴 → ✅ v0.6.50 已实现【三连射】真·三支箭**（玩家选方案 A），见第 18 条 (a)。
      **(e) 遗留（纯注释，未修）**：`boss/phase.mcfunction` 第 15–20 行的注释整段旧（裂颅者仍写 HP ≤ 210、淬火者 60、
      沼泽猎手还写着已删除的 `mirehunter_muddy`、决斗者 300、织影巫师 240）；`boss/tick` 第 39 行仍写「【三连射】…未改动」。
  18. **v0.6.50 裂颅者【三连射】真·三支箭 + 钴蓝决斗者三机制重做**：
      **(a) 新增 `boss/skullcrusher_volley`（方案 A）**：`boss/active` 第 160 那一拍调用它（原来的 actionbar +
      `entity.arrow.shoot` 音效 + **力量 II 2 秒保留**）。做法：`Rotation[0]` → 归一到 0..359 →
      `#BUCKET = (yaw + 22) / 45 mod 8` 分 **8 个方向桶**，每桶 **3 行** `summon minecraft:arrow`（共 **24 行**，
      实际只有 1 个桶命中 → **射 3 支**），生成点**前方 1.5 格 / 高度 +1.2**，每支配**预计算 `Motion`**
      （中间 + 左右各偏约 10°），箭 `damage:4.0` / `Pickup:0b` / `crit:1b` / `Tags:["tspire_arrow"]`。
      **⚠️ 近似：只有 8 个桶、每桶固定 ±10°**（斜向最多偏约 22.5°）；**⚠️ 没有任何地方清理 `tspire_arrow`**。
      **(b) 钴蓝决斗者三机制重做**（`boss/duelist` 重写 + 三个新文件）：
      **【死斗】**（原【疾风连击】；被动）= **每 2 秒**给 **3.5 格内**队员 **`tconstruct:bleeding`（流血）3 秒**
      （`#DUE_C3` 40；**1.20.1 没有命中事件 → 贴身光环近似**）；
      **【破釜】**（原【崩刃】；每 **15 秒**，`#DUE_C1` 300）= `d3→d2` 链均匀随机 **速度 II 8 秒 / 抗性提升 I 12 秒 / 力量 I 6 秒**；
      **【决斗嘶吼】**（原【玛玉灵回响】；HP ≤ **250**、每 **16 秒**，`#DUE_C2` 320）= 末影龙嘶吼 + 全员
      **虚弱 I 12 秒 + 穿甲 II 12 秒**（**`tconstruct:pierce`**，amp 1）。
      **旧 `duelist_blunt` / `duelist_echo` 已删除**，`#DUE_BLADE` / `#DUE_LAST` / `#DUE_NOW` / `#DUE_DELTA` → `#DUE_C1/C2/C3`。
      **(c) 匠魂效果 id 已逐个核对**：`assets\tconstruct\lang\zh_cn.json` 第 **3649** 行 `effect.tconstruct.bleeding = 流血`、
      第 **3652** 行 `effect.tconstruct.pierce = 穿甲`（`en_us.json` 3672 / 3675 同名键）。
      **(d) `validate.ps1` 规则 8 → 9 条**：新增"`effect give … tconstruct:<id>` 必须在匠魂语言键里"；
      同时修掉**正则误伤**：旧的物品 id 检查 `\bgive\s+…` 会把 `effect give @a[…] tconstruct:bleeding` 的 `give` 当物品 →
      改成 **`(?<!effect )\bgive\s+…`**。**教训：加规则要先跑全量，规则之间会互相咬。**
      **(e) 🔴 遗留：`boss/active` 第 34–40 行旧【疾风连击】块没删**（每 4 秒 `haste 3 1` + 「攻速暴涨」）
      → 决斗者实际有**四条**机制在跑，且 `haste` 只影响挖掘。另：`moltenlord_overload` 第 7 行、`moltenlord_burn` 第 7–8 行、
      `boss/phase` 第 11 / 18 行、`boss/tick` 第 46–47 行的注释仍引用已删除的旧文件（纯注释）。**✅ v0.6.51 已删掉那块（见第 19 条）。**
  19. **v0.6.51 【死斗】默认禁用 + 删旧【疾风连击】块 + 三连箭清理**：
      **(a) 【死斗】默认关闭**：新增 `#CFG_DUELIST_DEATHMATCH`（`config/defaults`，默认 **0**），
      `boss/duelist` 死斗那一行加 `if score #CFG_DUELIST_DEATHMATCH tspire_config matches 1..`；
      **函数 `boss/duelist_deathmatch` 保留**，改键即恢复（计时器照常走，打开后不会等 2 秒）。
      **(b) ✅ 删掉 `boss/active` 里的旧【疾风连击】块（7 行）** —— 决斗者从此只剩 `boss/duelist` 的三个机制。
      **(c) `run/battle_win` 加 `kill @e[tag=tspire_arrow]`**（裂颅者三连箭此前无人清理）。
      **(d) 陈旧注释**：`moltenlord_burn` / `moltenlord_overload` / `boss/phase` / `boss/tick` 里引用已删文件的注释部分改掉（**只清了一部分**）。
  20. **v0.6.52 ★ 音效锚定 + Boss 死后清召唤物 + 亡者征召 3 只 + 织影巫师四项**：
      **(a) ★ 47 处 `playsound` 锚定（本轮最重要）**：`tick.mcfunction` 用 `execute in tspire:tower run function tspire:tick/tower`，
      **`in` 只切维度、不换坐标** → 整条链的执行位置一直是塔原点 → 所有 `playsound … @a[…] ~ ~ ~` 都在原点播、**玩家听不到**
      （这就是"【决斗嘶吼】没有末影龙嘶吼"的根因）。改成 **`execute as @a[team=tspire_party] at @s run playsound <音效> master @s ~ ~ ~ …`**。
      **⚠️ 但只覆盖了一部分：全项目 73 条里 48 条已锚定、9 条该锚定却还写着旧写法** ——
      `boss/active` L26/L45/L55/L69/L84/L94（六个 Boss 主动技能音效）、`boss/mirehunter_mud_check` L58、
      `boss/skullcrusher_charge_aim` L29、`boss/phase_recastking` L8。**见设计文档待办表第 20 条。**
      **(b) Boss 死后清召唤物（brief 说加在 `tick/tower`）**：**⚠️ 在已部署源码里没找到** —— `tick/tower` 仍是 8 行，
      全项目没有 `unless entity @e[tag=tspire_boss]` 之类的清理，也没有新的 `kill @e[tag=tspire_mob]`。
      **即：Boss 召唤的小怪目前仍会拖住"全灭"判定。** 需要确认是否漏部署。
      **(c) 亡者征召 4 → 3 只**，并去掉靠南（+Z）那只（`boss/rusblade_summon` L16 保留 `~ ~ ~-2` 北侧一只）。
      **⚠️ 该文件的注释与 actionbar 文案仍写"4 只"**（L1 / L6 / L21）。
      **(d) 织影巫师四项**：【唤鬼】15 → **14 秒**（窗口 240..279 / 280）、恼鬼 **5 点血**；【尖牙阵】8 → **10 秒**（`#WEA_C1` 200）；
      **【暗影帷幕】重做**（HP ≤ 200、每 20 秒 `#WEA_C2` 400：原位置 1 只 5 血恼鬼 → 全员失明 3 秒 → 安全随机传送 →
      隐身 5 秒 → 发光 2 秒）；新文件 **`boss/shadowweaver_glow`**（`#WEA_GLOW` 101 → 1）。
      **⚠️ `boss/shadowweaver_fangs` 的文件头注释仍写"每 8 秒"。**
      **(e) 修掉自己写的漏洞**：发光收尾原判 `matches 0` → **每 tick 都触发**；改成"先判 `matches 1`，再 `remove 1`"。
      **(f) 【破釜】随机性已核实均匀**：`roll/d2 = 0.5`、`roll/d3 = 0.333333` → 三档各 1/3。**不是 bug**（设计文档待办表第 22 条结案）。
  21. **v0.6.53 织影巫师底怪最终 = 唤魔者 + 只清原版恼鬼**：
      **`#CFG_WEAVER_KEEP_EVOKER` 默认改成 1**（1 = 唤魔者，0 = 卫道士）；`boss/shadowweaver` 只保留
      **`kill @e[type=minecraft:vex,tag=!tspire_mob]`**（每 tick）。**`tag=!tspire_mob` 是关键** ——
      我们脚本召的恼鬼在 `summon` 的 NBT 里就带 `Tags:["tspire_mob"]`，不会被误伤；原版召的不带标签，会被清掉。
      **❌ 已放弃并删除代码的方案**：封印 `SpellTicks`、`NoAI` + 脚本 AI（`shadowweaver_ai` / `shadowweaver_bolt` 已删）。
      **⚠️ 两处残留（不影响行为）**：`boss/spawn/shadowweaver` 第 14/16/17 行注释仍写"默认卫道士 / NoAI / 清零 SpellTicks"，
      第 18 行唤魔者 NBT **仍带 `SpellTicks:0`**；`boss/shadowweaver` 第 4 行还写"底怪已从唤魔者 → 卫道士"（与同文件后文矛盾）。
      **🔴 遗留（待玩家决定）**：**原版尖牙法术仍会放** → 现在有**两套尖牙**（原版 + 脚本【尖牙阵】）；
      选项 (a) 拉长/关掉【尖牙阵】/ (b) 清掉带标签之外的原版尖牙 / (c) 当特色。见设计文档待办表第 21 条。
  22. **v0.6.54 奖励池 / 商人 / 出售 / 小调整**：
      **(a) 奖励池改版**：**金苹果不再单列** → 新表 **`rewards/special.json`（5 件等概率：金苹果 / 喷溅瞬疗 II / 力量 / 速度 / 滞留再生）** 占 **19.1%**；
      权重变成 **`part 298 / crystal 348 / gear 151 / special 191 / ancient 6 / throwing 6`**（旧 302/352/155/179/6/6 作废）。
      **(b) 商人格子**：**6 部件 → 5 部件 + 1 特殊**（`$SHOP_PART_COUNT` 6→5，特殊格 10~30 金币），15 格总数不变。
      **(c) 商人卖的远古工具**改用**本层材料**（原来全填 `tconstruct:ancient`）。
      **(d) 菜单文案**：新增 `sellDropHint`（"也可以直接把要卖的东西丢到商人旁边…"）+ `lineSpecial` / `hoverSpecial` / `spItem_*` / `pot_*`。
      **(e) 出售表补 12 件盔甲**（镶板 / 旅行者 / 黏液 ×4，两条路径都加了）。
      **🔴 但 brief 说的"丢下不在表里的东西 → 提示「这件东西我不收。」"源码里没有**（无 `Age` 判断、无该文案、`shop-text.json` 也没有对应键）→ 设计文档待办表第 30 条。
      **(f) 锈刃督军【破甲重击】**追加**抗性提升 I 5 秒**（`rusblade_smash_go` L10，与速度 III / 力量同长）。
      **(g) 第 3 层三只 1000 → 750**、铭刻者【强化剥离】阈值 300 → 225 —— **⚠️ 这两条当天就被 v0.6.59 改掉了**（见第 27 条）。
  23. **v0.6.55【死斗】重做 + Boss 单挑入口**：
      **(a)【死斗】按玩家方案重做**：判据 = **玩家掉血 + 3 格内有 BOSS** → `tconstruct:bleeding` 3 秒；
      **逐人 10 秒冷却**（新计分板 `tspire_dm_cd` 200 / `tspire_dm_hp` 存上一 tick 血量）；**开关默认改回 1**；
      **旧"Boss 掉血给 4 格内玩家流血"的光环已移除**。
      **(b) 新增 `test/boss_pick` + 9 个 `boss_pick_<id>` + `test/boss_arena_setup`**：点菜单即可单挑任意一只。
  24. **v0.6.56 铭刻者四项重做**：**【时间铭刻】**（20s，`tconstruct:returning` 10s + 虚弱 8s）、
      **【铭刻逆流】**（30s，中央 + 缓慢 10 8s + 全员缓慢 II 8s → 8 秒观察窗：没受伤回血 / 受伤→全员失明 3s + 安全随机传送 + 发光 6s）、
      **【时间书虫】**（8s，2 只蠹虫，HP<50% 多 1 只）、**【遗忘蚀刻】**（HP<50% 每 32s，按人数 1/2/3+ 分支，含 `tconstruct:antigravity`）。
      **旧文件 `inscriber_rewrite` / `inscriber_reflect` / `inscriber_strip` 已删除**；幻术师改拿**原版弓**。
      **⚠️ 回血用 `instant_health 1 3` = 32 点（规格 30）**，是刻意近似（待办第 25 条）。
  25. **v0.6.57 重铸之王三机制 + 熔核暴君三机制重做**：
      **(a)【再锻】**（生成时立刻 + 每 55s）传送中央 → 缓慢 10 三秒 → **换随机 3~4 级手斧** + 随机 45s 增益；
      武器来自新生成的 **`loot_tables/boss_gear/recast_axe.json`（35 条）**。
      **(b)【金铸壁垒】**（HP<75% 每 43s）8 格内**水平外推 4 格** + 虚弱/缓慢；8 秒观察窗按**累计伤害**分支（≥8 → 自身减益；<8 → 召 2 只 20 血猪灵蛮兵 + 自身力量）。
      **(c)【王权征召】**（HP<25% 每 27s）没有蛮兵 → 召 1 只 + 抗性 II 10s；有 → 全体回满血 + 力量 10s。
      **(d) 占位阶段清零**：`phase_recastking` 删除，**`boss/phase.mcfunction` 至此没有任何活跃逻辑**（只为兼容调用点保留）；
      **✅ 9 只 Boss 全部 3/3 完成**。
      **(e) 熔核暴君**：【熔火地脉】10s（2 秒前摇 + 3×3 火 5 秒，HP<300 → 5×5）、
      【凋零剑压】3 只 30 血无 AI 岩浆怪 + 抗性 III（每死一只 −1，清空后 40 秒再触发）、
      【熔核爆发】HP<425 每 30s（技能 15s 暂停计数 → 实际 45s，5 段 `fz1..fz5` 标签接力）。
      旧文件 `moltenlord_overload` / `_burn` / `_pressure` 与 `boss/active` 旧【熔火地脉】12 行均删除。
  26. **v0.6.58 火焰改真方块**：`fill … minecraft:fire keep` 生成、`fill … minecraft:air replace minecraft:fire` 清理；
      **清理顺序**：熔火地脉**先清火再清标记**；【熔核爆发】`fz1` 只预警、`fz2..fz4` 补火、**晋升 `fz5` 前先灭火再 kill**；
      `run/battle_win` 加兜底 `fill ~-8 ~-1 ~-8 ~8 ~4 ~8 air replace minecraft:fire` + kill `fz1..fz5`。
      **⚠️ 代价：真火焰会烧掉落物**（待办第 26 条）。
      **⚠️ 源码注释残留**：`boss/moltenlord` 第 6 行仍写"火焰用纯粒子 + 周期伤害实现"（与实现相反）。
  27. **v0.6.59 人数缩放 / 开局清理 / 泥沼**：
      **(a) Boss 血量随人数缩放**（1/2/3+ 人）：1 层 **200/250/300**、2 层 **350/450/500**、3 层 **500/600/750**；
      **每个 `boss/spawn/*` 三条 `summon`**（`Base:max_health` 生成后改不了）。
      **(b) 百分比门槛分数化**：spawn 算 `#MAXHP` → `#TH_75/#TH_HALF/#TH_40/#TH_25`；`boss/tick` L20 写 **`#BNOW`**；
      门改成 `execute if score #BNOW tspire_timer <= #TH_XX tspire_timer`（**选择器比不了分数**）。**绝对值门保留**：熔火地脉 300、熔核爆发 425。
      **(c) 开局清理**：`run/start_run` L19 `scoreboard players reset * tspire_hud_gold` + L21–22 按在线人数重算 `#PARTY_SIZE`。
      **(d)【泥沼】**触发阈值 `tspire_mud_t` **60 → 40**（3 秒 → 2 秒）。
  28. **v0.6.60 修 5 个"函数加载失败" + 测试场重做 + 流血真凶 + 数值 + 空中箱子 + 工具链**：
      **(a) 🔴 "BOSS 不放技能"的真凶 = 5 个函数加载失败**（加载失败 = 那个函数**永远不运行**，运行时完全静默）：
      `boss/skullcrusher_kb` L41 与 `boss/recastking_push` L22 行尾是**裸 `at @s run particle`**（漏 `execute`）；
      `boss/moltenlord_lava_zone` L22–29 写成 `… matches 20 run as @a[…] run damage`（**`run` 不在链尾**）；
      `boss/recastking_summon` L6 用了**不存在的粒子** `minecraft:gold_block`（应为 `particle minecraft:block minecraft:gold_block`）；
      `boss/recastking_summon_go` L14 `data merge entity @e[…]`**多实体**（应 `as @e[…] run data merge entity @s`）、L16 同样是那个粒子。
      **证据**：`latest.log` 22:20 一次报 5 条 `Failed to load function`。
      **(b) 淬火者【灰烬重生】误触发**：`boss/tick` 的门只比 `#BNOW/#TH_HALF`（**都是全局假玩家**）→
      打任何 Boss 掉到 50% 以下都会触发淬火者复活。已加 `if entity @e[tag=tspire_boss_quencher]`（第 31 行）。
      **(c) Boss 测试场重做**：新增 **`test/boss_arena_build`**（大厅东南角 28 64 20 现搭 21×21 场地，屏障封顶）；
      **`test/boss_arena_setup` 重写**（清场 + 建场地 + **场地中心立 `tspire_test_node`/`tspire_node_current`/`tspire_type_boss` marker** + 全队传到南侧 28 64 27 + 算 `#PARTY_SIZE` + 开战斗开关）；
      9 个 `boss_pick_<id>` 与 `boss_demo` 改成 `at @e[tag=tspire_test_node,limit=1] run function …`。
      **根因**：Boss 机制几乎全部以"当前节点 marker"为原点，旧流程只把人丢在构筑间、**没有房间也没有 marker**。
      **(d) 流血的真凶**：不是死斗，是**匠魂材质 `tconstruct:nahuatl` 自带 `tconstruct:lacerating`（割裂）**，
      被 `gen-gear.ps1` 的"随机材质"掷到就会让玩家流血 → 已加进 `compat_excluded.json`，**重跑 gen-gear 后生效**。
      **(e) 沼泽猎手**：泥沼半径 **4 → 5**、踩满 **30 tick（1.5 秒）**（免疫仍 160）；标枪中毒 **3 → 5 秒**且文案改"7 格内"；
      泥沼现身 **480 → 320 tick（16 秒）** + **落地压制**（只有 `tspire_tp_to` 还在才结算：5 格内 8 秒缓慢 + 8 秒虚弱）。
      **(f) 空中箱子**：`shop/*_fill` 只 kill marker、不删 chest 方块 → `gen-shops.ps1` 先 `setblock ~ ~ ~ air`（+`~ ~-1 ~`）再 kill 再放；
      `gen-terrain.ps1` 的 `map/clear_floor` 末尾追加"地板下两层 `air replace minecraft:chest`"。
      **(g) 工具链**：`validate.ps1` **9 → 12 条**（新 3 组：execute 链式写法 / `/data entity` 单实体 / **1.20.1 粒子 id 白名单**）；
      新增 **`tools/checklog.ps1` + `tools/logpath.txt`**（从 GBK 的 `latest.log` 读 `Failed to load function`，只统计最近一次加载，
      打印函数名 + 报错行号 + 当前源码行）。**流程：每次 `/reload` 后跑 checklog，不要只看 validate 的 PASS。**
      **(h) 待办 #30 结清**：`sell_drop` L70 新增「**这件东西我不收。**」（`nbt={Age:..20}` + 未成交；生成器 L625 / 文案键 `sellNo`）。
  29. **v0.6.61 #27 已实现（分数门）+ 玩家对其余待办的裁决 + 残留注释清理**：
      **(a) #27 熔核暴君两个绝对门改成随人数缩放**：`boss/spawn/moltenlord` 新增 **`#C17`/`#C20`** 与
      **`#TH_60`（`#MAXHP×3/5` = 300/360/450）**、**`#TH_85`（`#MAXHP×17/20` = 425/510/637）**；
      `boss/moltenlord` 顶部新增「0) 阶段门」块，每 tick 把 `#BNOW` 与它们比成 **`#ML_WIDE` / `#ML_BURST`** 两个 **0/1 标志位**；
      `moltenlord_lava`（1 处）+ `moltenlord_lava_zone`（8 粒子 + 8 伤害 = 16 处）**只读标志位**；
      【熔核爆发】的发动门改成 `if score #ML_BURST tspire_timer matches 1`；文案 / 注释同步。
      **语义：改后恒为最大血量的 60% / 85%**（改前 1/2/3 人是 60/50/40% 与 85/71/57%）；
      **⚠️ 85% 意味着【熔核爆发】几乎一开打就会放**（继承比例，只缩放没改意图）。
      **(b) 玩家裁决**：**#26 → 选②**（接受真火焰烧掉落物，不做防烧）；**#21 → 选 C**（保留双尖牙当特色，不改代码）；
      **#25 → 同意 32 点**；**#6 / #7 / #10 / #18 → 机制已废弃，条目删除 + 残留注释已清**
      （`boss/phase` 铭刻者行改成【遗忘蚀刻】、`spawn/inscriber` 注释改成时间铭刻/铭刻逆流/遗忘蚀刻、
      `boss/duelist` 头注释改成 v0.6.55 的"掉血 + 3 格内 + 10 秒冷却"与"v0.6.55 起默认开启"；
      `boss/active` 里那两行 haste 历史说明**保留**）。
      **(c) 本轮复核新发现**：`boss/inscriber_bookworm` ~~第 10 行~~ **第 13 行**仍写 `scores={tspire_boss_hp=..375}`（750 血时代硬编码，
      实际变成 75%/62.5%/50%），同文件的【遗忘蚀刻】已改用 `#TH_HALF` —— **建议下一轮改成 `#BNOW <= #TH_HALF`**
      （设计文档待办总表 #31）。**✅ v0.6.62 已照此修掉（见下面第 30 条）。**
  30. **v0.6.62 玩家拍板直修四条 + 新增一条预防性校验规则（脚本 §4f）**：
      **(a) #31 铭刻者【时间书虫】漏网的绝对门修掉**：`boss/inscriber_bookworm` **第 13 行**
      `scores={tspire_boss_hp=..375}` → **`execute if score #BNOW tspire_timer <= #TH_HALF tspire_timer at @e[tag=tspire_boss_inscriber,limit=1] run summon …`**
      （**恒定 50%** = 250/300/375；文件头注释改成「HP ≤ 50%（`#TH_HALF`）」并加了 3 行说明"375 是 750 血时代的 50%"）。
      **⚠️ 文档旧版写"第 10 行"是笔误，实际一直在第 13 行**（文件头有注释占行）。
      **(b) #9 `validate.ps1` 粒子计数规则不再整类豁免带额外参数的粒子**：新增 `$paramArgCount` 表
      （**`dust` 4 / `dust_color_transition` 7 / `block`·`block_marker`·`falling_dust`·`item`·`sculk_charge`·`shriek` 各 1**），
      按额外参数个数跳过前缀再检查计数位；**只有 `vibration` 仍豁免**（目标是方块坐标或实体选择器，token 数不固定），注释写明原因。
      **自测：临时插 4 行探针（`flame` / `block` 各一对"正常 / 计数与速度写反"）→ 精确报出写反的两行，删探针后复跑 PASS。**
      **(c) #13·#28 击退 / 外推改成真·任意方向水平推进**：`boss/skullcrusher_kb`（5 格）与 `boss/recastking_push`（4 格）**重写**：
      受害玩家打标签 **`tspire_kb_victim`** → 在 **Boss 脚下**放 marker **`tspire_kb_rot`** 并
      `tp @s ~ ~ ~ facing entity @e[tag=tspire_kb_victim,limit=1] feet` → **`execute at @s rotated as @e[tag=tspire_kb_rot,limit=1] rotated ~ 0 run tp @s ^ ^ ^5`**
      （**`rotated ~ 0` 抹平俯仰角**，推进方向 = 「Boss → 玩家」的水平方向、任意角度精确、**Y 恒为 0**）→
      `kill @e[tag=tspire_kb_rot]` + `tag @s remove tspire_kb_victim` + 脚下云粒子。
      **旧的外推 dx/dz 机（两文件共约 40 行）已全删**（`#KB_*` 全项目 0 次出现）。
      **⚠️ 别误读**：`#RK_*` **没有全删** —— 三冷却 `#RK_C1..C3`、8 秒观察窗 `#RK_LOOK`/`#RK_DMG`/`#RK_LAST`/`#RK_NOW`/`#RK_TMP`、
      再锻 `#RK_T`/`#RK_ARM`/`#RK_BUFF`、王权征召 `#RK_T2`/`#RK_ARM2`/`#RK_G` **都还在用**（属重铸之王的其它机制）。
       **收尾**：`test/boss_arena_setup` 清场新增 `kill @e[tag=tspire_kb_rot]`（兜住中断残留）、
      `boss/recastking_bulwark` 第 8 行注释改成"任意方向的水平外推，Y 不变"。
      **⚠️ 纯注释瑕疵（不影响行为、validate 照常 PASS）**：两个击退文件的头部注释里有 **3 处转义符吃字** ——
      第 8 / 12 行的「\<TAB>p @s …」应是 `tp`（`\t` 变 TAB 吃掉 `t`）、第 10 行「otated ~ 0 …」应是 `rotated`（`\n` 变换行吃掉 `r`，还把第 9 行顶成空行）。
      **命令本体（第 25 行那两条 `tp`）完全正常**；但"写文件时把 `\t` / `\n` 当转义处理"这个手法若落在命令行上就是又一次加载失败，建议留意。
      **(d) 新增 `validate.ps1` 规则 §4f（第 13 条）：不许写死血量门**：非 `test/` 目录下任何 `scores={…tspire_boss_hp=<数字或 ..数字>}` → **FAIL**
      （提示 `boss HP scales with the party, use '#BNOW' vs '#TH_*' (or a 0/1 flag score)`），**`test/` 豁免**（诊断函数要打印真实血量）。
      规则注释里如实记了 **v0.6.61 #27（`..300`/`..425`）** 与 **v0.6.62 #31（`..375`）** 两次事故。
      **自测：临时造一行 `scores={tspire_boss_hp=..150}` → 准确 FAIL 并指出文件行；删除后复跑 PASS。规则总数 12 → 13 条。**
      **(e) 全项目现状**：`boss/` 下**再没有任何 `scores={…tspire_boss_hp=<数字>}` 的门**（只剩 `boss/moltenlord` 第 18 行一条解释性注释）；
      淬火者【灰烬重生】、锈刃督军【亡者征召】、铭刻者【时间书虫】/【遗忘蚀刻】等门**全部读 `#BNOW` vs `#TH_*`**。
      **(f) 顺手改掉的三处文档旧账（v0.6.62 复核）**：① 文档把 validate 的三条"逐行命令检查"标成 §4d / §4e / §4f 是**笔误**（§4f 现在指血量门规则），已改正并加了编号说明；
      ② 锈刃督军"**三处源码文案仍是旧的**"里**有两条其实早已改好**（`rusblade_summon` 第 1 行写"残血改为 3 只"、第 6 行写"低于 50% -> 3 只"、第 21 行 actionbar 已是"3 只增援"）——
      **真正还剩的旧注释只有两处**：`boss/rusblade` 第 7 行"召唤数量翻倍"、`boss/tick` 第 40 行 + `boss/active` 第 73 行"残血翻倍"（**实际是 2 → 3 只，不是翻倍**）；
      ③ 文档里"**重铸之王仍是唯一在跑占位阶段的 Boss**"与"**仍有 9 条 playsound 未锚定**"**都早已作废**（前者 v0.6.57 落地、后者 v0.6.60 清干净），已就地标注 ❌ 已作废。
- **v0.6.28（未单独立条目，代码里可查）**：开局护甲**旅行者 / 黏液套装允许 2 级材料**
  （`gen-starter.ps1` 的 `$ARMOR_TIER_OVERRIDE`）；**《尖塔地图》成书不再发放**、
  但 **`tconstruct:encyclopedia`（工匠大百科）改回照常发放**（`run/give_kit` 注释写明"上一版误删了"）；
  工匠**共鸣 / 融合改成"每个工匠节点各限一次"**（节点 z 当钥匙，新计分板 `tspire_craft_node`）；
  部件制造台**不再塞金质模具**，改在旁边的箱子里备木制模具 + 毒液瓶（`artisan/put_cast` + 箱子）。
- `tools/build.ps1` / `tools/deploy.ps1` / **`tools/validate.ps1`**（离线校验器）
- **`tools/checklog.ps1` + `tools/logpath.txt`（v0.6.60 新增，改了流程）**：
  加载失败的函数**不会崩游戏**，只会在 `latest.log` 里留一句 `Failed to load function tspire:xxx`，
  **该函数从此永远不跑**（v0.6.60 就是这么同时丢了 5 个 Boss 函数，看起来像"Boss 不放技能"）。
  `validate.ps1` 只管源码，管不到"游戏有没有成功加载"，所以**每次 `/reload` 后必须再跑一次**：

  ```powershell
  powershell -ExecutionPolicy Bypass -File tools\checklog.ps1
  ```

  它会只统计**最近一次数据包加载**（以 `Server thread/INFO]: Loaded N recipes` 为界，忽略历史 /reload），
  打印函数名、报错行号与**当前源码对应行**，有失败就 exit 1。
  日志路径写在 `tools/logpath.txt`（UTF-8 一行），也可 `-Log <path>` 覆盖。
  `validate.ps1` 因此新增 3 组规则（累计 12 条）：行首裸子命令（缺 `execute`）、
  `run as/at/...`（`run` 不在链尾）与 `/data ... entity` 少 `limit=1`、**1.20.1 粒子 id 白名单**。

**未完成**

- 护甲三选一（`gui/pick_armor` 仍是桩，当前只发武器）
- 存档写盘（§13.2 里 `storage tspire:run` 快照 / 节点结算写盘 / `init.mcfunction` 读回都还没做；
  **跨 `/reload` 的中断恢复已可用**，靠的是世界状态与计分板本身就存活，不依赖主动快照）

**有 3 处行为我没法离线确认，需要你实机看一眼**（`docs/E2E.md` 里有打勾清单）：

1. `execute store result score ... if entity ...`（不带 `run`）**会不会刷聊天栏**
2. ~~`spawnpoint` 在自定义维度里能不能把重生点留在塔内~~ —— **v0.6.24 已有实测结论：不可靠**，
   阵亡会被丢回主世界（MC-240812）。现在**不再单独依赖它**，见下方 v0.6.24 与「已排除的错误路径」。
3. `/damage @s <n> minecraft:magic` 扣血会不会被保护附魔削弱太多

---

## 6.5 技术验证结论（已全部跑完）

| 能力 | 手段 | 结论 |
| --- | --- | --- |
| 构造任意材料的匠魂工具 | 直接写 `tic_materials` | ✅ V1 通过 |
| 让怪拿匠魂武器并真的更疼 | 匠魂工具自带攻击属性 | ✅ V2 通过（玛玉灵剑秒杀玩家） |
| 随机材料生成工具 | `tconstruct:add_tool_data` + `{"type":"tconstruct:random","tier":N}` | ✅ V3 通过 |
| **给怪发装备** | `summon` 空手怪 + `loot replace entity @s weapon.mainhand loot <表>` | ✅ **V7 通过** |
| `mob_equipment` 注册表 | ❌ 对 `/summon` 生成的怪不生效（挂在 Forge `FinalizeSpawn` 上） | **弃用** |
| 材料池用 tag | ❌ 三种写法都失败（`tconstruct:tag` 不是有效谓词） | **改用 `tier` 随机** |

> **架构已锁定：纯数据包。** `D:\forge-1.20.1-47.4.10-mdk` 不需要启用。

**出怪标准写法**（V7 验证）：

```mcfunction
summon minecraft:zombie ~ ~ ~ {Tags:["tspire_mob","tspire_mob_new"],PersistenceRequired:1b}
scoreboard players set #TIER tspire_timer 2
function tspire:mobs/equip          # 内部按 #TIER 分支，给主手 + 四件盔甲塞匠魂装备
tag @e[tag=tspire_mob_new] remove tspire_mob_new
```

**装备表由脚本生成，不要手写**：

```powershell
powershell -ExecutionPolicy Bypass -File tools\gen-gear.ps1
# 产出 25 张战利品表（weapon/head/chest/legs/feet × tier0~4）+ 6 个装备函数
```

> **槽数是硬约束**：`add_tool_data` 的 `materials` 数组长度必须等于工具槽数（见 `docs/PARTS.md`），
> 多了会被**静默跳过**（不报错、面板偏低）。生成脚本里的 `slots` 字段就是干这个的。

**已排除的错误路径**（别再走）：
- ❌ `Compress-Archive` 打包（反斜杠分隔符，Java 读不到）
- ❌ `bossbar set <id> color gold`（bossbar 没有 gold 色）
- ❌ `tconstruct:randomized`（内部类名，注册 ID 是 `tconstruct:random`）
- ❌ `data/<ns>/tags/materials/`（材料 tag 在 `data/<ns>/tinkering/tags/materials/`，但引用方式未确认）
- ❌ **命令参数之间写两个空格**（为了对齐）→ Brigadier 的 `Vec3Argument` 每个坐标分隔**只吃掉一个空格**，
  于是 `pos` 参数解析失败、**整个函数加载不了**（报 `缺少"{"`，日志里是 `Failed to load function`）。
  JSON 字符串内部的双空格不受影响，只有命令参数区不行。
  **所有 mcfunction 的命令参数一律单空格**；对齐用注释或换行，不要用空格。
- ❌ **`dimension` 的 `generator.settings` 写成预设 ID 字符串**
  （`"settings": "minecraft:the_void"`）→ 报 `Not a JSON object: "minecraft:the_void"`，
  **注册表加载失败、存档直接进不去**。1.20.1 这里必须是**内联 JSON 对象**。
  正确写法见 `data/tspire/dimension/tower.json`（照抄原版 `the_void` 预设的内联内容）。
- ❌ **`playsound` 用 `player` 声道** → 「玩家」音量滑块在多数玩家的设置里都很低
  （本机 `options.txt` 实测：master 0.46 / player **0.16**，乘起来≈7%，等于听不见）。
  数据包音效一律用 **`master`** 声道。
- ❌ **抽取链忘记设短路标记 `#PICKED`** → 谓词链会**依次全部命中**，
  而每个 Boss 生成函数开头都有 `kill @e[tag=tspire_boss]` 把前一个杀掉，
  结果**永远是链尾那个**（d1 概率 100%）。
  凡是 `if predicate ... run function` 链，被调用的函数**必须**置 `#PICKED=1`。
- ❌ **嵌套战利品表条目写 `"value"`** → 报 `Missing name, expected to find a string`，
  **整张表加载失败**（连带里面所有奖励一起失效）。字段是 **`"name"`**：
  `{"type":"minecraft:loot_table","name":"tspire:rewards/crystal","weight":30}`
- ❌ **材料部件不按 stat type 过滤** → 生成出 `small_blade{Material:"tconstruct:string"}`
  这类**永远用不上**的废部件。材料只对它声明过的 stat type 有效，
  必须先用 `data/tconstruct/tinkering/materials/stats/<material>.json` 过滤。
  另外 **`large_plate` 不能做奖励**：3.12 里没有任何材料声明 `large_plate` stat。
- ❌ **手工维护材料 tier / 联动清单** → 既漏又错。正确做法是全部从匠魂数据推导：
  - **tier**：读 `materials/definition/<m>.json` 的 `tier` 字段
  - **联动材料**：定义里带 **`condition`** 字段（`mantle:tag_filled: forge:ingots/x`）
    的就是联动材料，共 16 个，见 `tspire:compat_excluded` 标签
  - **别名**：带 `redirect`；**隐藏**：`hidden: true`——两者都不入池
- ❌ **材料谓词写 `tconstruct:and` / `tconstruct:tag` / `tconstruct:invert`**
  → 报 `Unknown Material Predicate loader`。**只有 mantle 的包装器有效**，
  写法抄匠魂自己的 `mantle/loot_injectors/spawn_bonus_chest.json`：
  ```json
  "material": { "type": "mantle:inverted", "inverted_type": "mantle:tag",
                "tag": "tspire:compat_excluded" }
  ```
  材料 tag 文件放 `data/<ns>/tinkering/tags/materials/<name>.json`。
- ❌ **`.ps1` 里写中文路径** → PS 5.1 按 ANSI 读无 BOM 脚本，路径会变乱码。
  带中文的路径一律放独立 UTF-8 文本文件，脚本用
  `Get-Content ... -Encoding UTF8` 读（见 `tools/tc-source.txt`、`tools/target.txt`）。
- ❌ **`.ps1` 里写中文字面量**（包括**中文注释**）→ 同一条 ANSI 原因，
  报错会是**连锁的、报错行往往不是真正出问题的那一行**（表现为 `Missing ')' in method call`、
  `Unexpected token`）。生成器要用的中文一律放 UTF-8 的 JSON（见 `tools/shop-text.json`），
  用 `Get-Content -Raw -Encoding UTF8` 读，`$obj.key` 访问。
- ❌ **PowerShell 双引号里用 `\"` 转义**（C/Java 习惯）→ PS 不认，直接语法错误。
  双引号里转义引号要用 `""`；含大量 JSON 的行直接用**单引号字符串**拼接。
- ❌ **函数参数命名成 `$Args`** → `$Args` 是 PowerShell 的自动变量，
  会覆盖掉你传进来的数组，导致 `-f` 格式化时参数个数为 0、模板原样输出
  （症状：生成的菜单里出现 `[{0}] {1} · {2}` 这种占位符）。换个名字。
- ❌ **把 `-f` 直接跟在一段字符串拼接后面**（v0.6.21 商人生成器踩到）：
  `'a{0}' + $x + 'b{0}' -f $i` **只会把 `-f` 绑到最后一个字符串片段**上
  —— PowerShell 里**格式化的优先级高于拼接（`+`）**，所以 `{0}` 根本没被替换，
  `{{` 也不会被解转义，生成出来的函数里会留着字面 `{0}`。
  **原因**：`-f` 是运算符，优先级高于 `+`，等价于 `'a{0}' + $x + ('b{0}' -f $i)`。
  **正确写法：把整段拼接用括号包起来再 `-f`** —— `('a{0}' + $x + 'b{0}') -f $i`。
- ❌ **用 `$lang.$key` 查匠魂语言文件时忘了剥命名空间** → key 变成
  `item.tconstruct:broad_blade`（带冒号），查不到就回退成英文 ID。
  正确 key 是 `item.tconstruct.broad_blade`。
- ❌ **看不见的坑：Brigadier 的 `matches` 范围**。判断"钱够不够"不能用
  `execute if score @s gold matches <变量>..`（`matches` 只吃字面量），
  要么用 `scoreboard players operation` 先算差值再 `matches 0..`，要么按价格写成固定函数。
- ❌ **多分支提示漏掉一支**（商人「已售出」不提示的真凶）：原来的购买函数是
  「钱够 → 取货」「金币不足 → 提示」，但**货架空了**时两条都不成立 → 点了完全没反应。
  凡是"条件 → 提示"的分支，**必须有一个兜底分支**，或者先把状态算进一个显式标记
  （现在用 `#STOCK`）再分别判断。
  **v0.6.21 注**：商人改成每人一份货架后，`merchant/buy/slot<n>` 里的 `#STOCK` 检查**保留**了
  —— 对自己那份货架它理应恒为 1，留着是为了让"货架数据坏了/只建了一半"这种异常**明确报错而不是静默无反应**。
  真正的"已经买过"改由 `tspire_buy<n>` 判定，两者是不同分支。
- ❌ **以为 `add_tool_data` 只能走战利品表** → 它就是个普通 `LootItemFunction`，
  放 `data/<ns>/item_modifiers/` 里用 `item modify entity @s <slot> <modifier>` 也能用，
  而且是**改手上那件物品**（只调 `setMaterials`），**保留强化/升级/耐久**。
  走 `loot replace` 会整件替换、强化全丢。「重铸」就是靠这个做出来的。
- ❌ **以为 `add_tool_data` 的 `materials` 需要逐槽挑材料** → 反编译显示它内部用
  `ToolMaterialHook.stats(def)` 拿到该工具每个槽的 stat，再让 `RandomMaterial.build`
  按槽抽，所以**材料选得对不对不用我们管**。只要 `materials` **长度等于槽数**即可。
- ❌ **改了生成器/删了文件却留下悬空引用** → `test/v4_material_tag` 一直引用着两张
  早被删掉的战利品表（`tspire:test/forge_sword_tagged` / `_tag2`）。**这类错误
  Minecraft 只会打日志，不会中断运行**，所以能潜伏很久。
  这就是 `tools/validate.ps1` 存在的理由：**每次改完先跑它**，别再靠肉眼。

- ❌ **用 `ReadAllLines` + `WriteAllLines` 做"插入一段"的批量改写**（**这次真的把主设计文档写没了**）。
  当时的写法是 `$out = $lines[0..($at-1)] + $block + $lines[$at..]`，而 `$at` 因为查找串没匹配上变成了 `$null`：
  PowerShell 里 `$lines[0..-1]` 不是"从 0 到末尾"，而会被解释成**索引 0 和 -1 两个元素**，
  于是整个 2100 行的文档被写成了 13 行。
  **教训**：
  1. 改 `.md` 一律用 `edit` 工具做**定点替换**，不要整文件重写；
  2. 真要整文件重写，**先 `Copy-Item` 一份备份**；
  3. 脚本里凡是 `$x[0..($at-1)]` 这种切片，**必须先断言 `$at` 有值**；
  4. 写完立刻 `(Get-Content).Count` 对一下行数，别等下一次读才发现。
- ❌ **`/fill` 一次超过 32768 格 → 静默失败**（不报错、只是不生效）。
  塔一层体积 59 × 8 × 203 ≈ 9.6 万格，一次填/清必然超限。
  所有大范围地形操作都按 Z **分带**，每段 ≤ 3.2 万格（见 `map/clear_floor`）。
- ❌ **在未加载的区块里 `fill` / `setblock` → 静默失败**。
  一层在 Z 轴长 200 格，玩家的加载半径根本覆盖不到远端，
  于是"房间只生成一半""重开也不干净"。
  修法：`map/clear_all` 里 `forceload add -32 -192 32 32`（56 个区块）常驻加载。
- ❌ **从函数标签（`#load` / `#tick`）里 `tellraw @s`** → 那里是**服务器身份，没有 `@s`**，
  命令直接失败且不报错。凡是给玩家的聊天界面，必须
  `execute as @a[team=tspire_party] run function ...`。
  「开局构筑没生效」就是这个原因。
- ❌ **只靠 tag 做"锁门"** → 节点不触发，但**玩家照样能走进房间**。
  路线选择必须有**物理隔离**：锁着的房间把门堵死
  （`map/seal_doors` / `unseal_doors` / `refresh_doors`）。
  **v0.6.25 更新**：永久封条改用 `tools/geometry.json` 的 **`sealBlock`**（默认
  `minecraft:polished_blackstone_bricks`，**可见**）而不是透明的 `barrier` ——
  看不见的墙玩家会当成"门还开着"；`terrain/lock` / `unlock` 的**临时战斗封锁仍用 `barrier`**（刻意区分）。
  同时 `refresh_doors` 只开 `avail` / `current`，**`done` 也封**（不能回头），见本文件「已完成」的 v0.6.25 一节。
- ❌ **房间之间留缝** → 房间宽 15、列间距 16，中间就有 1 格宽的通缝，
  玩家能顺着缝一路走到 Boss。地形必须**先整体填实、再挖房间与走廊**，
  不要"铺光板 + 给每个房间套墙"。
- ❌ **生成"谓词链 + 短路标记"时不置 `#PICKED=1`**（**这条坑本文档早就写过，结果自己在生成器里又犯了一次**）。
  `starter/pick` 与 `shop/pick_f*` 的抽选器都靠 `if score #PICKED matches 0` 短路，
  但生成的 `l<k>` 函数没把 `#PICKED` 置 1 → **6 份/8 份方案连着全跑一遍**，
  最后一个覆盖前面所有的（箱子、`#LOADOUT`、菜单全乱）。
  修完请顺手确认产物里出现过 `scoreboard players set #PICKED tspire_timer 1`。
  （**v0.6.23 注**：`starter/pick` 与 `#LOADOUT` **都已删除**，开局抽选改由生成的 `starter/roll` 逐人掷；
  `shop/pick_f*` 的 `#PICKED` 短路**仍在**，这条教训对它依然适用。）
- ❌ **把玩家 tp 进还没建好的塔**。塔是虚空维度，`tp` 过去直接掉下去；
  一秒后再建地面已经来不及。开局流程必须**两拍**：
  `#PICK_STAGE=1` 只做 forceload + 建场景（不碰玩家），`=2` 才传送。
- ❌ **房间之间的缝 = 玩家可以绕路**。同理，**没有顶 = 蜘蛛可以爬出去绕路**。
  路线选择是**物理约束**，不是逻辑标记：既要填实周边、门窗用屏障管住，
  还要给整层盖一层 `minecraft:barrier`。
- ❌ **冒险模式不是可选项**。不给 `adventure`，玩家直接把墙挖穿。
- ❌ **状态守卫卡死自己**：「本局已经在进行中」用 `tspire_phase matches 1..5` 判断，
  只要上一次开局在**构筑阶段**断掉，phase 就永远停在 2/3，
  之后每次 `/function tspire:run/start` 都被挡回去 —— 表现为"功能根本没做"。
  **守卫要挑一个只有"真的在玩"时才成立的信号**（这里改成 phase 5 主循环），
  并且永远留一个**强制重开**的入口 + 一个**自检命令**。
- ❌ **"功能没生效"先看日志，不要猜**。日志里一句话就能定死方向：
  `Failed to load function tspire:starter/l1` + `Whilst parsing command on line 14: Unknown item`。
  一个**未知物品 ID 会让整个函数解析失败**，命令全都不执行，而且游戏里没有任何提示。
- ❌ **工具定义的**文件名**不等于**物品 ID**。`tool_definitions/slime_chestplate.json` 对应的物品是
  `tconstruct:slimy_chestplate`。凡是从定义文件推物品 ID 的地方，都要拿 `lang` 的
  `item.tconstruct.<id>` 反查一下，查不到就**让生成器直接报错**。
  `tools/validate.ps1` 现在会检查 `give` / `item replace ... with` / `clear` 的物品 ID。
- ❌ **`@e` 选择器忘了维度**：塔里的实体（节点 marker、货架箱、构筑箱、宝箱、锚点、商人 NPC）
  只有加了 `execute in tspire:tower` 才找得到。`map/build_floor` 里一句
  `kill @e[tag=tspire_node]` 少了前缀，从 `tick/second`（主世界身份）调用时**一个都没删掉**，
  新地图 marker 叠在旧的上面 → **一行挖出 5~7 个房间**，而且**游戏里一点报错都没有**。
  `tools/validate.ps1` 现在会检查这一类（只存在于塔维度的 tag 在 `kill`/`tag` 里必须带维度）。
- ❌ **"防重复触发"加过头变成"延迟触发"**：战后 2 秒冷却会让**每一个**后续节点都晚 2 秒响应。
  防重复应该靠"节点只消费一次"（`tspire_node_spent`）而不是全局冷却。
- ❌ **往 NBT 字符串里写 `\n`**：**SNBT 只认 `\"` 和 `\\`**。裸的 `\n` 会让**整条命令**解析失败
  （`invalid escape sequence "\n"`），进而让**整个函数加载不了** —— 地图预设全灭，
  表现就是"房间一个都没生成、书也没发"。要换行必须写 **JSON 文本组件**（JSON 才懂 `\n`），
  再整体做一次 SNBT 转义，文件里长成 `\\n`。
  `tools/validate.ps1` 现在会检查裸的 `\n` / `\t` / `\r` / `\u`。
- ❌ **"三选一"不等于"三种各来一个"**：开局护甲的三个候选要**独立随机抽**（允许重复），
  否则每个部位永远固定三种套装各一，玩家看不到变化。
  **v0.6.22 一度推翻了这条**（改成对套装池取洗牌排列、一格内必三套不同）；
  **⚠️ v0.6.23 已恢复原规则**：玩家确认**"一格里重复出现同一套装"本来就是设计内行为**，
  所以 `tools/gen-starter.ps1` 回到"三个候选各自从套装池**独立**随机抽"，
  `@($ARMOR_SETS | Sort-Object { Get-Random })` 那套洗牌排列**已撤掉**，一格内重复是预期行为。
  变化由**每人各掷一份方案（v0.6.23）+ 部位↔套装的对应关系逐份随机 + 材料随机**提供，**不靠禁止重复**。
  **教训：凡是"从 N 个候选里出 M 个"，先问一句"M 个之间允许重复吗" —— 需求没说要禁止就不要自作主张禁止；
  玩家说"看起来像 bug"往往只是观感，改之前先确认。**
- ❌ **用「箱子空了就收摊」来实现三选一是不可靠的** —— 1.20.1 没有只读容器，玩家一次 shift 全拖就能在检查之前拿走全部三件。
  正确做法是给容器加 `Lock` 标签让它物理上打不开，再用可点击聊天三选一。
  **原因**：`tick/tower` 的每 tick 检查再快也只是"事后发现"，而 shift 全拖是**单次操作**，命令级的逐格检查永远追不上；
  把"玩家能不能开箱"这件事交给方块实体自己（`Lock`）而不是靠命令轮询，才真正封死。
  附带收益：箱子不必销毁，可以留在原地让每名队员各领一份（用 `tspire_offer` 计分板防重复领取）。
  代价：**菜单印不出候选属性**（候选运行时随机抽，写文案时不知道抽到什么），只能写「候选 1/2/3」。
  **（v0.6.22 已解决**：候选改成**生成期预生成的具体物品**，菜单直接写部件名 + 材料名 —— 见 §变更记录 v0.6.22 第 2 条。）
- ❌ **用 `data get entity @s Health` 取血量做 HUD** → 会刷命令反馈（`data get` 把结果打进聊天栏，
  再乘上每秒调用，聊天栏直接报废；`tick/second` 里那段 HUD 就是这么被注释掉的）。
  **改用原版 `health` 判据计分板 `tspire_hp`**（原版自动同步，0 条命令维护），
  其余数值用 `scoreboard players operation` 搬运（本身不产生输出）。
- ❌ **把 `deathCount` 判据的 `tspire_deaths` 直接当阵亡计数器** → `party/die` 里必须把它清零
  才能当"一次性触发器"用，所以它**永远是 0**。**另开 `tspire_death_total` 当计数器**（`party/die` 里 +1）。
- ❌ **在 `tspire:load` 里清零 `#RUN_STARTED` / `#PICK_STAGE`** → 会让**每次 `/reload` 悄悄掐死进行中的一局**：
  塔、节点、装备、分数全都还在，只有主循环的开关被关掉。这两个值只在 `run/start_run`（开新局）
  与 `run/force_start`（强制重开）里改。
- ❌ **在 `score` 文本组件里用字面 holder 名当"纯数值"** → 字面名（如 `#HUD_FLOOR`）会渲染成 **`名字: 数值`**，
  只有**选择器**（如 `@a[team=tspire_party,limit=1]`）才只渲染数值。bossbar 标题要纯数值，必须用选择器形式。
- ❌ **在 `load/join` 里用 `scoreboard players set @s <obj> 0`** → `tspire:load` **每次 `/reload` 都会调 `load/join`**，
  于是**每次 reload 把所有人的 `phase` 和金币清零**：塔、节点、装备全都还在，只有进度和钱被静默销毁，进行中的一局直接死掉。
  **原因**：`load/join` 是**幂等入队**函数，不是"新局初始化"。**要物化缺失分数就用 `scoreboard players add @s <obj> 0`**（缺的变 0、已有的不动），
  真正的逐人重置留在 `run/reset_player`。**凡是挂在 `/reload` 路径上的函数，一律先问一句"它会不会改玩家已有的数值"。**
- ❌ **用 `execute if score @s tspire_wcount matches 2 run function tspire:run/begin_run` 直接开局** → 多人下**第一个选完武器的人**
  就把全队拖进主循环（`begin_run` 置 phase 5、开 HUD），**其他玩家的构筑被腰斩**，手里一把武器都没有。
  **原因**：`wcount` 是**每人一份**的进度，而"能不能开局"是**全队**条件。要先把"还没选完的人数"统计进一个共享分数
  （现在用 `#PICK_LEFT`），**只有它为 0 才开局**。§13.11.5 的"全队就绪"约定在这里第一次真正被用到。
- ❌ **三选一按"队里第一名玩家"的手持工具预抽候选**（`rewards/offer_held` + 共享 Lock 宝箱）→
  第二个玩家**拿着另一把武器**点按钮，就会拿到**自己武器根本用不上**的部件（比如给剑抽到弓臂）。
  **原因**：候选是**共享的一次抽取**，而"能用什么部件"是**每人各自**的。必须改成**点击时以点击者本人身份现抽**
  （`rewards/offer_roll` → `offer_roll_f<层>` + `loot give @s`），三个按钮对应**该玩家自己工具的 3 个部件槽位组**
  （`part_for/<工具>_f<层>_<1|2|3>.json`，按 `部件序号 % 3` 拆分，空组回退整表）。宝箱只剩视觉作用。
  **（v0.6.22 再进一步**：连"点击时现抽"也放弃了 —— 改成**生成期预生成具体候选**，
  菜单因此能印出部件名与材料名，`offer_roll` 与这 198 张表一起删除。见 §变更记录 v0.6.22 第 2 条。）
- ❌ **把 `@s tspire_phase` 当 `run/start` 的唯一守卫** → 多人下**第二个玩家自己的 phase 常常还是 0**，
  他随手打一次 `run/start` 就能**把全队正在进行的一局重置掉**（而且他自己看不出任何异常）。
  **原因**：守卫要挑一个**全队共享**的信号（现在用 `#RUN_STARTED`），并且永远留一个**强制重开**的入口
  （`run/force_start`）与一个**加入当前局**的入口（`run/join_mid`）——这条和上面「状态守卫卡死自己」是同一条教训的两个方向。
- ❌ **`execute unless score @s X = #FLOOR` 漏了源计分板**（v0.6.22"第四行商人节点走进去没反应"的真凶）：
  完整语法是 `execute if|unless score <目标> <目标计分板> <运算符> <源> <源计分板>`，**两个计分板名都是必需的**。
  漏掉源计分板 → Brigadier 报 `Whilst parsing command on line 47 … #FLOOR if <--[HERE]`，
  **整个函数加载失败**，于是商人节点完全没反应（`merchant/open_own` 里同款写法一起坏，**购买也一并废掉**），
  而游戏里**一点提示都没有**，只能看 `latest.log`。
  **原因**：解析错误 = **整个函数不存在**，不是"这一行不生效"。凡是"某个节点/按钮完全没反应"，**先看日志有没有 `Failed to load function`**。
  `tools/validate.ps1` 已加规则（§4b）专门抓这个写法；**加完当场就抓到了第二处**。
- ❌ **可复用节点上的 `tspire_node_current` 离开时不清**（v0.6.22"打到第三行被传回第二行工匠"的真凶）：
  工匠 / 商人节点打了 `tspire_node_reusable`，重复进入会**重新**打上 `tspire_node_current`，但它们不会再跑 `complete_node`，
  所以**没有任何地方会摘掉这个 tag**。残留后场上同时有"上一个服务节点"与"当前战斗节点"两个 current，
  而 `@e[tag=tspire_node_current,limit=1]` 只会**任选一个** —— "拉队友进房间"于是把全队传回了上一层的工匠节点。
  **原因**：`limit=1` 只在**确定性唯一**的前提下才等于"当前那个"；一旦可能不唯一，它就是一个**随机选**。
  修法：`map/enter` 开头强制清场 + `map/enter_service` 打 tag 前清 + `map/player_check` **每 tick 无条件**收回 +
  `run/battle_start` 用 `tag=!tspire_node_reusable` + `distance=8..200` 加固（规则见设计文档 §3.1.2）。
  **通用教训：给某类实体打"唯一"tag 的代码，必须同时负责"什么时候摘掉"。**
- ❌ **用 `<已选标记> == 1` 当"要不要重发菜单"的判据**（v0.6.22"同一部位两条相同说明"的第二半）：
  `run/apick_<S>_<T>` 里那句 `if score @s tspire_arm<S> matches 1 run function …`（重发整份护甲菜单），
  在"刚刚选了这一项"与"点了一个早就选过的项"两种情况下**都成立**，于是重复点击会把整份菜单**再刷一遍**。
  **原因**：这个判据回答的是"现在选了吗"，而这里要问的是"**这次点击之前**选了吗"。
  正确写法：先把点击**之前**的状态记进一个临时标记（现在用假玩家 `#DUP`：置 0，若已选则置 1），
  只有 `#DUP == 0`（=这次是首次选）才重发 / 推进界面。`run/wpick_<i>`（武器）同样处理。
  **通用教训："状态"与"状态的变化"是两个问题，判据不能共用。**
- ❌ **用全局假玩家 `#LOADOUT` 存开局抽选方案**（v0.6.23 的核心修正）：
  抽选结果是**每人各有一份**的东西，存在 `#LOADOUT` 上就等于**全队共用一份** ——
  多人下两个玩家同一部位看到的 3 个选项**完全一样**（实测反馈："我希望每个人都只看到自己的选项，
  包括后面奖励三选一的界面"）。**原因**：假玩家是**全局**的，任何"每人一份"的状态放上去都会被全队共享。
  **凡是"每名玩家各自不同"的状态，一律挂在玩家身上**（现在用 `@s tspire_draft_l`，1..6）。
  修法：删掉 `#LOADOUT` 与 `starter/pick`，新增生成的 `starter/roll`（逐人掷）+
  `starter/own_fill` / `own_armor_menu` / `own_weapon_menu`（按 `@s` 分支）；
  共享的那只 `Lock` 箱子改成"**取货前按点击者重摆**"
  （`at @e[tag=tspire_starter,limit=1] run function tspire:starter/own_fill`，放在 `run/take_<idx>` 之前）。
  **教训：玩家级状态、全局状态、队伍级状态，三者不能混用同一个载体。**
- ❌ **`loot give @a[...] loot <表>` 当"每人一份"发**（v0.6.23 实测"每个玩家的随机奖励一模一样"）：
  这条命令把整张表**骰一次**，然后把**同一份结果**发给所有目标 ——
  它的掷骰上下文是**执行者**，选择器里塞多个目标**不会各骰一次**。
  **每人各骰一次必须写 `as @a[...] run loot give @s loot <表>`**，让每个人各自成为执行者。
  `rewards/battle` 与 `map/enter_chest` 都已按此改（`run/join_mid_do` 原本就是 `loot give @s`，正确）。
  **教训：`loot give` / `loot replace` 的随机是"以执行者为单位"的；想每人一份就 `as ... run ... @s`。**
- ❌ **靠 `/spawnpoint` 在自定义维度里定重生点**（v0.6.24 玩家实测"死亡后直接回主世界"的真凶）：
  `/spawnpoint` 在**自定义维度**上不可靠（Mojang 追踪单 **MC-240812**「/spawnpoint is inconsistent」，
  复活会落到主世界的世界出生点），而且**重登 / 换维度后还会丢**；`doImmediateRespawn` 又会在玩家一死时
  立刻按它把人塞回去，于是旁观者直接出图，`latest.log` 里维度管线在 `tspire:tower => minecraft:overworld` 反复翻转。
  **正确做法 = "每秒重设 + 每 tick 检测到不在塔维度就拉回队伍身边"**：`tick/second` 按层每秒重设一次
  `spawnpoint`（`0 64 10` / `0 96 10` / `0 128 10`）；`party/die` / `party/revive_self` / 出图兜底三处
  都调新增的 `tspire:party/gather`（优先活着的塔内队友 → 任何塔内队友 → `tspire_node_current` → `tspire_anchor`）；
  `tick/player` 每 tick `unless entity @s[nbt={Dimension:"tspire:tower"}]` 兜底拉回。
  **教训：原版命令在自定义维度上的行为要按"可能不生效"来设计，关键流程必须有第二来源兜底。**
- ❌ **让 `mobs/groups/*` 或 `boss/spawn/*` 去写 `#FLOOR`**（v0.6.25"打第 1 层出来第 3 层 Boss"的真凶）：
  那些文件里的值**写错了**（第 2 层 Boss 写 3、第 1 层写 2），于是第 1 层打 `rusblade` / `mirehunter` 时
  `#FLOOR` 中途被改成 2，击杀后 `run/floor_advance` 再 +1 得 3，**`run/next_floor` 直接把全队送到第 3 层（Y=128）**；
  `mobs/equip` 也读 `#FLOOR`，Boss 因此拿到错档装备。
  **原因**：`#FLOOR` 是**全流程唯一的"当前层"来源**（出怪池、装备档位、换层都靠它），
  既然后续 `floor_advance` 会 +1，任何"顺手写一下"的地方都会把它算错两层。
  **修法：`#FLOOR` 只能由 `run/start_run` 与 `run/floor_advance` 改**，
  `mobs/` 与 `boss/` 下的文件一律不写（`tools/validate.ps1` §4c 离线兜住；
  `tools/gen-groups.ps1` 也不再生成为怪物组写这一行 —— 那一行本来就是冗余的，`roll_group` 已按 `#FLOOR` 分支）。
  **通用教训：像 `#FLOOR` 这种"单一真相"的全局分数，写入口越少越好；多一个写入点就多一个能把整局算错的地方。**
- ❌ **用 `at @e[tag=tspire_node_current]` 给可复用服务节点的逻辑定位**（v0.6.25"两人买到同一份货"的真凶）：
  `merchant/buy/slotN` 原来靠它把 `tspire:merchant/open_own` 定位到柜台上，
  但**这个 tag 在可复用服务节点上是短暂的**（`map/player_check` 每 tick 会把它收掉），
  于是命令**静默不执行**（`execute at @e[...] run ...` 找不到实体就什么都不做，**不报错**），
  买家拿到的是共享箱里剩下的那份货 —— 也就是**最后走进来的那个人**那份。
  **原因**：`tspire_node_current` 表示的是"队伍此刻所在的节点"，对**可复用**节点它是**瞬时**状态，不是稳定锚点。
  **修法：改以买主本人身份、不带位置前缀跑**（`execute if score @s tspire_buy<n> matches 0 run function tspire:merchant/open_own`，
  `deliver_<n>` 本来就会重新解析 marker）。
  **通用教训：把"短暂状态 tag"当定位锚点用之前，先问一句"它在这一拍还在吗"。**
- ❌ **在 `.ps1` 注释里写中文**（v0.6.25 再补一例）：PS 5.1 把无 BOM 的 `.ps1` 按 ANSI 读，
  中文注释 mojibake 之后会**吞掉紧随其后的那一行**，而且**不报任何错**。
  本次是 `tools/gen-shops.ps1` 里一条中文注释吞掉了后面那条 `AppendLine`，
  生成的 `merchant/sell.mcfunction` **少了一条强化水晶收购规则**（水晶因此卖不掉，且现场毫无提示），
  最后是靠 `tools/validate.ps1` 既有的"`.ps1` 纯 ASCII"检查抓到的。
  **规则不变：`.ps1` 里一个中文字符都不要有，包括注释**；要用的中文放 UTF-8 的 JSON / 文本文件，用 `-Encoding UTF8` 读。
  **v0.6.26 第三次**（`tools/gen-rewards.ps1`）：同一类写法再次出现 —— 中文注释 mojibake 后吞掉随后的行，
  解析**死在下一行**（`Missing ')' in method call`，报错行**不是**真正出问题的那一行），
  同样是 `validate.ps1` 的"纯 ASCII"检查抓到的（**13 行非 ASCII**）。
  **四次都栽在同一件事上（**v0.6.27 第四次**：`tools/gen-groups.ps1` 又一次把中文写进 ps1 注释，
   一模一样的症状、一模一样的检查抓到它），已升级为固定陷阱：`tools\*.ps1` 里一个中文字符都不要有，注释也不行。**
- ❌ **用 UTF-8 去读 `latest.log`**（v0.6.27 调查商人 bug 时踩到，**实实在在耗掉了时间**）：
  Minecraft 的 `latest.log` 是 **GBK / ANSI 编码**，按 UTF-8 打开时**所有中文全是乱码** ——
  "日志里明明有中文报错"却什么都看不出来，很容易误判成"日志里没有有用信息"。
  **正确读法：用 ANSI（GBK，代码页 936）重新读** —— PS 5.1 里 `Get-Content -Encoding Default <日志>`
  （`Default` 就是系统 ANSI 代码页），或用能指定编码的编辑器切成 GBK。
  本次正是**切回 ANSI 之后**才看清那两行 `这一格你已经买过了（每人每格限购一次）。` 与
  `已执行函数tspire:merchant/buy/slot5中的9条命令`，从而定死商人"买不了东西"的根因。
  **通用教训：先确认日志的编码，再下"日志里没有线索"的结论。**
- ❌ **用「扫描所有 `tspire_node_done` 节点」的解锁规则**（v0.6.32"同一行其他房间没封口"的根因）：
  `map/unlock_next_row` 的写法是"**只要场上存在任一 done 节点，就解锁它下一行**"，
  而它**不区分是哪一行的 done、也不区分是什么时候完成的**。于是一个很早以前完成的旧节点
  会在它下一行**正好等于当前行**时，把 `map/node_begin` 刚刚锁掉的**同行兄弟房间重新开成 `avail`** ——
  路线约束直接失效，玩家能钻进本行别的房间（表现像"封口石没生效"，其实是封了又被开回来）。
  **证词**：`/function tspire:test/door_check` 在第 2 行打完一个宝箱节点后运行，输出显示同行其余房间
  **仍是 `avail`、南北门是空气**，而所有 `locked` 房间都正确封着封条石 —— 锁逻辑没错，错的是"解锁越权"。
  **原因**：规则写的是"存在 done"（全局面），而它实际想表达的是"**这一行**已有 done/current"（局部面）。
  **修法**：`unlock_next_row` 开头**先清扫**（对已有 done 的每一行 1..16，把该行剩余 `avail` 打回 locked
  并 `remove tspire_node_avail`），**每条解锁规则再加守卫 `unless 该行已有 done/current 节点`**。
  **通用教训：解锁条件里凡出现"存在某个状态的实体"，先问一句"是全体还是本行/本次"** ——
  选择器不加限定，历史状态就会永久生效。**排查路线问题先跑 `test/door_check`**（见 §3.6.4）。
- ❌ **把"可奖励的部件"写死成一张手维护的表**（v0.6.32"板斧奖励不到刃"的根因）：
  `tools/gen-rewards.ps1` 的 `$partDefs` 原本只有 **10 项**，**漏了 5 个部件** ——
  `pick_head`（镐头）、`hammer_head`（锤头）、**`broad_axe_head`（板斧刃）**、`adze_head`（锛头）、
  `large_plate`（大板）。后果是**任何用到这些部件的工具，对应槽位的部件永远不出现在奖励里**
  （最典型的就是板斧，玩家反馈"板斧的刃一直奖励不到"）。**不报错、不警告，只是永远抽不到。**
  修法：补上这 5 项（`stat` 均 `tconstruct:head`），`loot_tables/rewards/part_f1.json` **131 → 196 条**，
  `broad_axe_head` 现在确实在池子里。**这是一类 bug：手维护的表会静默漏项** ——
  改 `tool_definitions` / 加工具 / 改部件池之后，**必须回头核对 `$partDefs`**，
  别指望运行时报错（同类的还有材料 tier 表，那条已经改成从匠魂数据推导，见上文）。
- ❌ **以为 1.20.1 有办法"点燃实体"**（v0.6.30 做淬火者【燃烧蓄能】时踩到的边界）：
  1.20.1 **没有任何命令能让一个玩家/实体的着火计时开始** —— 能"点火"的只有
  **放置火焰方块**（`setblock fire`，会烧掉落物、会蔓延、会留残留），
  以及 `damage ... minecraft:in_fire` 这种**伤害类型**（只掉血、不点着火）。
  所以本项目里的"燃烧"只能二选一：
  **(a) 真实火焰方块**（玩家明确否决：会烧掉地上的掉落物）或
  **(b) 纯粒子 + 定期伤害**（**本项目最终采用**：`#QZ` 状态机 + 每 5 tick 一点 `in_fire` 伤害）。
  **教训：先把"这个效果有没有对应的原版机制"查清楚，再决定表现方式**，
  不要假设"伤害类型存在 = 状态效果存在"。
- 🔁 **万一又写坏了**：DSH 的会话日志是**逐条 zstd 帧**的 JSONL，里面留着每一次
  `write` / `edit` 的完整参数，可以**回放重建**。方法见 `docs/RECOVERY.md`
  （`D:\dswork\_recover\` 下有本次的中间产物与备份）。

---

## 6.6 每次改完的标准动作

```powershell
# 1) 离线校验（不启动游戏，抓悬空引用 / ID 写错 / 会让函数加载失败的写法）
powershell -ExecutionPolicy Bypass -File tools\validate.ps1

# 2) 铺到测试存档
powershell -ExecutionPolicy Bypass -File tools\deploy.ps1
```

`validate.ps1` 目前会检查：`.ps1` 是否纯 ASCII、JSON 是否合法、
`function` / `function #tag` / `loot` / `if predicate` / `item modify` 引用是否存在、
`store ... score <obj>` 的计分板有没有建过、bossbar 颜色与样式是否合法、
`click_event`/`hover_event` 蛇形命名、双命名空间、命令参数区双空格、
`matches` 里塞了计分板、以及**孤儿函数**（生成了却没人调用）。

> **v0.6.22 新增（§4b）**：`score <目标> <计分板> <运算符> <holder>` 后面**直接跟** `if|unless|run`
> （即**缺源计分板**，例：`unless score @s tspire_shop_f = #FLOOR if …`）→ 直接判失败。
> 这类写法会让**整个函数加载失败**（游戏里毫无提示，只表现为"这个节点/按钮没反应"）——
> v0.6.21 的商人节点就是这么静默失效的。规则加完**当场抓到了第二处**（`merchant/open_own`）。

> **v0.6.25 新增（§4c）**：**`mobs/` 与 `boss/` 下的任何文件都不许写 `#FLOOR`**
> （只有 `run/start_run` 与 `run/floor_advance` 可以）→ 判失败；通过时打印
> `ok  mobs/ and boss/ never write #FLOOR`。原因见「已排除的错误路径」第 1 条
> （写错值会让第 1 层 Boss 把人送到第 3 层）。

> **v0.6.60 新增（§4d / §4e，共 3 条）**：**§4d** `execute` 链式写法（行首裸子命令 / `run` 不在链尾）
> 与 `/data … entity` 多实体选择器；**§4e** 1.20.1 粒子 id 白名单。三条都对应"整个函数静默不加载"。

> **v0.6.62 新增（§4f，第 13 条）：不许写死血量门。**
> 非 `test/` 目录下任何 **`scores={…tspire_boss_hp=<数字或 ..数字>}`** → **FAIL**
> （提示 `boss HP scales with the party, use '#BNOW' vs '#TH_*' (or a 0/1 flag score)`），**`test/` 豁免**（诊断函数要打印真实血量）。
> **根因**：血量自 v0.6.59 起随人数缩放，任何字面量门槛都只在某一个人数下正确 —— 已经在 **v0.6.61 #27**（`..300` / `..425`）
> 与 **v0.6.62 #31**（`..375`）**咬了两次**。**这两次都是"数值看着很正常"的写法，靠肉眼搜旧数字是找不到的，所以必须靠规则。**
> **规则总数 12 → 13 条**；另见设计文档 §3.6.5（那里还说明了脚本里 §4d/§4e/§4f 与"逐行命令检查 §3"的编号关系）。

游戏内验收走 `docs/E2E.md`。

> **两个只在"世界加载"时才生效的东西**（改完必须退出世界重进，`/reload` 无效）：
> 1. **数据包维度**（`data/<ns>/dimension_type/` 与 `data/<ns>/dimension/`）
> 2. 新增/删除维度后，旧的 `ServerLevel` 不会自动建/删
>
> **恢复办法**：若维度 JSON 写坏导致进不去存档，修好或删掉 `dimension/` 与 `dimension_type/`
> 下的文件即可重新进入（世界加载会重新读一遍）。

---

## 7. 眼下的待办

> **权威的待办清单在设计文档顶部的新一节「待办总表（唯一入口）」**（v0.6.60 新增）。
> 本节保留的是"要动手时怎么测"的操作细节，判断"还差什么"请以那一节为准。

### (1) 商人货架（**v0.6.21 已改成"每人一份"**，旧行为作废）

```mcfunction
/reload
/function tspire:test/shop_demo          # 生成"你自己"这一层的货架 + 菜单（内部先置 @s tspire_shop_f 0 强制重掷）
/scoreboard players set #FLOOR tspire_timer 2
/function tspire:test/shop_demo          # 换第 2 层材料池再看一份
/function tspire:test/node_merchant_rich # 给 200 金币 + 走完整的商人节点流程
/function tspire:test/mp_check           # 多人：逐人打 货架层 / 货架编号 / 第1格已买 / 第2格已买
```

要检查的点：

1. 菜单里 15 条都是**具体物品**（部件名 · 材料名 · 阶级 · 价格），不是"随机部件 ×1"；
   15 格 = **6 部件 + 4 强化水晶 + 2 镶板盔甲（必定）+ 2 匠魂装备 + 1 远古工具**（v0.6.33 起）。
2. 恰好 2 条带 `★特价`，价格是原价的一半。
3. 装备价 45~60、部件价 10~25、远古 80。
4. **买完那一格还在货架里**（v0.6.21 起 `deliver_<n>` 不再清空箱子格），
   但**同一个人**再点同一格会提示「这一格你已经买过了（每人每格限购一次）。」。
5. **换个人点同一格照样能买**（每人一份自己的货架）—— 两个人各自买第 1 格都成功、各拿一份。
6. 站在讲台旁边**打不开那个箱子**（`Lock`），不能白拿。
7. 主手拿个匠魂部件点 `[出售]` → +8 金币；拿远古工具 → +40；**拿强化水晶 → +12**（v0.6.25 新增，此前会提示「主手没有可出售的匠魂物品。」）。
8. 地下**不应**出现联动材料（铝/青铜/康铜/琥珀金/…）。
9. 同一个商人节点**来回走**：菜单、价格与"已买过"状态都不变（再进门只是重开自己那份，不重掷）。
   **换一个商人节点**、或**换层**之后再进门才会重掷（v0.6.27：判据是 `@s tspire_shop_node != #NODEZ`，
   即节点 marker 的 z 坐标；**开新一局也在 `run/reset_player` 里被清掉**）。
10. 讲台旁那只**普通箱子**（v0.6.27 新增，`~-2 ~ ~-2`）能打开、能放东西 —— 用来跟队友交换装备；
    讲台下那只商品箱仍然打不开（`Lock`）。
11. **v0.6.29「丢下即出售」**：把一件**可出售物品**（匠魂部件 / 工具 / 强化水晶）丢在**商人 NPC 4 格内**
    → 自动出售、钱进 **16 格内最近那名玩家**的口袋、物品实体消失（价格表与菜单 `[出售]` 完全一致）。
    **反例（预期行为，不是 bug）**：想把它"丢给队友"也照样算出售 —— 交换装备请用第 10 条那只普通箱子。
12. **v0.6.29 逐玩家提示**：走进工匠 / 商人节点时，**只有触发的那名玩家**收到聊天提示与音效
    （不再全队广播；多人下另一名玩家不该被别人的节点提示刷屏）。
13. **v0.6.47「按堆叠计价」（两条路径都要试）**：
    (a) 主手拿**一叠**匠魂部件点 `[出售]` → 加钱 = **单价 × 数量**（`SelectedItem.Count`）；
    (b) 把**一叠**部件**丢**在商人 4 格内 → 加钱同样 = **单价 × 数量**（`Item.Count`，以前读的是小写 `Item.count`，
    **从 v0.6.29 起这条路一直不付钱、也不消耗物品**，v0.6.47 才修）。
    **读不到数量时最坏只是"按单个计价"**（`#SELLN` 默认 1），不会再出现"付 0 元清整叠"。

> **✅ 已实现（v0.6.33）：货架 10 格 → 15 格（v0.6.27 提出，v0.6.33 落地）。**
> 15 格 = **6 部件 + 4 强化水晶 + 2 镶板盔甲（必定）+ 2 匠魂装备 + 1 远古工具（5%，没抽到则补第 3 件装备）**；
> 逐人限购标记由 10 个扩到 **`tspire_buy0..14`**，`load.mcfunction` 里新增 `tspire_buy10..14`，
> 生成的 `shop/pick_f<层>` 与 `run/reset_player` 一并归零。
> 实现位置：`tools/gen-shops.ps1` 的可调参数（`$SHOP_PART_COUNT = 6` / `$SHOP_CRYSTAL_COUNT = 4` /
> `$SHOP_PLATE_COUNT = 2` + `$PLATE_ITEMS`，只卖镶板套装）与全部 `-lt 15` 循环；
> 菜单 / 购买 / 交付扩到 `slot0..14` 与 `deliver_0..14`。
> **上面第 1~12 条的验收标准现已按 15 格写**（第 1 条已改）。详见设计文档 §3.2.1 与变更记录 v0.6.33。

### (2) 商人货架实现上的一个取舍（要确认）

1.20.1 的聊天栏**读不到运行时 NBT**，所以"让玩家看着属性决定买不买"只能靠
**生成器把属性写进菜单文字** + **实物锁在箱子里**这两件事组合。
副作用是箱子打不开，玩家只能靠菜单文字判断，不能拿起来看匠魂面板。

如果你更想要"能打开箱子慢慢看"，代价就是**玩家可以直接把商品拿走**（1.20.1 没有只读容器）。
两条路二选一，现在的实现选了前者。

> **v0.6.21 说明**：改成"每人一份货架 + 每人每格限购一次"**没有改变这个取舍**——
> 箱子依然是 Lock、依然打不开、依然靠菜单文字展示属性。
> 变的只是**归属与限购**：货架从"全队一份"变成"每人一份"，"售罄"从清空箱子格变成 `tspire_buy<n>` 逐人标记。

### (3) 剩下的功能

- 存档写盘（§13.2 的 `storage` 快照；跨 `/reload` 的中断恢复已完成）

### (4) 重铸（刚做完，等验收）

> **⚠️ v0.6.27：菜单里的 `[重铸]` 按钮已暂时隐藏**（需求方要把它挪到别的模块），
> 所以下面"点「[重铸]」"这条验收步骤现在**走不通** —— 直接 `/function tspire:artisan/reforge` 即可，
> 或先把 `artisan/menu.mcfunction` 里被注释掉的 tellraw 恢复。功能与代码全部保留。

```mcfunction
/reload
/function tspire:test/artisan_reforge      # 发随机武器 + 200 金币，弹工匠菜单
```
检查：点「[重铸]」后材料变了、金币 -30；**强化/升级/耐久不变**；
主手空着点会提示「重铸失败」；金币不够会提示需要多少。
换层：`/scoreboard players set #FLOOR tspire_timer 3` 再跑一次，应换成三~四级材料。

### (5) v0.6.27 四项需求：后续状态（**v0.6.45 复核，别再看错**）

设计文档 §变更记录 v0.6.27 末尾有同一张表。

| # | 需求 | 现状 |
|---|---|---|
| 1 | **开局构筑：让旅行者套装 / 黏液套装在护甲选项里允许出现 2 级材料** | ✅ **已实现（v0.6.28）**。`tools/gen-starter.ps1` 新增 `$ARMOR_TIER_OVERRIDE`：**只有旅行者套装与黏液套装**允许抽 2 级材料，镶板护甲维持原档位 |
| 2 | **工匠节点「融合」**：主手 + 副手各持一个材料部件时可合成更高一级的部件（两个同级 → 高一级；两个 4 级 → 在 4 级里抽），**30 金币，每局限一次** | ✅ **已实现（v0.6.35）**。菜单新增可点击的 `[融合]`（`/function tspire:artisan/fuse`），实现是 `artisan/fuse` + `fuse_do` + `fuse_read` / `fuse_check` / `fuse_give`（战利品表 `artisan/fuse/<部件>_f2|f3`）。主手 + 副手**各须持一枚部件**、**30 金币**；产物是**与主手同类型、材料取自「下一层材料池」**的一枚部件（`#FLOOR` 1 → 第 2 层池，≥ 2 → 第 3 层池），成功后消耗两枚部件并置 `tspire_fuse_used`。**两点务必看清**：① 次数是**每个工匠节点各限一次**（`tspire_craft_node` 换节点即重置），**不是"每局限一次"**；② 原需求的「**两枚部件必须同级**」这个前置**没有校验** —— 任意两枚部件都能融合，"两个同级 → 高一级 / 两个 4 级 → 仍在 4 级里抽"尚未落地（**这一条仍留在待办里**，见设计文档变更记录 v0.6.35 第 4 条与 §3.1.2） |
| 3 | **商人出售改为"把物品丢到商人 NPC 处即判定出售"** | ✅ **已实现（v0.6.29）**。新增生成的 `merchant/sell_drop`，由 `tick/second` 对商人 4 格内的物品实体调用（见本文件 v0.6.29 第 4 条与 §7 (1) 第 11 条） |
| 4 | **商人货架从 10 格扩到 15 格（类型按比例），且售卖工具 / 装备的格位里必定有 2 个卖镶板盔甲** | ✅ **已实现（v0.6.33）**。货架 **15 格 = 6 部件 + 4 强化水晶 + 2 镶板盔甲（必定）+ 2 匠魂装备 + 1 远古工具**，逐人限购标记扩到 **`tspire_buy0..tspire_buy14`**；生成器 `tools/gen-shops.ps1` + `load.mcfunction` 同步改完（**改造清单见 §7 (1) 末尾**，那里已改写成"已实现"说明） |

### (6) v0.6.28 没有变更记录条目（文档缺口）

设计文档**从 v0.6.27 直接跳到 v0.6.29**，v0.6.28 的改动只存在于代码与注释里。已确认至少四项：
开局护甲 2 级材料覆写（见上表 #1）；**《尖塔地图》成书不再发放、但 `tconstruct:encyclopedia` 改回照常发放**
（`run/give_kit` 里明确写着"上一版误删了工匠大百科"——**本文件与 README 里"不再发工匠大百科""tellraw 漏改"的说法都已作废**）；
工匠**共鸣 / 融合改成"每个工匠节点各限一次"**（节点 z 当钥匙，新计分板 `tspire_craft_node`）；
部件制造台不再塞金质模具、改在旁边箱子里备木制模具 + 毒液瓶。
**下次整理文档时把 v0.6.28 补成一条正式条目。**

> **另有一处 v0.6.27 的漏改**：`run/give_kit` 已经不发工匠大百科，但它末尾的 tellraw 宣告行里
> **仍写着「工匠大百科 ×1」**，需要清掉。
>
> **⚠️ v0.6.28 更正：上面这条已作废。** 玩家澄清要删的是**《尖塔地图》成书**；
> `run/give_kit` **照常发工匠大百科**，tellraw 也一直是对的。见 §7 (6)。

### (7) Boss 机制进度（**v0.6.59 复核**）

设计文档 §变更记录 v0.6.27 待办表里有同一份进度。

| 状态 | Boss |
|---|---|
| ✅ **9 只全部完成、再无占位阶段（v0.6.57 起）** | 淬火者（烈焰环 / 燃烧蓄能 / 灰烬重生）、锈刃督军（威压 / 亡者征召 / 破甲重击 —— **v0.6.54 起【破甲重击】追加抗性提升 I**）、沼泽猎手（**泥沼 / 标枪投掷 / 泥沼现身**；**泥沼 v0.6.59 起 2 秒触发**）、**钴蓝决斗者（死斗 / 破釜 / 决斗嘶吼 —— v0.6.55 【死斗】重做并默认开启）**、裂颅者（三连射 / 战术突进 / 钉刺陷阱）、织影巫师（**唤鬼 14 秒 / 5 血恼鬼；尖牙阵 10 秒；暗影帷幕 20 秒重做；底怪 = 唤魔者**，※ 原版尖牙并存见待办第 21 条）、**铭刻者（时间铭刻 / 铭刻逆流 / 时间书虫 / 遗忘蚀刻 —— v0.6.56 重做，共 4 条）**、**熔核暴君（熔火地脉 / 凋零剑压 / 熔核爆发 —— v0.6.57 重做、v0.6.58 起真火焰）**、**重铸之王（再锻 / 金铸壁垒 / 王权征召 —— v0.6.57 首次落地）** |
| ⬜ **已无缺口** | ~~重铸之王~~ ✅ 完成；`boss/phase.mcfunction` 已无活跃逻辑（仅为兼容调用点保留） |

- **v0.6.59 的血量规则**：**随人数缩放** —— 1 层 **200/250/300**、2 层 **350/450/500**、3 层 **500/600/750**（1/2/3+ 人）；
  百分比门用 **`#BNOW`（当前血量）vs `#TH_75/#TH_HALF/#TH_40/#TH_25`（spawn 按 `#MAXHP` 算出）** 比较；
  **熔核暴君另有 `#TH_60`（300/360/450）与 `#TH_85`（425/510/637）**（v0.6.61 新增）。
  **✅ v0.6.61 / v0.6.62 之后：全项目再无任何写死血量的门**（`boss/` 下已无 `scores={…tspire_boss_hp=<数字>}`），
  且 `validate.ps1` 新增 **§4f**（第 13 条规则）永久兜住这一类写法 —— 详见下面第 30 条。
- **v0.6.54 ~ v0.6.59 的变化概览**：奖励池改版（`rewards/special`）／商人格 5 部件 + 1 特殊／出售补 12 件盔甲／
  【死斗】重做（默认开）／Boss 单挑入口／铭刻者四项／重铸之王三机制／熔核暴君三机制 + 真火焰／人数缩放／泥沼 2 秒。

- **v0.6.50 的变化**：**裂颅者【三连射】真的射三支箭**（新 `boss/skullcrusher_volley`，yaw 分 8 桶 + 预计算 `Motion`，
  生成点前方 1.5 格 / +1.2 高，箭 `damage 4` / `Pickup:0` / tag `tspire_arrow`）—— **近似：只有 8 个桶、每桶固定 ±10°**，
  且**没有清理者**；**钴蓝决斗者三机制全换成【死斗】（每 2 秒 3.5 格内 `tconstruct:bleeding` 3 秒）/
  【破釜】（每 15 秒随机 速度 II 8s / 抗性 I 12s / 力量 I 6s）/【决斗嘶吼】（HP ≤ 250 每 16 秒，末影龙嘶吼 + 全员虚弱 I + 穿甲 II）**；
  `validate.ps1` **9 条规则**（新增匠魂效果 id 校验，并修掉 `\bgive` 误伤 `effect give` 的误报）。
  **✅ 已结案（v0.6.51 删掉该块）**：`boss/active` 第 34–40 行旧【疾风连击】块**已删除**，决斗者现在只剩死斗 / 破釜 / 嘶吼三条（设计文档待办表第 19 条）。
- **v0.6.49 的三条收尾**（上一轮文档复核提出）：**第 14 条 ✅ 结案**（裂颅者【钉刺陷阱】**本就无血量门** ——
  玩家 v0.6.48 新规格就是"每 12 秒触发"，是**文档**写错了"阶段机制 HP ≤ 35%"，已改，**代码不动**）、
  **第 15 条 ✅ 已修**（掠夺者弩的分支写进 `gen-gear.ps1`，**已实跑生成器验证生成物第 4–5 行仍是那两行**）、
  **第 16 条 ✅ 已实现（v0.6.50）**（【三连射】真的 `summon arrow` 三支箭，`boss/skullcrusher_volley`，**8 桶近似**，见待办第 17 条）。
  另：**`test/boss_probe` 现在覆盖 8 只**（补上 duelist / shadowweaver / inscriber / moltenlord；仍不含重铸之王）。
- **❌ 已作废（v0.6.62 复核标注）：v0.6.48 时代"阈值现在是 150 / 150 / 250 / 200 / 300 / 350"这一串绝对数字**。
  **v0.6.59 起全部改成随人数缩放的 `#TH_*` 分数门**，现在**一个绝对数字都不剩**（详见上面"v0.6.59 的血量规则"与第 30 条）。
  **裂颅者【钉刺陷阱】没有任何血量门**（见下）。**第 2 层三只 Boss 血量 600 → 500**（v0.6.48）。
  （**v0.6.48 当时的状态**：血量门读 `boss/tick` 第 11–18 行**每 tick 自己写的**计分板 `tspire_boss_hp`）
  **v0.6.39 删了 6 个占位阶段函数、v0.6.40 删了铭刻者的、v0.6.42 删了熔核暴君的**（它们与真机制**同阈值双触发**）。
- **✅ v0.6.48 文档复核的三条，v0.6.49 全部结案（设计文档待办表第 14 / 15 / 16 条）**：
  1. **✅ 裂颅者【钉刺陷阱】的"阶段血量门"→ 结论是文档写错，代码不动**：`boss/skullcrusher` 第 24–25 行是
     **无条件调用**（只判 `#SKU_C3` 到没到 240），而**玩家 v0.6.48 的新规格原文就是"技能每 12 秒触发"、没有血量条件** ——
     "阶段机制 HP ≤ 35%"是 v0.6.36 的残留，**已从 §7.6 删除/作废**；`boss/tick` 第 36–38 行注释已改成
     「16s（前摇 2s）/12s，**陷阱没有血量门**」。**裂颅者满血就布陷阱 = 预期行为。**
     （遗留：`boss/phase` 第 19 行仍写「HP ≤ 210」等旧注释 —— **纯注释，不影响行为**，见上面遗留清单。）
  2. **✅ 掠夺者的弩已写进生成器**：`gen-gear.ps1` 按槽位分支，`weapon.mainhand` 生成 pillager / 非 pillager 两行；
     **已实跑生成器验证 `mobs/equip_f{1,2,3}` 第 4–5 行仍是这两行**，**重跑不会再冲掉**。
  3. **🔴 裂颅者【三连射】仍未实现"三支箭 / 45° 扇形"**：`boss/active` 第 43–48 行只有
     actionbar 预告 → `entity.arrow.shoot` 音效 + 力量 II 2 秒 + 计时器归零，**没有 `summon arrow`**；
     箭来自**原版掠夺者的弩 AI**。**是否真做等玩家决定**（做法：读 `Rotation[0]` 分 8 个方向桶再 `summon minecraft:arrow`）。
     另：`boss/tick` 第 39 行「【三连射】…未改动」也是旧注释（纯注释）。
- **❌ 已作废（v0.6.62 复核标注）：上面那行说"重铸之王是唯一还在跑占位阶段的 Boss（`boss/phase_recastking`）"早已不成立** ——
  **重铸之王的三机制（再锻 / 金铸壁垒 / 王权征召）在 v0.6.57 就已落地**，占位文件 `boss/phase_recastking` **已删除**，
  `boss/phase.mcfunction` 现在**没有任何活跃逻辑**（仅为兼容 `tspire:boss/phase` 调用点保留）。
  **9 只 Boss 全部完成、整个项目再无占位阶段**（上面的状态表也是这么写的）。
- **⚠️ "已完成"不等于"真的在工作"**：v0.6.43 / v0.6.44 查出**三个函数因加载失败而从来没生效过**
  （【融合】、**【标枪投掷】**、淬火者**燃烧阶段的伤害**），另外**两个机制名义上写了、实际触发不了**：
  - **淬火者【灰烬重生】**：阈值 20%（60）会被"一刀从 60 以上直接打死"跳过 → **v0.6.44 放宽到 50%（150）**，现在能触发；
  - **锈刃督军【亡者征召】**残血 4 只：判定被**从未初始化的 `#RUS_DOUBLE`** 挡住 → **v0.6.44 改成直接按 `tspire_boss_hp=..150` 判定**
    （**该绝对值判定在 v0.6.59 又改成 `#BNOW <= #TH_HALF`，且残血数量在 v0.6.52 从 4 只改成 3 只**）；
  - **沼泽猎手【标枪投掷】**：`boss/mirehunter_javelin` 的 `effect give … minecraft:witch` **把效果 ID 写成了粒子名**
    （v0.6.43 全局替换误伤）→ 该函数加载失败、中毒不生效 —— **v0.6.45 已改回 `minecraft:poison`，现在正常工作**，
    并补了"效果 / 粒子混淆"两条离线规则（做过负向验证）。
  **排查口诀：某个功能"点了完全没反应" → 先看 `latest.log` 有没有 `Failed to load function`，再怀疑逻辑。**
- **五个"打了折扣"的实现（验收时别当成 bug）**：
  **钴蓝决斗者【崩刃】** —— ⚠️ 原 v0.6.38 用的 `/attribute` **在 1.20.1 加载期就被拒、那个版本从来没生效**，
  v0.6.46 起改成 `weakness 999999 1`（攻击 14 → 约 6 ≈ −57%）+ `speed`；**"攻速翻倍"在 1.20.1 做不出来**（降级成速度效果）；
  **【玛玉灵回响】是分档近似**（不是精确 30%）、**铭刻者【强化剥离】是"暂时剥离"**（1.20.1 无法真的移除武器上的强化，
  25 秒虚弱 II + 挖掘疲劳 I）、**熔核暴君【凋零剑压】是"每 5 秒一轮的贴身光环"**（1.20.1 没有攻击命中事件，
  3 格内凋零 II 3 秒 + 残血额外 4 点）、
  **✅ v0.6.48~v0.6.61 的裂颅者【战术突进】击退"只走 X/Z 主轴"已在 v0.6.62 修掉**（`skullcrusher_kb` 与 `recastking_push` 都改成
  **`tspire_kb_rot` marker + `rotated ~ 0`** 的方向载体写法：**任意角度的水平推进、Y 恒为 0**，旧 dx/dz 机已全删）——
  这正是为了修"被击退到出图"而付的代价，**v0.6.62 起不再有"斜向退化成轴向"这个代价**。
  它们都**已记入待办**，详见设计文档 §7.6 与本文件 v0.6.38 / v0.6.40 / v0.6.42 / v0.6.48 条目。
- **沼泽猎手【泥沼】的 `as`/`at` 根因在 v0.6.48 才修掉**（v0.6.44 重做时判定写了 `as @e[…] as @a[…]`，
  **漏了 `at @s`** → `distance=..4` 在塔的原点算，**没有任何玩家匹配** → "只有粒子、没有控制"）。
  现在 `mirehunter_mud_check` 第 43 行是 **`as @e[tag=tspire_mud] at @s as @a[…]`**。见本文件 v0.6.48 条目 (a)。
- **沼泽猎手三机制在 v0.6.44 又一次全面重做**（名字也换了）：【泥沼】改为**主动 12 秒布 3 片**、
  【标枪投掷】加 2 秒前摇、【淤泥附身】→ **【泥沼现身】**（旧 `mirehunter_muddy` 已删除）——
  **上表里"泥沼 / 标枪投掷 / 泥沼现身"是当前名字**，v0.6.34 的那一套已作废（详见设计文档 §7.6 与本文件 v0.6.44 条目）。
- **铭刻者【铭刻重写】的状态窗口在 v0.6.41 已修正**：状态与效果**都持续 6 秒**（与重掷周期一致、不再重叠），
  死计时器 `#INS_STATE_T` 与 `inscriber_state_end` 已删除，见本文件 v0.6.41 条目。

---

## 8. 开发顺序（设计文档 §13.15）

```
G1 玩家状态 → G10 状态机 → G6 容器 GUI → G8 触发上锁
   ↓
G2 存档 → G4 实体上限 → G5 Boss 数值 → G3 经济校验
   ↓
G7 HUD 与节点提示 → G9 音效
   ↓
G13 多人（写法已从 G1 起统一为全队）
   ↓
G15 安装卸载 → G16 性能 → G17 验收
```

---

## 9. 硬性约定（别忘）

1. **面向玩家的指令一律 `@a[team=tspire_party]`，不用 `@s`**（§13.11.5）——单人局是 n=1 的特例。
2. **`materials` 数组长度必须等于 `docs/PARTS.md` 的槽数**。
3. **`tools/*.ps1` 保持纯 ASCII**（PS 5.1 按 ANSI 读无 BOM 的 ps1，中文会破坏语法）。
4. **本机默认禁止运行 `.ps1`**，要 `powershell -ExecutionPolicy Bypass -File ...`。
5. 命名空间统一 `tspire`；只新增文件，不覆盖匠魂原版定义。

---

## 10. 调参入口（给"想自己改数值"的人）

完整对照表在主设计文档 **§3.6 调参索引**。速记：

- **运行时可调** → `data/tspire/functions/config/defaults.mcfunction`
  一个文件装所有 `#CFG_*`（开局金币、出售价、出售开关、工匠付费回血价格、修复价、敌人上限…），
  由 `tspire:load` 调用，改完 `deploy.ps1` + `/reload` 生效。
  临时试值：`/scoreboard players set #CFG_START_GOLD tspire_config 999`
- **生成期写死** → `tools/gen-*.ps1` 顶部的 `TUNABLE PARAMETERS` 段，
  改完**重跑那个生成器**再 deploy。
  为什么必须预生成：1.20.1 **没有宏**，命令参数（价格、effect 等级、坐标）
  **不能读计分板**，只能写死或按档位分支。
- 商人文案在 `tools/shop-text.json`（UTF-8）。**不要把中文写回 `.ps1`。**

> 踩坑提示：往 `.ps1` 里加中文注释也会炸（PS 5.1 按 ANSI 读无 BOM 脚本），
> 而且报错行会**错位**，看起来像别的地方语法错了。
