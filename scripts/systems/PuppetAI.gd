extends Node

func decide_action(puppet: Puppet, battle_state: Dictionary) -> Dictionary:
	match puppet.ai_mode:
		"aggressive":
			return _aggressive_action(puppet, battle_state)
		"defensive":
			return _defensive_action(puppet, battle_state)
		"support":
			return _support_action(puppet, battle_state)
		_:
			return _balanced_action(puppet, battle_state)

func _balanced_action(puppet: Puppet, state: Dictionary) -> Dictionary:
	if float(puppet.hp) / puppet.max_hp < 0.3:
		return {"action": "defend"}
	if not puppet.weapon_module.is_empty():
		return {"action": "skill", "skill_id": puppet.weapon_module.get("skill_id", "attack")}
	return {"action": "attack"}

func _aggressive_action(puppet: Puppet, state: Dictionary) -> Dictionary:
	if not puppet.weapon_module.is_empty():
		return {"action": "skill", "skill_id": puppet.weapon_module.get("skill_id", "attack")}
	return {"action": "attack"}

func _defensive_action(puppet: Puppet, state: Dictionary) -> Dictionary:
	if not puppet.armor_module.is_empty():
		return {"action": "skill", "skill_id": puppet.armor_module.get("skill_id", "defend")}
	return {"action": "defend"}

func _support_action(puppet: Puppet, state: Dictionary) -> Dictionary:
	for mod in puppet.function_modules:
		if mod.get("skill_id") == "repair_light":
			return {"action": "skill", "skill_id": "repair_light", "target": "owner"}
	return {"action": "defend"}
