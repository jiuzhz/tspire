# ============================================================
# 裂颅者【钉刺陷阱】· 10 秒到点清场
# ============================================================
# 由 boss/skullcrusher_trap_check 在 #SKU_T2 >= 201 时调用。
# 清掉整批陷阱 marker、复位计时，并给一句提示。
# ============================================================

kill @e[tag=tspire_spike2]
scoreboard players set #SKU_T2 tspire_timer 0
tellraw @a[team=tspire_party] [{"text":"[裂颅者] ","color":"gray"},{"text":"尖刺消失了。","color":"dark_red"}]
