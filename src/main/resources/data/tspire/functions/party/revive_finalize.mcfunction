# Two ticks after spectator -> adventure, read real Health and apply configured revive HP.
execute as @a[tag=tspire_revive_pending,team=tspire_party,scores={tspire_dead=0}] run function tspire:party/revive_hp
tag @a[tag=tspire_revive_pending] remove tspire_revive_pending
