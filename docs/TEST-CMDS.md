# 测试指令清单（TEST-CMDS）

> **本文件是"玩家/测试者能直接用的所有测试函数"的汇总**（v0.6.59 建立、**v0.6.60 更新**、**v0.6.62 复核**）。
> **所有条目都逐个对照过 `src\main\resources\data\tspire\functions\test\` 下**实际存在**的函数 ——
> 不存在的函数**没有写进来**（见文末"已知的坑"）。
> 除特别说明外，**都在聊天栏里以自己身份执行**（需要 OP / 单机开作弊）。
> **所有 `function` 都要写完整命名空间**，例如 `/function tspire:test/map_demo`。

---

## 1. Boss 单挑（最快、最常用）—— v0.6.55 新增

| 指令 | 作用 |
| --- | --- |
| `/function tspire:test/boss_pick` | 打印**9 只 Boss 的可点击菜单**，点名字即可开战 |
| `/function tspire:test/boss_pick_quencher` | 单挑 **淬火者**（第 1 层） |
| `/function tspire:test/boss_pick_rusblade` | 单挑 **锈刃督军**（第 1 层） |
| `/function tspire:test/boss_pick_mirehunter` | 单挑 **沼泽猎手**（第 1 层） |
| `/function tspire:test/boss_pick_duelist` | 单挑 **钴蓝决斗者**（第 2 层） |
| `/function tspire:test/boss_pick_skullcrusher` | 单挑 **裂颅者**（第 2 层） |
| `/function tspire:test/boss_pick_shadowweaver` | 单挑 **织影巫师**（第 2 层） |
| `/function tspire:test/boss_pick_inscriber` | 单挑 **铭刻者**（第 3 层） |
| `/function tspire:test/boss_pick_moltenlord` | 单挑 **熔核暴君**（第 3 层） |
| `/function tspire:test/boss_pick_recastking` | 单挑 **重铸之王**（第 3 层） |

> **v0.7.2 起：单挑直接用「真实 BOSS 房」**（玩家提问"测试指令的测试场地不能用 boss 房间的场地吗？"）。
> 流程：`forceload` → `map/build_floor`（按 `#FLOOR` 建整层，含 `room_boss` 的 **29×29×5 真实房**）→
> 把**真实 BOSS 节点**（固定在 `(0, 64/96/128, −388)`，预设里本来是 locked）标成当前节点 →
> **把你和队友传送到房内南门**（`0 <y> −374`）→ `run/battle_start`（顺便封门、把落单的队友拉进来）。
> 于是 Boss 机制用的 `@e[tag=tspire_node_current]` 就是真房间中心，**距离/范围与正式流程完全一致**。
> 打完想再挑一只：直接再点一次菜单即可（会重建整层）。
>
> 旧版（v0.6.60~v0.7.1）是在大厅东南角手搭一个 21×21 方块盒子（`28 64 20`），
> 它既不是 `tspire_node`、尺寸与门位也和真房不同 —— **已废弃**。

> 每个入口都会：**送你进尖塔维度** → **清场**（Boss / 小怪 / 尖刺 / 箭 / marker / 恼鬼）→
> **设好该层 `#FLOOR`**（装备与奖励按那一层算）→ **建真实楼层与 BOSS 房** → **只生成那一只 Boss**。
> 共享的准备函数是 `test/boss_arena_setup`（不需要直接调用）；
> 自检用 `test/boss_arena_check`（会检查真房地砖/空气与节点 marker，并给一个重建按钮）。
>
> **⚠️ Boss 血量 v0.6.59 起随队伍人数缩放**（1 / 2 / 3+ 人）：
> 第 1 层 **200 / 250 / 300**、第 2 层 **350 / 450 / 500**、第 3 层 **500 / 600 / 750**。
> 想测某一档，就让相应人数的玩家先进塔再执行单挑指令。
> **门槛也按百分比走**（v0.6.61 起熔核暴君同样）：**【熔火地脉】扩圈 = 60%（300 / 360 / 450）、【熔核爆发】= 85%（425 / 510 / 637）**；
> 其余 Boss 的 50% / 40% / 75% / 25% 门同理（**✅ v0.6.62 起已无任何写死血量的门**；
> 铭刻者【时间书虫】那处漏网的 `..375` 已改成 `#TH_HALF`，并新增 validate §4f 规则永久堵住 —— 见文末"已知的坑"第 8 条）。

---

## 2. 诊断 / 自检（排查问题时先跑这些）

