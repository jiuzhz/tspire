# ============================================================
# 商人货架 Demo —— 不需要真的走到商人节点
# ============================================================
# 用法：
#   /function tspire:test/shop_demo            第 1 层材料池
#   /scoreboard players set #FLOOR tspire_timer 2
#   /function tspire:test/shop_demo            第 2 层材料池
#
# 会在脚下生成货架与菜单。商品清单里每一条都是**预先抽好的具体物品**，
# 鼠标悬停能看到材料与阶级，点击即购买（价格不足会提示）。
# ============================================================

execute unless score #FLOOR tspire_timer matches 1.. run scoreboard players set #FLOOR tspire_timer 1

# 【v0.6.21 每人一份货架】shop/pick_f<层> 现在只负责抽签（写 @s tspire_shop_l），
# 摆柜台 / 弹菜单交给 merchant/open_own 与 merchant/open_menu。
# demo 里没有商人节点 marker，所以直接把柜台摆在脚下。
scoreboard players set @s tspire_shop_f 0
execute if score #FLOOR tspire_timer matches 1 run function tspire:shop/pick_f1
execute if score #FLOOR tspire_timer matches 2 run function tspire:shop/pick_f2
execute if score #FLOOR tspire_timer matches 3 run function tspire:shop/pick_f3

execute at @s run function tspire:merchant/open_own
function tspire:merchant/open_menu

tellraw @s [{"text":"[Demo] ","color":"gold"},{"text":"商人货架已生成（层数 ","color":"white"},{"score":{"name":"#FLOOR","objective":"tspire_timer"},"color":"yellow"},{"text":"，货架编号 ","color":"white"},{"score":{"name":"@s","objective":"tspire_shop_l"},"color":"aqua"},{"text":"）。想换一份：再执行一次即可。","color":"white"}]
