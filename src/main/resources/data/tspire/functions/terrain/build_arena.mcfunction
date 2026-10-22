# ============================================================
# 建一个简易竞技场（临时方案，用来跑通战斗闭环）
# 用法：站在想作为场地中心的位置，/function tspire:terrain/build_arena
# ============================================================
# 设计文档 §3.5 原本规划的是 .nbt 结构模板，但结构模板是二进制文件、
# 无法用文本工具生成，所以先用 /fill 程序化搭一个等效的场地。
# 后续换成正式房间模板时，只要保持「有中心 marker + 北面有门洞」即可，
# lock / unlock 不用改。
# ============================================================

# 清掉旧场地与旧 marker
kill @e[tag=tspire_arena]
fill ~-11 ~-2 ~-11 ~11 ~6 ~11 minecraft:air

# 地面
fill ~-10 ~-1 ~-10 ~10 ~-1 ~10 minecraft:polished_andesite

# 四面墙（高 4 格）
fill ~-10 ~ ~-10 ~10 ~3 ~-10 minecraft:stone_bricks
fill ~-10 ~ ~10 ~10 ~3 ~10 minecraft:stone_bricks
fill ~-10 ~ ~-10 ~-10 ~3 ~10 minecraft:stone_bricks
fill ~10 ~ ~-10 ~10 ~3 ~10 minecraft:stone_bricks

# 北面门洞（3 宽 3 高），战斗开始时用屏障封住
fill ~-1 ~ ~-10 ~1 ~2 ~-10 minecraft:air

# 中心标记：lock / unlock 靠它定位，换场地不用改函数
summon minecraft:marker ~ ~ ~ {Tags:["tspire_arena"],CustomName:'"尖塔竞技场"'}
