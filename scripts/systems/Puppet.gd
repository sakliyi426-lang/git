class_name Puppet
extends Resource

@export var puppet_name: String = "未命名傀儡"
@export var quality: int = 0

@export var hp: int = 50
@export var max_hp: int = 50
@export var mp: int = 20
@export var max_mp: int = 20
@export var attack: int = 5
@export var defense: int = 5
@export var speed: int = 8

@export var capacity: int = 2
@export var intelligence: int = 1
@export var hardness: int = 100
@export var durability: int = 100

@export var weapon_module: Dictionary = {}
@export var armor_module: Dictionary = {}
@export var function_modules: Array = []

@export var dispatch_status: Dictionary = {
	"is_dispatched": false,
	"target_region": "",
	"remaining_time": 0,
	"mission_type": ""
}

@export var ai_mode: String = "balanced"

@export var auto_craft: Dictionary = {
	"enabled": false,
	"type": "",
	"recipe_id": "",
	"queue": []
}

func calculate_repair_cost() -> Dictionary:
	var missing = hardness - durability
	return {
		"spirit_stones": missing * 2,
		"materials": missing / 10
	}

func get_quality_label() -> String:
	match quality:
		0:
			return "凡品"
		1:
			return "黄品"
		2:
			return "玄品"
		3:
			return "地品"
		4:
			return "天品"
		5:
			return "仙品"
		_:
			return "未知"
