extends Node

signal puppet_crafted(puppet_data)
signal puppet_dispatched(puppet_id, region)
signal puppet_returned(puppet_id, results)
signal puppet_damaged(puppet_id, damage)
signal puppet_destroyed(puppet_id)
signal battle_started(enemy_data)
signal battle_ended(result)
signal lifespan_changed(remaining, max_lifespan)
signal character_died(cause)
signal reincarnation_triggered(past_life_data)
