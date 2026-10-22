# ============================================================
# Boss 战音乐 · 曲长（v0.7.35）
# ============================================================
# 设 #MUSIC_T = 距离重播的秒数。
# 现在音乐开关是**逐人**的，同一队里可能有人听唱片、有人听资源包曲子，
# 而重播计时器是全局的 → 取两种模式的**较短**者，保证谁的曲子都不会被提前打断：
#   一层：min(原版 mellohi 100, 资源包 strive 108) = 100
#   二层：min(原版 13 182, 资源包 lost lace 174)    = 174
#   三层：153（三层没有资源包曲子，两边都是 pigstep）
# 曲长实测方式：tools 下自写的 Ogg 解析（页面 granule ÷ 采样率）。
# ============================================================

execute if score #MUSIC_BOSS tspire_timer matches 1 run scoreboard players set #MUSIC_T tspire_timer 100
execute if score #MUSIC_BOSS tspire_timer matches 2 run scoreboard players set #MUSIC_T tspire_timer 174
execute if score #MUSIC_BOSS tspire_timer matches 3 run scoreboard players set #MUSIC_T tspire_timer 153