# ============================================================
# 工匠节点装饰里的箱子内容（v0.7.21，玩家指定）
# ============================================================
# 箱子位置 = 捕获时读到的容器，相对房间中心 = (-6, 0, 0)
#   （源房间 x133 y57 z-7，锚点 x139 y57 z-7）
# 内容（玩家要求）：64 个模具 + 4 个毒液瓶 + 8 个末影黏液水晶 + 8 个湿海绵。
#   毒液瓶从旧版的 16 个减到 **4 个**。
# 先 `data merge` 清空 Items 再逐格放入 —— 保证不会混进源房间里残留的东西。
# 执行前提：**at 房间中心标记**（本函数在 map/build_workshop 里被调用）。
# ============================================================
data merge block ~-6 ~ ~0 {Items:[]}
item replace block ~-6 ~ ~0 container.0 with tconstruct:pattern 64
item replace block ~-6 ~ ~0 container.1 with tconstruct:venom_bottle 4
item replace block ~-6 ~ ~0 container.2 with tconstruct:ender_slime_crystal 8
item replace block ~-6 ~ ~0 container.3 with minecraft:wet_sponge 8
