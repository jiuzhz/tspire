# ============================================================
# 切回"原版音乐"（v0.7.35：**逐人**开关）—— 默认模式
# ============================================================
# 用法：/function tspire:music/rp_off
# 一层 mellohi / 二层 13 / 三层 pigstep，全都不需要资源包。
# ============================================================

scoreboard players set @s tspire_music_rp 0
stopsound @s music
tellraw @s [{"text":"[音乐] ","color":"gold","bold":true},{"text":"已为你切回","color":"white"},{"text":"原版版","color":"aqua"},{"text":"：Boss 战一层 mellohi、二层 13、三层 pigstep。","color":"white"}]