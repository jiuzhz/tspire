# ============================================================
# 开局构筑第一步：等待分批准备的第 1 层大厅，再逐行建房
# ============================================================
# 由 tick/second 在 #PICK_STAGE == 1 时调用。
# 这一步**不碰玩家**，所以他们不会被传进还没建好的虚空。
# ============================================================

scoreboard players set #PICK_STAGE tspire_timer 8
execute if score #MAP_USED tspire_timer matches 1 if score #MAP_BUILDING tspire_timer matches 1 run scoreboard players set #MAP_RESTART tspire_timer 1
# If this is a second run, restore all halls in small batches. A fresh load may
# already have finished the preparation before the player pressed Start.
execute if score #MAP_USED tspire_timer matches 1 unless score #MAP_BUILDING tspire_timer matches 1 run function tspire:map/prepare/start
execute unless score #MAP_READY1 tspire_timer matches 1 unless score #MAP_BUILDING tspire_timer matches 1 run function tspire:map/prepare/start
execute if score #MAP_READY1 tspire_timer matches 1 if score #MAP_USED tspire_timer matches 0 run function tspire:start/build_ready
