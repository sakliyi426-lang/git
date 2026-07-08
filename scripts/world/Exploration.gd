extends Node

var regions: Dictionary = {
	"central_plains": {"name": "九州中央", "danger": 1, "resources": ["herb", "ore"]},
	"north_ice": {"name": "北方冰原", "danger": 4, "resources": ["ore", "core"]},
	"south_forest": {"name": "南方密林", "danger": 3, "resources": ["herb", "wood"]},
	"west_desert": {"name": "西方大漠", "danger": 3, "resources": ["ore", "relic"]},
	"east_sea": {"name": "东方海域", "danger": 4, "resources": ["herb", "core"]},
	"forbidden": {"name": "禁地", "danger": 5, "resources": ["relic", "core"]}
}

func get_region(region_id: String) -> Dictionary:
	return regions.get(region_id, {})

func calculate_dispatch_result(puppet: Puppet, region_id: String, duration: int) -> Dictionary:
	var region = get_region(region_id)
	if region.is_empty():
		return {"success": false, "message": "未知区域"}

	var danger = region.danger
	var puppet_power = puppet.attack + puppet.defense + puppet.hp / 10
	var success_chance = clampf(float(puppet_power) / (danger * 20), 0.1, 0.95)

	var roll = randf()
	if roll < success_chance:
		var loot = _generate_loot(region, duration, puppet.intelligence)
		return {"success": true, "loot": loot}
	elif roll < success_chance + 0.1:
		return {"success": true, "special_discovery": true, "discovery_type": "hidden_entrance"}
	else:
		var damage = randi_range(5, danger * 10)
		return {"success": false, "damage": damage, "message": "遭遇妖兽袭击"}

func _generate_loot(region: Dictionary, duration: int, intelligence: int) -> Array:
	var loot = []
	var base_amount = duration * intelligence
	for resource in region.resources:
		var amount = randi_range(base_amount / 2, base_amount)
		loot.append({"type": resource, "amount": amount})
	return loot
