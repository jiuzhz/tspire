# ============================================================
# 修复：扣钱 + 六个装备槽 + 整个物品栏(container.0..35)各套一次 set_damage
# 另按 v0.6.27 追加：修复次数 +1、额外给 32 支箭
# 执行者 = 玩家
# ============================================================

scoreboard players operation @s tspire_gold -= @s tspire_repair_cost
scoreboard players add @s tspire_repairs 1

item modify entity @s weapon.mainhand tspire:repair
item modify entity @s weapon.offhand tspire:repair
item modify entity @s armor.head tspire:repair
item modify entity @s armor.chest tspire:repair
item modify entity @s armor.legs tspire:repair
item modify entity @s armor.feet tspire:repair
item modify entity @s container.0 tspire:repair
item modify entity @s container.1 tspire:repair
item modify entity @s container.2 tspire:repair
item modify entity @s container.3 tspire:repair
item modify entity @s container.4 tspire:repair
item modify entity @s container.5 tspire:repair
item modify entity @s container.6 tspire:repair
item modify entity @s container.7 tspire:repair
item modify entity @s container.8 tspire:repair
item modify entity @s container.9 tspire:repair
item modify entity @s container.10 tspire:repair
item modify entity @s container.11 tspire:repair
item modify entity @s container.12 tspire:repair
item modify entity @s container.13 tspire:repair
item modify entity @s container.14 tspire:repair
item modify entity @s container.15 tspire:repair
item modify entity @s container.16 tspire:repair
item modify entity @s container.17 tspire:repair
item modify entity @s container.18 tspire:repair
item modify entity @s container.19 tspire:repair
item modify entity @s container.20 tspire:repair
item modify entity @s container.21 tspire:repair
item modify entity @s container.22 tspire:repair
item modify entity @s container.23 tspire:repair
item modify entity @s container.24 tspire:repair
item modify entity @s container.25 tspire:repair
item modify entity @s container.26 tspire:repair
item modify entity @s container.27 tspire:repair
item modify entity @s container.28 tspire:repair
item modify entity @s container.29 tspire:repair
item modify entity @s container.30 tspire:repair
item modify entity @s container.31 tspire:repair
item modify entity @s container.32 tspire:repair
item modify entity @s container.33 tspire:repair
item modify entity @s container.34 tspire:repair
item modify entity @s container.35 tspire:repair


