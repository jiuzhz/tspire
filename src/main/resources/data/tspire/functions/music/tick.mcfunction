# ============================================================
# Boss 战音乐 · 每 1 秒（由 tick/second 调用，v0.7.26）
# ============================================================
# 唱片不是"循环音源"：`playsound` 播完就没了，所以这里按曲长倒数、到点重播。
# 同时也负责"塔内常态 BGM"的间隔计时。
# ============================================================

# --- Boss 曲：倒数 + 到点重播 ---
execute if score #MUSIC_BOSS tspire_timer matches 1.. run scoreboard players remove #MUSIC_T tspire_timer 1
execute if score #MUSIC_BOSS tspire_timer matches 1.. if score #MUSIC_T tspire_timer matches ..0 run function tspire:music/boss_replay

# --- 塔内常态 BGM：没有 Boss 曲时按间隔播一首安静的原版曲子 ---
# v0.7.48 玩家要求：**只保留 Boss 音乐**，塔内常态 BGM 已停用（想恢复就取消下面两行的注释）
# execute if score #MUSIC_BOSS tspire_timer matches 0 run scoreboard players remove #MUSIC_AMB tspire_timer 1
# execute if score #MUSIC_BOSS tspire_timer matches 0 if score #MUSIC_AMB tspire_timer matches ..0 run function tspire:music/ambient_play
