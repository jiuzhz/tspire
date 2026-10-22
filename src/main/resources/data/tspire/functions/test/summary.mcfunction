# ============================================================
# 预览结算界面（用法：/function tspire:test/summary）
# ============================================================
# 只是拿当前分数把结算界面打印一遍，用来肉眼检查排版，不改动任何进度。
# 想看"失败"版本就把下面第 1 个 #RESULT 改成 0。
# ============================================================

scoreboard players set #RESULT tspire_timer 1
function tspire:run/summary
tellraw @s [{"text":"（上面是通关版预览；把 test/summary 里的 #RESULT 改成 0 可以看失败版）","color":"dark_gray"}]
