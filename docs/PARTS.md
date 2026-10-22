# 匠魂工具槽位与部件对照表

**来源**：`D:\舜\存档\shipin3\TConstruct-1.20.1-3.12.0.220\data\tconstruct\tinkering\tool_definitions\*.json`（逐个解析导出）

**硬约束**：`tconstruct:add_tool_data` 与 `tconstruct:mob_equipment` 的 `materials` 数组长度**必须与本表的槽数严格一致**。长度对不上时多余槽位会被**静默跳过**（不报错，但面板偏低）——这是最常见的隐性 bug。

---

## 全部工具（按字母序）

| 工具 ID | 槽数 | 部件（槽位顺序） |
| --- | --- | --- |
| `tconstruct:arrow` | 3 | arrow_head, arrow_shaft, fletching |
| `tconstruct:battlesign` | 2 | head, plating_shield |
| `tconstruct:broad_axe` | 4 | broad_axe_head, tough_handle, pick_head, tough_binding |
| `tconstruct:cleaver` | 4 | broad_blade, tough_handle, tough_handle, large_plate |
| `tconstruct:crossbow` | 3 | bow_limb, bow_grip, bowstring |
| `tconstruct:dagger` | 2 | small_blade, tool_handle |
| `tconstruct:earth_staff` | 0 | （无法独立改装） |
| `tconstruct:ender_staff` | 0 | （同上） |
| `tconstruct:excavator` | 4 | large_plate, tough_handle, tough_binding, tough_handle |
| `tconstruct:fishing_rod` | 3 | bow_limb, bowstring, arrow_head |
| `tconstruct:flint_and_brick` | 0 | （同上） |
| `tconstruct:hand_axe` | 3 | small_axe_head, tool_handle, tool_binding |
| `tconstruct:ichor_staff` | 0 | （同上） |
| `tconstruct:javelin` | 4 | small_blade, tool_handle, bow_limb, bow_grip |
| `tconstruct:kama` | 3 | small_blade, tool_handle, tool_binding |
| `tconstruct:longbow` | 4 | bow_limb, bow_limb, bow_grip, bowstring |
| `tconstruct:mattock` | 3 | small_axe_head, tool_handle, adze_head |
| `tconstruct:melting_pan` | 2 | plating_shield, limb |
| `tconstruct:minotaur_axe` | 3 | head, head, handle |
| `tconstruct:pickadze` | 3 | pick_head, tool_handle, adze_head |
| `tconstruct:pickaxe` | 3 | pick_head, tool_handle, tool_binding |
| `tconstruct:plate_boots` | 2 | boots_plating, maille |
| `tconstruct:plate_chestplate` | 2 | chestplate_plating, maille |
| `tconstruct:plate_helmet` | 2 | helmet_plating, maille |
| `tconstruct:plate_leggings` | 2 | leggings_plating, maille |
| `tconstruct:plate_shield` | 2 | shield_core, plating_shield |
| `tconstruct:scythe` | 4 | broad_blade, tough_handle, tough_binding, tough_handle |
| `tconstruct:shuriken` | 2 | arrow_head, arrow_head |
| `tconstruct:sky_staff` | 0 | （同上） |
| `tconstruct:sledge_hammer` | 4 | hammer_head, tough_handle, large_plate, large_plate |
| `tconstruct:slime_boots` | 2 | laces, slime |
| `tconstruct:slime_chestplate` | 2 | ribcage, slime |
| `tconstruct:slime_helmet` | 2 | skull, slime |
| `tconstruct:slime_leggings` | 2 | shell, slime |
| `tconstruct:slime_wings` | 1 | slime |
| `tconstruct:swasher` | 3 | head, handle, grip |
| `tconstruct:sword` | 3 | small_blade, tool_handle, tool_handle |
| `tconstruct:throwing_axe` | 2 | arrow_head, arrow_shaft |
| `tconstruct:travelers_boots` | 2 | plating_boots, cuirass |
| `tconstruct:travelers_chestplate` | 2 | plating_chestplate, cuirass |
| `tconstruct:travelers_helmet` | 2 | plating_helmet, cuirass |
| `tconstruct:travelers_leggings` | 2 | plating_leggings, cuirass |
| `tconstruct:travelers_shield` | 2 | shield_core, cuirass |
| `tconstruct:vein_hammer` | 4 | hammer_head, tough_handle, tough_binding, large_plate |
| `tconstruct:war_pick` | 3 | head, limb, bowstring |

> 表中部件名省略了 `tconstruct:` 前缀，实际写配置时需补全。
> 用 `material_stats`（而非 `part_stats`）定义的工具，部件来自 `stat_types` 字段，本表已展开。

---

## 本方案实际用到的工具（与设计文档 §2.3 / §3.3 对应）

| 用途 | 工具 | 槽数 | 部件 |
| --- | --- | --- | --- |
| 开局武器·剑 | `tconstruct:sword` | 3 | small_blade + tool_handle ×2 |
| 开局武器·匕首 | `tconstruct:dagger` | 2 | small_blade + tool_handle |
| 开局武器·镰刀 | `tconstruct:scythe` | 4 | broad_blade + tough_handle + tough_binding + tough_handle |
| 开局武器·劈刀 | `tconstruct:cleaver` | 4 | broad_blade + tough_handle ×2 + large_plate |
| 开局武器·弩 | `tconstruct:crossbow` | 3 | bow_limb + bow_grip + bowstring |
| 开局武器·板斧 | `tconstruct:broad_axe` | 4 | broad_axe_head + tough_handle + pick_head + tough_binding |
| 开局武器·标枪 | `tconstruct:javelin` | 4 | small_blade + tool_handle + bow_limb + bow_grip |
| 开局武器·长弓 | `tconstruct:longbow` | 4 | bow_limb ×2 + bow_grip + bowstring |
| 开局武器·镶板盾牌 | `tconstruct:plate_shield` | 2 | shield_core + plating_shield |
| 开局武器·旅行者盾牌 | `tconstruct:travelers_shield` | 2 | shield_core + cuirass |
| 初始装备·镶板套装 | `tconstruct:plate_{helmet,chestplate,leggings,boots}` | 2 | 各自 plating + maille |
| 初始装备·旅行者套装 | `tconstruct:travelers_{helmet,chestplate,leggings,boots}` | 2 | 各自 plating + cuirass |
| 初始装备·黏液套装 | `tconstruct:slime_{helmet,chestplate,leggings,boots}` | 2 | skull/ribcage/shell/laces + slime |
| 投掷·手里剑 | `tconstruct:shuriken` | 2 | arrow_head ×2 |
| 投掷·投斧 | `tconstruct:throwing_axe` | 2 | arrow_head + arrow_shaft |
| 弹药·箭 | `tconstruct:arrow` | 3 | arrow_head + arrow_shaft + fletching |
| 远古·熔炼锅 | `tconstruct:melting_pan` | 2 | plating_shield + limb |
| 远古·战争镐 | `tconstruct:war_pick` | 3 | head + limb + bowstring |
| 远古·战斗牌 | `tconstruct:battlesign` | 2 | head + plating_shield |
| 远古·喷流刃 | `tconstruct:swasher` | 3 | head + handle + grip |
