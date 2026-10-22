# ============================================================
# 匠魂尖塔 - 一键跑全部验证（V1~V5）
# 建议开创造模式、超平坦世界执行
# 用法：/function tspire:test/all
# ============================================================

tellraw @s [{"text":"==== 匠魂尖塔 技术验证 V1~V5 ====","color":"gold"}]
tellraw @s [{"text":"前置：必须已加载 Tinkers' Construct 3.12.0.220 + Mantle 1.11.117","color":"gray"}]

function tspire:test/v1_tool_nbt
function tspire:test/v3_add_tool_data
function tspire:test/v4_material_tag
function tspire:test/v2_mob_damage
function tspire:test/v5_mob_equipment
function tspire:test/v7_summon_gear

tellraw @s [{"text":"---- 请按 docs/VERIFY.md 逐条记录结果 ----","color":"yellow"}]
