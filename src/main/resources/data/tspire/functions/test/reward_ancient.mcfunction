# ============================================================
# 远古工具直抽测试
# 用法：/function tspire:test/reward_ancient
# ============================================================
# 不走 2.5% 的权重，直接把远古工具表抽 4 次。
#
# 期望：每次都给出一件远古工具
#   熔炼锅（Melting Pan，2 槽）
#   战争镐（War Pick，3 槽）
#   战斗牌（Battlesign，2 槽）
#   喷流刃（Swasher，3 槽）
# 每件的部件材料是「远古」随机材料（tconstruct:ancient）。
#
# 若一件都不出，说明 add_tool_data + tconstruct:ancient 这条组合有问题，
# 需要改用 tconstruct:fixed 或检查槽数是否匹配。
# ============================================================

loot give @s loot tspire:rewards/ancient
loot give @s loot tspire:rewards/ancient
loot give @s loot tspire:rewards/ancient
loot give @s loot tspire:rewards/ancient

tellraw @s [{"text":"[远古工具直抽] ","color":"gold"},{"text":"应看到 4 件远古工具（熔炼锅/战争镐/战斗牌/喷流刃）。","color":"white"}]
