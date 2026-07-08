extends Node

func craft_puppet(frame_id: String, core_id: String,
	weapon_id: String = "", armor_id: String = "",
	function_ids: Array = []) -> Puppet:

	var db = Database.new()
	var frame_data = db.get_puppet_part(frame_id)
	var core_data = db.get_puppet_part(core_id)

	if frame_data.is_empty() or core_data.is_empty():
		return null

	var puppet = Puppet.new()
	puppet.puppet_name = "未命名"

	var avg_quality = floori((frame_data.quality + core_data.quality) / 2.0)
	puppet.quality = avg_quality

	puppet.max_hp = frame_data.get("base_hp", 30) + core_data.get("base_hp", 0)
	puppet.hp = puppet.max_hp
	puppet.attack = core_data.get("base_attack", 0)
	puppet.defense = frame_data.get("base_defense", 0) + core_data.get("base_defense", 0)
	puppet.speed = core_data.get("base_speed", 5)

	puppet.capacity = puppet.quality * 2 + 2
	puppet.intelligence = 1 + puppet.quality
	puppet.hardness = frame_data.get("hardness", 100)
	puppet.durability = puppet.hardness

	if not weapon_id.is_empty():
		var weapon_data = db.get_puppet_part(weapon_id)
		if not weapon_data.is_empty():
			puppet.weapon_module = weapon_data
			puppet.attack += weapon_data.get("attack_bonus", 0)

	if not armor_id.is_empty():
		var armor_data = db.get_puppet_part(armor_id)
		if not armor_data.is_empty():
			puppet.armor_module = armor_data
			puppet.defense += armor_data.get("defense_bonus", 0)

	for func_id in function_ids:
		if puppet.function_modules.size() >= puppet.capacity:
			break
		var func_data = db.get_puppet_part(func_id)
		if not func_data.is_empty():
			puppet.function_modules.append(func_data)

	EventBus.puppet_crafted.emit({"puppet": puppet})
	return puppet
