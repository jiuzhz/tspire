# ============================================================
# 商人节点的「柜面」（执行者 = 当前节点 marker）
# ============================================================
# 【v0.7.21 玩家要求】柜台装饰改成**玩家手搭的商人节点装饰**
#   （tools/gen-deco.js 捕获；锚点 = 房间中心、地板行走层）。
#   玩家那套自带讲台 / 遮阳布（白黄羊毛）+ 原木柱 + 海晶灯 + 交易用箱子与木桶，
#   所以旧的手摆方块（讲台、石砖、两盏灯笼、玩家交换箱）**全部删除**。
#
#   仍然由本函数负责**召唤商人 NPC**：
#     · 位置 (1, 0, -5)：已用生成器体检过 —— 玩家装饰的北侧 (-3..3, z-6..-2) 全是空地；
#     · NoAI + 无敌 + DeathLootTable 置空（否则被打死会掉命名牌）；
#     · 朝向由 tick 里那段"每秒面向最近玩家"负责（按 tspire_merchant_npc 标签）。
#
# 【重要】商店真正的"货架"不在装饰里：它是**节点下方 y-2 的带锁箱子**
#   （shop/f<层>_l<号>_fill 每次进店重建，位置 = 节点 ~ ~-2 ~），
#   而本装饰只覆盖 y-1..y+4，**碰不到它** —— 所以换装饰不会影响买卖。
#
# 只建一次：由 map/enter_merchant 用 tspire_node_built 标记保证。
# ============================================================

# 装饰本体（含方块实体：讲台 / 箱子 / 木桶）
function tspire:deco/merchant

# 商人 NPC
execute in tspire:tower run kill @e[tag=tspire_merchant_npc]
summon minecraft:villager ~1 ~ ~-5 {Tags:["tspire_merchant_npc"],NoAI:1b,Invulnerable:1b,PersistenceRequired:1b,DeathLootTable:"minecraft:empty",CustomName:'"商人"',CustomNameVisible:1b,VillagerData:{type:"minecraft:plains",profession:"minecraft:librarian",level:3}}
