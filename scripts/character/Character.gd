class_name Character
extends Resource

@export var name: String = "散修"
@export var realm: int = 0
@export var realm_level: int = 1

@export var spiritual_roots: Dictionary = {}

@export var attributes: Dictionary = {
	"hp": 100, "max_hp": 100,
	"mp": 50, "max_mp": 50,
	"attack": 10, "defense": 5,
	"speed": 10, "dodge": 5,
	"comprehension": 10,
	"luck": 10,
	"spirit": 20,
}

@export var lifespan: int = 200
@export var max_lifespan: int = 200

@export var profession_skills: Dictionary = {}

@export var dao_progress: Dictionary = {}

@export var puppets: Array = []

@export var past_life_data: Dictionary = {}

func init_default():
	pass

func consume_lifespan(years: int) -> bool:
	lifespan -= years
	EventBus.lifespan_changed.emit(lifespan, max_lifespan)
	if lifespan <= 0:
		EventBus.character_died.emit("lifespan")
		return false
	return true
