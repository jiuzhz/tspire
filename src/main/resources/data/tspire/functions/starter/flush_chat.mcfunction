# 开局构筑阶段的聊天栏刷新（v0.7.11 玩家要求；v0.7.15 起改为由 gen-starter.ps1 复制本文件生成）。
# 构筑阶段会反复重印"护甲菜单 / 武器菜单"，旧菜单连着旧按钮一起留在聊天栏里。
# 1.20.1 没有删除聊天消息的指令，只能发空消息把上一屏顶出去（与 mystery/room_clear_chat 同一套做法）。
# 注意：本文件是**数据文件**，内容含中文；生成器 tools/gen-starter.ps1 必须保持纯 ASCII。
tellraw @s [{"text":" "}]
tellraw @s [{"text":" "}]
tellraw @s [{"text":" "}]
tellraw @s [{"text":" "}]
tellraw @s [{"text":" "}]
tellraw @s [{"text":" "}]
tellraw @s [{"text":" "}]
tellraw @s [{"text":" "}]
tellraw @s [{"text":"—— 以上是上一次的构筑选项，已作废 ——","color":"dark_gray","italic":true}]
