# ============================================================
# Boss 战音乐 · 播放（v0.7.35，**逐人**两版本）
# ============================================================
#   tspire_music_rp 未设或 0 → 原版唱片：一层 mellohi / 二层 13 / 三层 pigstep
#   tspire_music_rp = 1     → 资源包曲子：一层 tspire:music.boss.tier1（strive）
#                                          二层 tspire:music.boss.tier2（lost lace）
#                                          三层暂缺 → 回落原版 pigstep
#
# 由 boss_start / boss_replay 调用；每个人按自己的开关各自收到一条 playsound
# （所以"装了包的听新曲、没装包的听唱片"可以同时成立）。
# ============================================================

# --- 原版模式（未设置也走这里，所以不需要初始化即可工作） ---
execute if score #MUSIC_BOSS tspire_timer matches 1 as @a[team=tspire_party] unless entity @s[scores={tspire_music_rp=1}] at @s run playsound minecraft:music_disc.mellohi music @s ~ ~ ~ 1.4 1 1
execute if score #MUSIC_BOSS tspire_timer matches 2 as @a[team=tspire_party] unless entity @s[scores={tspire_music_rp=1}] at @s run playsound minecraft:music_disc.13 music @s ~ ~ ~ 1.4 1 1
execute if score #MUSIC_BOSS tspire_timer matches 3 as @a[team=tspire_party] unless entity @s[scores={tspire_music_rp=1}] at @s run playsound minecraft:music_disc.pigstep music @s ~ ~ ~ 1.4 1 1

# --- 资源包模式 ---
execute if score #MUSIC_BOSS tspire_timer matches 1 as @a[team=tspire_party,scores={tspire_music_rp=1}] at @s run playsound tspire:music.boss.tier1 music @s ~ ~ ~ 1.4 1 1
execute if score #MUSIC_BOSS tspire_timer matches 2 as @a[team=tspire_party,scores={tspire_music_rp=1}] at @s run playsound tspire:music.boss.tier2 music @s ~ ~ ~ 1.4 1 1
execute if score #MUSIC_BOSS tspire_timer matches 3 as @a[team=tspire_party,scores={tspire_music_rp=1}] at @s run playsound minecraft:music_disc.pigstep music @s ~ ~ ~ 1.4 1 1