# ---------------------------------------------------------------------------
# v0.7.11（玩家要求）：修复时**顺便给喷流刃补满流体**（耐久仍由上面的 tspire:repair 负责）。
# v0.7.14 BUG：原来用 `execute if items`（**1.20.5+ 语法**，1.20.1 不存在）-> 本函数整个加载失败。
#   改用 SelectedItem / Inventory 的 NBT 判定（与 merchant/sell、rewards/offer_* 同一套写法）。
#   槽位号：offhand=-106，feet=100，legs=101，chest=102，head=103，背包=0..35。
#   流体见 item_modifiers/artisan/refill_swasher_0..7.json（mantle:set_fluid，2000 mB（保持已有流体）；且**刀内无液体时不补**（v0.7.45））。
execute if entity @s[nbt={SelectedItem:{id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}}] run item modify entity @s weapon.mainhand tspire:artisan/refill_swasher_0
execute if entity @s[nbt={SelectedItem:{id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}}] run item modify entity @s weapon.mainhand tspire:artisan/refill_swasher_1
execute if entity @s[nbt={SelectedItem:{id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}}] run item modify entity @s weapon.mainhand tspire:artisan/refill_swasher_2
execute if entity @s[nbt={SelectedItem:{id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}}] run item modify entity @s weapon.mainhand tspire:artisan/refill_swasher_3
execute if entity @s[nbt={SelectedItem:{id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}}] run item modify entity @s weapon.mainhand tspire:artisan/refill_swasher_4
execute if entity @s[nbt={SelectedItem:{id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}}] run item modify entity @s weapon.mainhand tspire:artisan/refill_swasher_5
execute if entity @s[nbt={SelectedItem:{id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}}] run item modify entity @s weapon.mainhand tspire:artisan/refill_swasher_6
execute if entity @s[nbt={SelectedItem:{id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}}] run item modify entity @s weapon.mainhand tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:-106b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s weapon.offhand tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:-106b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s weapon.offhand tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:-106b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s weapon.offhand tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:-106b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s weapon.offhand tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:-106b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s weapon.offhand tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:-106b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s weapon.offhand tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:-106b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s weapon.offhand tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:-106b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s weapon.offhand tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:103b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s armor.head tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:103b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s armor.head tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:103b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s armor.head tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:103b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s armor.head tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:103b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s armor.head tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:103b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s armor.head tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:103b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s armor.head tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:103b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s armor.head tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:102b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s armor.chest tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:102b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s armor.chest tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:102b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s armor.chest tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:102b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s armor.chest tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:102b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s armor.chest tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:102b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s armor.chest tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:102b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s armor.chest tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:102b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s armor.chest tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:101b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s armor.legs tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:101b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s armor.legs tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:101b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s armor.legs tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:101b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s armor.legs tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:101b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s armor.legs tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:101b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s armor.legs tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:101b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s armor.legs tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:101b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s armor.legs tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:100b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s armor.feet tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:100b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s armor.feet tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:100b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s armor.feet tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:100b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s armor.feet tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:100b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s armor.feet tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:100b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s armor.feet tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:100b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s armor.feet tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:100b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s armor.feet tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:0b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.0 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:0b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.0 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:0b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.0 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:0b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.0 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:0b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.0 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:0b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.0 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:0b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.0 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:0b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.0 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:1b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.1 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:1b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.1 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:1b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.1 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:1b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.1 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:1b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.1 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:1b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.1 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:1b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.1 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:1b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.1 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:2b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.2 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:2b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.2 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:2b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.2 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:2b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.2 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:2b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.2 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:2b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.2 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:2b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.2 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:2b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.2 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:3b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.3 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:3b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.3 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:3b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.3 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:3b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.3 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:3b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.3 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:3b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.3 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:3b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.3 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:3b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.3 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:4b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.4 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:4b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.4 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:4b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.4 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:4b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.4 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:4b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.4 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:4b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.4 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:4b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.4 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:4b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.4 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:5b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.5 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:5b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.5 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:5b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.5 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:5b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.5 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:5b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.5 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:5b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.5 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:5b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.5 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:5b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.5 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:6b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.6 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:6b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.6 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:6b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.6 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:6b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.6 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:6b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.6 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:6b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.6 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:6b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.6 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:6b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.6 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:7b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.7 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:7b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.7 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:7b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.7 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:7b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.7 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:7b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.7 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:7b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.7 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:7b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.7 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:7b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.7 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:8b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.8 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:8b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.8 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:8b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.8 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:8b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.8 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:8b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.8 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:8b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.8 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:8b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.8 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:8b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.8 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:9b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.9 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:9b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.9 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:9b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.9 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:9b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.9 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:9b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.9 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:9b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.9 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:9b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.9 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:9b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.9 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:10b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.10 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:10b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.10 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:10b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.10 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:10b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.10 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:10b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.10 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:10b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.10 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:10b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.10 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:10b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.10 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:11b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.11 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:11b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.11 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:11b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.11 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:11b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.11 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:11b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.11 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:11b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.11 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:11b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.11 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:11b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.11 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:12b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.12 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:12b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.12 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:12b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.12 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:12b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.12 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:12b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.12 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:12b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.12 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:12b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.12 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:12b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.12 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:13b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.13 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:13b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.13 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:13b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.13 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:13b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.13 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:13b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.13 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:13b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.13 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:13b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.13 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:13b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.13 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:14b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.14 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:14b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.14 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:14b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.14 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:14b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.14 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:14b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.14 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:14b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.14 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:14b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.14 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:14b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.14 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:15b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.15 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:15b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.15 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:15b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.15 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:15b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.15 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:15b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.15 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:15b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.15 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:15b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.15 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:15b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.15 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:16b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.16 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:16b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.16 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:16b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.16 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:16b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.16 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:16b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.16 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:16b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.16 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:16b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.16 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:16b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.16 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:17b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.17 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:17b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.17 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:17b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.17 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:17b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.17 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:17b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.17 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:17b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.17 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:17b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.17 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:17b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.17 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:18b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.18 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:18b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.18 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:18b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.18 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:18b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.18 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:18b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.18 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:18b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.18 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:18b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.18 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:18b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.18 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:19b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.19 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:19b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.19 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:19b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.19 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:19b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.19 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:19b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.19 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:19b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.19 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:19b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.19 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:19b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.19 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:20b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.20 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:20b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.20 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:20b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.20 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:20b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.20 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:20b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.20 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:20b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.20 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:20b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.20 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:20b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.20 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:21b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.21 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:21b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.21 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:21b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.21 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:21b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.21 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:21b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.21 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:21b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.21 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:21b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.21 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:21b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.21 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:22b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.22 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:22b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.22 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:22b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.22 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:22b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.22 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:22b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.22 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:22b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.22 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:22b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.22 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:22b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.22 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:23b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.23 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:23b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.23 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:23b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.23 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:23b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.23 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:23b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.23 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:23b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.23 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:23b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.23 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:23b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.23 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:24b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.24 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:24b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.24 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:24b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.24 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:24b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.24 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:24b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.24 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:24b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.24 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:24b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.24 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:24b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.24 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:25b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.25 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:25b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.25 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:25b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.25 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:25b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.25 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:25b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.25 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:25b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.25 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:25b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.25 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:25b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.25 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:26b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.26 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:26b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.26 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:26b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.26 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:26b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.26 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:26b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.26 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:26b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.26 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:26b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.26 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:26b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.26 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:27b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.27 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:27b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.27 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:27b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.27 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:27b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.27 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:27b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.27 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:27b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.27 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:27b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.27 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:27b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.27 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:28b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.28 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:28b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.28 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:28b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.28 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:28b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.28 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:28b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.28 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:28b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.28 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:28b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.28 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:28b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.28 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:29b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.29 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:29b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.29 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:29b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.29 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:29b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.29 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:29b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.29 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:29b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.29 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:29b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.29 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:29b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.29 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:30b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.30 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:30b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.30 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:30b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.30 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:30b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.30 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:30b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.30 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:30b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.30 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:30b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.30 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:30b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.30 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:31b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.31 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:31b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.31 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:31b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.31 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:31b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.31 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:31b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.31 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:31b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.31 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:31b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.31 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:31b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.31 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:32b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.32 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:32b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.32 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:32b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.32 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:32b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.32 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:32b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.32 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:32b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.32 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:32b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.32 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:32b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.32 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:33b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.33 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:33b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.33 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:33b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.33 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:33b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.33 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:33b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.33 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:33b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.33 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:33b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.33 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:33b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.33 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:34b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.34 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:34b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.34 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:34b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.34 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:34b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.34 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:34b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.34 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:34b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.34 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:34b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.34 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:34b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.34 tspire:artisan/refill_swasher_7
execute if entity @s[nbt={Inventory:[{Slot:35b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:water",Amount:1..}}}]}] run item modify entity @s container.35 tspire:artisan/refill_swasher_0
execute if entity @s[nbt={Inventory:[{Slot:35b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"minecraft:lava",Amount:1..}}}]}] run item modify entity @s container.35 tspire:artisan/refill_swasher_1
execute if entity @s[nbt={Inventory:[{Slot:35b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:powdered_snow",Amount:1..}}}]}] run item modify entity @s container.35 tspire:artisan/refill_swasher_2
execute if entity @s[nbt={Inventory:[{Slot:35b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:earth_slime",Amount:1..}}}]}] run item modify entity @s container.35 tspire:artisan/refill_swasher_3
execute if entity @s[nbt={Inventory:[{Slot:35b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:sky_slime",Amount:1..}}}]}] run item modify entity @s container.35 tspire:artisan/refill_swasher_4
execute if entity @s[nbt={Inventory:[{Slot:35b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:ichor",Amount:1..}}}]}] run item modify entity @s container.35 tspire:artisan/refill_swasher_5
execute if entity @s[nbt={Inventory:[{Slot:35b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_queens_slime",Amount:1..}}}]}] run item modify entity @s container.35 tspire:artisan/refill_swasher_6
execute if entity @s[nbt={Inventory:[{Slot:35b,id:"tconstruct:swasher",tag:{Fluid:{FluidName:"tconstruct:molten_netherite",Amount:1..}}}]}] run item modify entity @s container.35 tspire:artisan/refill_swasher_7

give @s minecraft:arrow 32

tellraw @s [{"text":"[工匠节点] ","color":"gold"},{"text":"已修复全身装备与背包里的工具（喷流刃同时补满流体），并附赠 32 支箭。剩余金币 ","color":"green"},{"score":{"name":"@s","objective":"tspire_gold"},"color":"gold"},{"text":" 金币","color":"green"}]
tellraw @s [{"text":"下次修复价格：","color":"gray"},{"score":{"name":"@s","objective":"tspire_repair_cost"},"color":"yellow"},{"text":" 金币 + 5","color":"gray"}]
playsound minecraft:block.anvil.use master @s ~ ~ ~ 1 1.2
