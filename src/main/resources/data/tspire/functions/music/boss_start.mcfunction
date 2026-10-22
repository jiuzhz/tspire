# ============================================================
# Boss 战音乐 · 开始（v0.7.27）
# ============================================================
# 两种模式（由 music/rp_on|off 切换，见 boss_play 的说明）：
#   原版：一层 mellohi / 二层 13 / 三层 pigstep
#   资源包：一层 strive / 二层 lost lace（三层暂回落 pigstep）
#
# 由 map/enter_boss 在 boss/spawn 之后调用。
# 计时器全部挂在假玩家、复用现有 tspire_timer 计分板 —— **不新增目标**：
#   #MUSIC_BOSS = 当前在放哪一层的 Boss 曲（0 = 没有）
#   #MUSIC_T    = 还剩几秒重播（唱片/曲子不是循环音源，只能按曲长手动重播）
#   #MUSIC_AMB  = 距离下一首"塔内常态 BGM"还有几秒
#   tspire_music_rp = **逐人**开关（0/未设 = 原版唱片，1 = 资源包曲子，见 music/rp_on）
# ============================================================

scoreboard players operation #MUSIC_BOSS tspire_timer = #FLOOR tspire_timer
# 兜底：层数异常时按一层处理
execute unless score #MUSIC_BOSS tspire_timer matches 1..3 run scoreboard players set #MUSIC_BOSS tspire_timer 1

# 先把上一首（常态 BGM 或上一个 Boss 的曲子）掐掉，再起新的
stopsound @a[team=tspire_party] music

function tspire:music/boss_len
function tspire:music/boss_play
