# ============================================================
# 匠魂尖塔 · 运行时可调参数（**改这一个文件就够了**）
# ============================================================
# 由 tspire:load 在每次 /reload 时调用。
#
# 用法：
#   1. 改这里 -> /reload -> 生效
#   2. 只想临时试一个值、不想改文件：
#        /scoreboard players set #CFG_START_GOLD tspire_config 999
#      （但下次 /reload 会被本文件覆盖回去）
#   3. 想看当前所有值：
#        /scoreboard players list #CFG_START_GOLD
#
# 约定：
#   - 所有键都在计分板 `tspire_config` 上，名字统一 #CFG_ 前缀
#   - 只放**运行时会读**的参数。货架商品/价格是 tools/gen-shops.ps1 在
#     生成阶段就写死的，改不了这个文件（见文档 §3.6 调参索引）
#   - 命令参数之间只允许一个空格
# ============================================================

# ---------- 开局与资源 ----------
# 开局金币
scoreboard players set #CFG_START_GOLD tspire_config 50

# ---------- 商人：出售价（购买价由生成器决定，见 tools/gen-shops.ps1） ----------
# 出售总开关：0 = 关闭出售（菜单里那行会提示关闭），1 = 开启
scoreboard players set #CFG_SELL_ENABLED tspire_config 1
# 零件（small_blade / tool_handle / ...）
scoreboard players set #CFG_SELL_PART tspire_config 6
# 强化水晶（v0.6.25 新增：以前不在任何名单里，导致"水晶卖不掉"）
scoreboard players set #CFG_SELL_CRYSTAL tspire_config 9
# 普通匠魂工具（剑 / 匕首 / 劈刀 / 弩 / 长弓 / 板斧 / 镰刀 / ...）
scoreboard players set #CFG_SELL_TOOL tspire_config 16
# 远古工具（熔炼锅 / 战镐 / 战斗牌子 / 喷流刃）
scoreboard players set #CFG_SELL_ANCIENT tspire_config 40
# 按材料阶级收购：0/1 阶使用上述基础价；混合材料装备取最高阶。
scoreboard players set #CFG_SELL_PART_T2 tspire_config 10
scoreboard players set #CFG_SELL_PART_T3 tspire_config 14
scoreboard players set #CFG_SELL_PART_T4 tspire_config 18
# 水晶按升级 / 防御 / 能力 / 无槽位类别定价。
scoreboard players set #CFG_SELL_CRYSTAL_DEF tspire_config 11
scoreboard players set #CFG_SELL_CRYSTAL_ABILITY tspire_config 13
scoreboard players set #CFG_SELL_CRYSTAL_SLOTLESS tspire_config 15
scoreboard players set #CFG_SELL_TOOL_T2 tspire_config 30
scoreboard players set #CFG_SELL_TOOL_T3 tspire_config 42
scoreboard players set #CFG_SELL_TOOL_T4 tspire_config 50

# ---------- 工匠节点 ----------
# 【v0.6.26】进节点免费回血固定 45%（9 点），不再用 amplifier 配置 ——
# 旧版 amplifier 4 = 64 点，等于必满血，太高了。原理见 artisan/heal_snapshot。
# 花金币再回 25%（5 点）的价格
scoreboard players set #CFG_ARTISAN_HEAL_PAID_COST tspire_config 25
# 修复价格：基础价（把全身装备 + 背包里的工具修满）
scoreboard players set #CFG_REPAIR_COST tspire_config 15
# 【v0.6.27】每修复一次价格再涨这么多（本局内累加）
scoreboard players set #CFG_REPAIR_COST_STEP tspire_config 5

# 重铸价格（功能保留但入口已隐藏）：把主手匠魂工具的材料按本层材料池重抽一遍
scoreboard players set #CFG_REFORGE_COST tspire_config 30

# ---------- 性能 / 上限（§13.4 / §13.12） ----------
# 场上敌人上限 = max(MOB_CAP_BASE, MOB_CAP_PER_PLAYER * 人数)
scoreboard players set #CFG_MOB_CAP_BASE tspire_config 30
scoreboard players set #CFG_MOB_CAP_PER_PLAYER tspire_config 20

# ---------- Boss 机制开关 ----------
# 【v0.6.51】钴蓝决斗者【死斗】（被动：贴身给玩家匠魂「流血」3 秒）。
#   【v0.6.54】重做成"掉血即流血"后**默认开启（1）**：只有真的挨打才流血，
#     比旧版"每 2 秒给贴身玩家上流血"的固定光环温和得多。想关掉就改成 0。
#   想开回来只要把这里改成 1（函数 boss/duelist_deathmatch 一直保留着）。
scoreboard players set #CFG_DUELIST_DEATHMATCH tspire_config 1

# 【v0.6.53 最终方案（玩家拍板）】织影巫师的底怪：
#   1（默认）= **唤魔者** —— 保留原版行为，只把原版召唤的恼鬼清掉
#             （`kill @e[type=minecraft:vex,tag=!tspire_mob]`；我们自己的
#             【唤鬼】/【暗影帷幕】恼鬼带 tspire_mob 标签，不会被误杀）；
#   0        = 卫道士 —— 完全不会召唤的备选。
#   已放弃并删除代码的替代方案：封印 SpellTicks（法术全哑）、NoAI + 脚本 AI。
scoreboard players set #CFG_WEAVER_KEEP_EVOKER tspire_config 1

# ---------- 聊天栏干净程度 ----------
# 【v0.7.10 玩家要求】按钮都是用 /function 触发的，原版会回报
#   "该玩家触发了 N 条指令" / "执行了 N 条命令" 这类反馈 —— 每次点选项都刷一行。
#   1（默认）= 每局构筑开始前关掉 sendCommandFeedback（结算后仍保持关闭）
#   0        = 不改当前反馈状态（想自己调试可手动开启）
#   想永久关闭（包括不在局内）：/gamerule sendCommandFeedback false
scoreboard players set #CFG_HIDE_FEEDBACK tspire_config 1

# ---------- 预留（功能还没做，先占位，做了直接读这几个键） ----------
# 阵亡后复活保留的生命百分比（设计文档定的是 25）
scoreboard players set #CFG_REVIVE_HP_PERCENT tspire_config 25
