extends Node

func start_auto_alchemy(puppet: Puppet, recipe_id: String, materials: Dictionary, count: int = -1):
	puppet.auto_craft.enabled = true
	puppet.auto_craft.type = "alchemy"
	puppet.auto_craft.recipe_id = recipe_id
	puppet.auto_craft.queue = []

	for i in range(count if count > 0 else 999):
		puppet.auto_craft.queue.append(recipe_id)

	_process_craft_queue(puppet, materials)

func _process_craft_queue(puppet: Puppet, materials: Dictionary):
	if not puppet.auto_craft.enabled or puppet.auto_craft.queue.is_empty():
		return

	var recipe_id = puppet.auto_craft.queue.pop_front()

	if not _has_materials(materials, recipe_id):
		puppet.auto_craft.enabled = false
		return

	_consume_materials(materials, recipe_id)

	var quality_bonus = clampf(puppet.intelligence * 0.1, 0, 0.5)
	var result = {
		"recipe": recipe_id,
		"quality_bonus": quality_bonus,
		"success": true
	}

	_process_craft_queue(puppet, materials)

func auto_farming(puppet: Puppet, farm_fields: Array):
	for field in farm_fields:
		field["status"] = "growing"
		field["growth_bonus"] = puppet.intelligence * 0.1

func has_farming_duty(puppet: Puppet) -> bool:
	for mod in puppet.function_modules:
		if mod.get("type") == "farming":
			return true
	return false

func _has_materials(materials: Dictionary, recipe_id: String) -> bool:
	return true

func _consume_materials(materials: Dictionary, recipe_id: String):
	pass
