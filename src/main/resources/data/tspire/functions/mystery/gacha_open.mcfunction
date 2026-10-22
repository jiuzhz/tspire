# 抽奖机：**事件开始时**给每名存活队员各发一份菜单。
# 事件是 tick 链触发的（没有执行者），所以在这里 `as @a` 再调用本人的 gacha_menu。
# 之后每次抽奖只由 gacha_pull 调 gacha_menu —— 只有点击的人自己看到重印。
execute as @a[team=tspire_party,scores={tspire_dead=0}] run function tspire:mystery/gacha_menu
