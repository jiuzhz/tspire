# ============================================================
# Boss 战音乐 · 收摊（v0.7.26）
# ============================================================
# 由 run/battle_win（战斗胜利）与 run/win（通关）调用。
# 掐掉 Boss 曲并把 #MUSIC_BOSS 归零 —— 归零之后 music/tick 就会重新开始计算
# "塔内常态 BGM"的间隔（所以打完 Boss 不会立刻又响一首，而是过几分钟才来）。
# ============================================================

stopsound @a[team=tspire_party] music
scoreboard players set #MUSIC_BOSS tspire_timer 0
scoreboard players set #MUSIC_T tspire_timer 0
