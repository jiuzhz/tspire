# ============================================================
# 塔内常态 BGM（v0.7.26，由 music/tick 在间隔到点时调用）
# ============================================================
# 只有**原版**音乐（不需要资源包）。
#   这里用最保险的 `minecraft:music.game` —— 它是各版本都存在的经典主世界曲目。
#   （如果以后想换成 `music.overworld.*` 那批洞穴曲，先确认事件名再换，否则日志会刷
#    `Unknown sound event`。）
#
# 间隔：8 / 9 / 10 分钟一首（480 / 540 / 600 秒），避免太频繁。
#       Boss 曲结束后不会立刻接一首：music/boss_stop 会把 #MUSIC_BOSS 归零，
#       之后这里才重新开始倒数。
# ============================================================

execute as @a[team=tspire_party] at @s run playsound minecraft:music.game music @s ~ ~ ~ 0.7 1

# 掷 1..5 → 480 / 540 / 600（用 util/roll_d5，本包已有的均匀掷骰）
function tspire:util/roll_d5
scoreboard players set #MUSIC_AMB tspire_timer 480
execute if score #ROLL tspire_timer matches 3..4 run scoreboard players set #MUSIC_AMB tspire_timer 540
execute if score #ROLL tspire_timer matches 5 run scoreboard players set #MUSIC_AMB tspire_timer 600
