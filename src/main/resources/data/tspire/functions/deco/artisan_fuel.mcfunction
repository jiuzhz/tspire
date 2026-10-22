# ============================================================
# 工匠节点 · 冶炼炉燃料储罐保持空置
# ============================================================
# Entering the artisan room empties all nine fuel tanks, including old rooms.
# The room decoration generator also omits captured fuel-tank contents.
# Called at the current room center by map/enter_artisan.
# ============================================================
data merge block ~4 ~1 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
data merge block ~5 ~1 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
data merge block ~6 ~1 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
data merge block ~4 ~2 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
data merge block ~5 ~2 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
data merge block ~6 ~2 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
data merge block ~4 ~3 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
data merge block ~5 ~3 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
data merge block ~6 ~3 ~-2 {tank:{FluidName:"minecraft:empty",Amount:0}}
