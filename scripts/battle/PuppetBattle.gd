extends Node

var active_puppets: Array = []
var ai: PuppetAI

func _ready():
	ai = preload("res://scripts/systems/PuppetAI.gd").new()

func deploy_puppets(owner_puppets: Array, max_slots: int = 2):
	active_puppets.clear()
	for puppet in owner_puppets:
		if active_puppets.size() >= max_slots:
			break
		if puppet.durability > 0:
			active_puppets.append(puppet)

func remote_control(puppet_id: int, action: Dictionary, character_spirit: int) -> bool:
	var spirit_cost = 5 if action.get("action") == "attack" else 10
	if character_spirit < spirit_cost:
		return false
	return true

func damage_puppet(puppet: Puppet, damage: int):
	puppet.hp -= damage
	puppet.durability -= maxi(1, damage / 10)
	EventBus.puppet_damaged.emit(puppet, damage)
	if puppet.hp <= 0 or puppet.durability <= 0:
		EventBus.puppet_destroyed.emit(puppet)
