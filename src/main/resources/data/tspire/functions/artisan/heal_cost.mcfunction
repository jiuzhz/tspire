# Paid healing starts at the configured price and rises by 5 after each purchase this run.
scoreboard players operation @s tspire_heal_cost = #CFG_ARTISAN_HEAL_PAID_COST tspire_config
scoreboard players operation #TMP_STEP tspire_timer = @s tspire_heals
scoreboard players set #HEAL_STEP tspire_timer 5
scoreboard players operation #TMP_STEP tspire_timer *= #HEAL_STEP tspire_timer
scoreboard players operation @s tspire_heal_cost += #TMP_STEP tspire_timer
