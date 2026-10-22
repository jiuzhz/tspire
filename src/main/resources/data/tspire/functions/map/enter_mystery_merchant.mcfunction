# 神秘节点掷到"其实是商人"（15%）—— 直接复用商人节点流程
#
# 【v0.7 关键修正】必须**先把类型标签换掉**：
#   map/enter_merchant 会给节点打上 tspire_node_reusable（以后还能回来买东西），
#   而"回来"走的是 map/enter_service —— 那里是**按类型标签分发**的
#   （`tag=tspire_type_artisan` / `tag=tspire_type_merchant`）。
#   标签还留着 mystery 的话，第二次走进这个房间会什么都不发生（门开了却没菜单）。
#   顺便：换标签不影响地砖颜色 —— 青色地砖会一直留着，玩家自己发现"这间其实是商店"。
execute as @e[tag=tspire_node_current,limit=1] run tag @s add tspire_type_merchant
execute as @e[tag=tspire_node_current,limit=1] run tag @s remove tspire_type_mystery
tellraw @a[team=tspire_party] [{"text":"[神秘节点] ","color":"light_purple","bold":true},{"text":"推开门的瞬间，你发现这里根本就是个货摊 —— 商人已经在等着了。","color":"yellow"}]
function tspire:map/enter_merchant