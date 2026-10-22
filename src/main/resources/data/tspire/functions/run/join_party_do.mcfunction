# New-run signup: discard only previous-run transient state.
# load/join remains idempotent for /reload during an active run.
scoreboard players set @s tspire_phase 0
scoreboard players set @s tspire_dead 0
scoreboard players set @s tspire_deaths 0
scoreboard players set @s tspire_service 0
scoreboard players set @s tspire_ready 0
scoreboard players set @s tspire_offer 0
function tspire:load/join
