# Capture chosen serial, then search every player and every tower item entity.
execute if score #MYST_EV tspire_timer matches 24 if score @s tspire_my_choice matches 0 if score @s tspire_br2 matches 1.. run function tspire:mystery/bridge_choose_2
