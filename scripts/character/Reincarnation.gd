extends Node

func trigger_reincarnation(character: Character):
	var past_life = {
		"name": character.name,
		"memories": _get_memories(character),
		"skill_mastery": _get_skill_mastery(character),
		"dao_progress": character.dao_progress.duplicate(),
		"sealed_treasures": _get_sealed_treasures(character)
	}

	EventBus.reincarnation_triggered.emit(past_life)

	var new_character = Character.new()
	new_character.past_life_data = past_life

	new_character.dao_progress = past_life.dao_progress.duplicate()

	return new_character

func _get_memories(character: Character) -> Array:
	return ["past_life_awakening"]

func _get_skill_mastery(character: Character) -> Dictionary:
	return {}

func _get_sealed_treasures(character: Character) -> Array:
	return []

func seal_treasure(character: Character, items: Array, location: Vector2, formation_level: int) -> bool:
	var seal_data = {
		"items": items,
		"location": location,
		"formation_level": formation_level,
		"concealment": formation_level * 0.2
	}
	if not character.past_life_data.has("sealed"):
		character.past_life_data["sealed"] = []
	character.past_life_data["sealed"].append(seal_data)
	return true

func sense_sealed_treasure(character: Character) -> Array:
	var sensed = []
	if character.past_life_data.is_empty():
		return sensed

	var comprehension = character.attributes.get("comprehension", 10)
	for seal in character.past_life_data.get("sealed", []):
		var perception_chance = clampf(comprehension * 0.01 + seal.get("formation_level", 0) * 0.05, 0, 1)
		if randf() < perception_chance:
			sensed.append(seal)

	return sensed
