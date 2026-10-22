# 冲掉聊天栏（v0.7.9）：把一个事件 / 房间的旧按钮顶出可视区。
# 1.20.1 **没有"清空聊天"的指令**，只能用若干条空消息把内容顶上去。
# v0.7.9 改动：原来是一条消息里塞 14 个 `\\n`。SNBT 里写单个 `\n` 会让**整个函数加载失败**，
#   写 `\\n` 又可能被当成字面 `\n` 显示 —— 所以改成**10 条各自独立的 tellraw**：
#   一条 = 聊天栏里一行，不需要任何转义，行为确定（正好盖住默认 10 行聊天框）。
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":" "}]
tellraw @a[team=tspire_party] [{"text":"—— 以上为上一轮内容，其中的按钮已作废 ——","color":"dark_gray","italic":true}]