| 指令 | 作用 |
| --- | --- |
| `/function tspire:test/boss_probe` | **Boss 机制诊断**：打印 8 只 Boss 的真实 `Health` 与同步后的 `tspire_boss_hp`、各机制冷却假玩家、场上 `tspire_mud` / `tspire_spike2` 数量、逐玩家的泥沼状态。**"机制该触发却没触发"先跑它** |
| `/function tspire:test/wipe` | **一键清空当前房间**的尖塔怪物与技能残留（Boss / 小怪 / 尖刺 / 火焰标记 / 箭 / 恼鬼等） |
| `/function tspire:test/door_check` | **节点封门自检**：打印周围 40 格内每个节点的坐标 / tag（avail·current·locked·done）/ 南北门真实方块 |
| `/function tspire:test/mp_check` | **多人状态快照**：全队每人一行（phase / layer / gold / wcount / dead / 货架层号 / 已买格…），排查"第二个人没进队" |
| `/function tspire:test/start_check` | **开局链路自检**：打印 `PICK_STAGE` / 构筑箱 / 锚点 / 节点 marker 等，卡在开局时跑它 |
| `/function tspire:test/map_check` | **地图自检**：数出塔里每行有几个节点 marker 与 可进入 / 锁定 / 已通过 / 已消费 / 可复用 分布 |
| `/function tspire:test/summary` | **预览结算界面**：拿当前分数把结算界面打印一遍（**不改动任何进度**） |
| `/function tspire:test/check_dimension` | 检查尖塔维度 `tspire:tower` 是否已注册 |

---

## 3. 场景 / 节点直达

| 指令 | 作用 |
| --- | --- |
| `/function tspire:test/map_demo` | 生成第 1 层地图并送你进尖塔（**最常用的"正常开始"入口**） |
| `/function tspire:test/boss_demo` | 开一场 Boss 战（按当前 `#FLOOR` 随机抽本层三选一） |
| `/function tspire:test/boss_demo_f1` | 同上，但**强制第 1 层** |
| `/function tspire:test/boss_demo_f2` | 同上，但**强制第 2 层** |
| `/function tspire:test/boss_demo_f3` | 同上，但**强制第 3 层** |
| `/function tspire:test/battle_next` | 直接开下一场普通战斗（战斗序号自动 +1；第 1~2 场简单池、第 3 场起困难池） |
| `/function tspire:test/battle_demo` | **已弃用**，只会转发到 `map_demo`（保留是为了旧入口不报错） |
| `/function tspire:test/roll_group_demo` | **抽组演示**：一次刷 3 拨怪（左=第 1 场简单池 / 中右=第 3 场困难池），看随机性 |
| `/function tspire:test/node_merchant` | 在你脚下走一遍完整**商人节点**流程 |
| `/function tspire:test/node_merchant_rich` | 同上，但**先给 200 金币** |
| `/function tspire:test/node_artisan` | 在你脚下走一遍完整**工匠节点**流程（含重铸菜单） |
| `/function tspire:test/shop_demo` | 在脚下生成**你自己**的一份商人货架 + 菜单（先强制重掷） |
| `/function tspire:test/artisan_reforge` | 发一把随机匠魂武器 + 200 金币，直接试**重铸** |

---

## 4. 奖励 / 装备自检

| 指令 | 作用 |
| --- | --- |
| `/function tspire:test/reward_demo` | **奖励池演示**：不用打架，直接抽 6 次随机奖励看内容 |
| `/function tspire:test/reward_demo_f1` | 同上，强制第 1 层 |
| `/function tspire:test/reward_demo_f2` | 同上，强制第 2 层 |
| `/function tspire:test/reward_demo_f3` | 同上，强制第 3 层 |
| `/function tspire:test/reward_rare` | **稀有奖励抽样**：连抽 20 次（40 项），看**特殊奖励 / 远古 / 投掷**能不能出现 |
| `/function tspire:test/reward_ancient` | **远古工具直抽**测试 |
| `/function tspire:test/gear_showcase` | 出怪链路演示：一次生成两个编队，检查**装备是否真的挂上** |

---

## 5. 技术验证（V1~V7，早期结论已定案，一般不用重跑）

| 指令 | 验证的问题 |
| --- | --- |
| `/function tspire:test/all` | **一键跑全部**（V1~V5），建议创造模式 + 超平坦 |
| `/function tspire:test/v1_tool_nbt` | V1：只给 `tic_materials` 的工具，面板会不会自动算出来 |
| `/function tspire:test/v2_mob_damage` | V2：怪物拿匠魂工具打人是否真的更疼 |
| `/function tspire:test/v3_add_tool_data` | V3：`add_tool_data` 的 `randomized.tier` 用法 |
| `/function tspire:test/v4_material_tag` | V4：联动材料排除的回归测试 |
| `/function tspire:test/v5_mob_equipment` | V5：`mob_equipment` 注册表的 chance / match / priority 行为 |
| `/function tspire:test/v7_summon_gear` | V7：`summon` + `loot replace` 塞装备是否可行（**现行方案**） |

> **没有 `v6`**（历史上没有这一项，别去找）。

---

## 6. 常用手敲指令（不是测试函数）

