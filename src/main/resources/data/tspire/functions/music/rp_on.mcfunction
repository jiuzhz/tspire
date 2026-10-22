# ============================================================
# 切到"资源包版音乐"（v0.7.35：**逐人**开关）
# ============================================================
# 用法：装好 resourcepack 之后，**每名想听的玩家各自**执行
#   /function tspire:music/rp_on     → 自己的 Boss 战改用资源包曲子（一层 strive / 二层 lost lace）
#   /function tspire:music/rp_off    → 自己切回原版唱片
#
# 为什么是逐人：多人时数据包对每个人分别 playsound，所以"谁装包谁开"最合理 ——
#   没装包的人保持原版唱片，不会静音；装了包的人开自己的。
#
# ⚠️ 仍然必须手动切：1.20.1 没有任何指令能"检测某个音效事件是否存在"，
#    没装资源包却开着 = 自己的一层/二层 Boss 战静音（日志里刷 Unknown sound event）。
#    `/reload` 之后会回到默认（原版模式），要再执行一次 rp_on。
# ============================================================

scoreboard players set @s tspire_music_rp 1
tellraw @s {"text":"[音乐] 这个选择会一直保留，直到你执行 /function tspire:music/rp_off。","color":"gray"}
stopsound @s music
tellraw @s [{"text":"[音乐] ","color":"gold","bold":true},{"text":"已为你切到","color":"white"},{"text":"资源包版","color":"aqua"},{"text":"：Boss 战一层用 strive、二层用 lost lace（三层暂时仍是原版 pigstep）。","color":"white"}]
tellraw @s [{"text":"       没装资源包的话你自己听不到一层/二层的 Boss 曲 —— 用 ","color":"gray"},{"text":"/function tspire:music/rp_off","color":"yellow"},{"text":" 切回。","color":"gray"}]
