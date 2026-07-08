extends Node

var current_character: Resource = null
var game_state: Dictionary = {
	"year": 1,
	"season": "spring",
	"location": "central_plains"
}

func start_new_game():
	var CharacterResource = load("res://scripts/character/Character.gd")
	current_character = CharacterResource.new()
	current_character.init_default()

func get_time_cost(action_type: String) -> int:
	match action_type:
		"cultivation":
			return randi_range(1, 3)
		"exploration":
			return randi_range(1, 2)
		_:
			return 1