| 指令 | 作用 |
| --- | --- |
| `/reload` | 重新加载数据包；**每次改完/部署后先跑它**，再看 `latest.log` 有没有 `Failed to load function` |
| `/execute in tspire:tower run kill @e[tag=tspire_boss]` | 清掉当前 Boss（注意要带 `execute in tspire:tower`，否则在主世界找） |
| `/function tspire:test/wipe` | 清房间残留（**推荐用它而不是手敲 kill**） |
| `/function tspire:map/clear_all` | 清掉整座塔的场景与实体（**注意**：不是 `tspire:clear_all`） |
| `/scoreboard players set @s tspire_gold 500` | 给自己 **500 金币**（商人 / 工匠 / 重铸都用它） |
| `/scoreboard players set #FLOOR tspire_timer 3` | 把**当前层**改成第 3 层（影响材料池 / 奖励档位） |
| `/function tspire:run/start` | **开始一局**（会走开局构筑） |
| `/function tspire:test/boss_probe` | （再次强调）排查机制不触发的首选 |
| `powershell -ExecutionPolicy Bypass -File tools\validate.ps1` | **离线校验**（现为 **13 条规则**，v0.6.62 新增 §4f「不许写死血量门」）；**通过 ≠ 没问题**，它只抓"它认识的写法" |
| `powershell -ExecutionPolicy Bypass -File tools\checklog.ps1` | **★ v0.6.60 新增：从 `latest.log`（GBK）里读出"哪一行加载失败"** —— 只统计**最近一次**数据包加载（以 `Loaded N recipes` 为界），打印函数名 + 报错行号 + 当前源码行。**每次 `/reload` 后都该跑它。** |

> **⚠️ `#FLOOR` 只允许 `run/start_run` 与 `run/floor_advance` 改**（见设计文档 §13.5）；
> 手敲 `#FLOOR` 只用于**测试**，正式流程里改了会出现"打第 1 层却刷出第 3 层 Boss"的老问题。

---

## 7. 已知的坑（写文档时核对出来的）

1. **没有 `tspire:clear_all` 这个函数** —— 想清塔请用 `/function tspire:map/clear_all`。
2. **没有 `v6_*` 测试函数**（V 系列只有 V1/V2/V3/V4/V5/V7 + `all`）。
3. **`battle_demo` 已弃用**（只转发到 `map_demo`），别把它当成"竞技场演示"。
4. **`test/boss_probe` 不包含重铸之王**（只逐只打印 8 只；重铸之王要看 `Health` 得直接 `/data get entity @e[tag=tspire_boss_recastking,limit=1] Health`）。
5. **`test/all` 的注释写的是 V1~V5**（V7 是单独的）。
6. **`test/boss_arena_build` 是内部函数**（v0.7.2 重写）：只做"**forceload + `map/build_floor`**"（建真实整层与 BOSS 房），
   由 `test/boss_arena_setup` / `test/boss_arena_rebuild` 调用；正常情况下**不需要直接执行**
   （直接跑 `boss_pick_<id>` 就会连带建好）。**注意**：它依赖 `#FLOOR` 已经是对的。
7. **删掉测试函数时记得同步本文件**（以及设计文档 §3.6.4）—— 本文件的每条都核对过是否真实存在。
8. **✅ 已修（v0.6.62）—— `boss/inscriber_bookworm` 的写死血量门**。原记录：~~第 10 行仍写死 `scores={tspire_boss_hp=..375}`~~（750 血时代的硬编码）：
   铭刻者现在血量 500/600/750，所以它当时实际是 **75% / 62.5% / 50%** —— **1 人局会把"低于 50% 才多召 1 只蠹虫"提前到 75%**。
   **现在改成了 `if score #BNOW tspire_timer <= #TH_HALF tspire_timer`（恒定 50%：250 / 300 / 375），
   源码在 `boss/inscriber_bookworm` 第 13 行**（文件头有注释占行，文档旧版写的"第 10 行"是笔误）。
   同时 `tools/validate.ps1` **新增规则 §4f**：非 `test/` 下任何 `scores={…tspire_boss_hp=<数字>}` 一律 FAIL ——
   所以**这一类"写死血量门"以后不会再溜过去**（设计文档待办总表 #31，v0.6.62 结案）。
9. **击退 / 外推是"任意方向的水平推进"（v0.6.62 起），不是沿主轴**：裂颅者【战术突进】（5 格）与重铸之王【金铸壁垒】（4 格）
   现在都用 **`tspire_kb_rot` 临时 marker + `rotated ~ 0`** 实现（旧 dx/dz 机已删）。**测试注意**：
   - 被推方向 = 「Boss → 你」的**水平连线**，**斜着站也会沿斜线推**，**Y 不变**；
   - 场上有 `tspire_kb_rot` marker 是**过程产物**，正常会在同一函数里被 `kill`；若怀疑有残留，
     跑 `/execute in tspire:tower run data get entity @e[tag=tspire_kb_rot,limit=1]`，
     或直接重建（`boss_arena_setup` / `boss_arena_rebuild` 的清场列里都有 `kill @e[tag=tspire_kb_rot]`）；
   - **⚠️ 源码注释里有 3 处转义符吃字**（第 8 / 12 行的 `\t` 吃掉 `tp` 的 `t`、第 10 行的 `\n` 吃掉 `rotated` 的 `r`），
     **纯注释、不影响玩法**，但读代码时别以为命令写错了。
10. **`validate.ps1` 现在是 13 条规则**（v0.6.62 新增 §4f "不许写死血量门"）——
    跑出来是 `PASS  N warning(s), 0 failures` 才算过；**加载失败仍要靠 `checklog.ps1` 才能发现**。
