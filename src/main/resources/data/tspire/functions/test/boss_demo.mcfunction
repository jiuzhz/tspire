# ============================================================
# Boss 演示：直接开一场 Boss 战，不用走完整地图
# 用法：/function tspire:test/boss_demo
# 会先把你送进尖塔维度（否则猪灵会僵尸化）
# ============================================================
# 换层用带层号的版本：
#   /function tspire:test/boss_demo_f1
#   /function tspire:test/boss_demo_f2
#   /function tspire:test/boss_demo_f3
#
# 观察点：
#   - 屏幕中央 Boss 名 + 龙吼
#   - 血量 300 / 600 / 1000（按层），攻击 8 / 14 / 20
#   - 拿高一档材料的匠魂装备（淬火者除外，烈焰人没有手部槽位）
#   - 主动技能按固定秒数释放；掉到阶段阈值播 actionbar「!! PHASE 2 !!」
# ============================================================

# v0.7.2：改用共享的"真实 BOSS 房"准备流程（enter_tower + forceload + build_floor +
#   标当前节点 + 全队传送 + battle_start）。以前这里只 kill 两只、设几个开关就去 spawn，
#   而 spawn 的原点是 @e[tag=tspire_test_node] —— 新开一局时它根本不存在，于是"什么都没发生"。
# v0.7.4：生成交给两拍流程（#TESTBOSS=0 -> 按 #FLOOR 随机）
scoreboard players set #TESTBOSS tspire_timer 0
function tspire:test/boss_arena_setup

tellraw @s [{"text":"[Boss 演示] ","color":"gold"},{"text":"已开战。清理：","color":"yellow"},{"text":"/execute in tspire:tower run kill @e[tag=tspire_boss]","color":"yellow"}]
