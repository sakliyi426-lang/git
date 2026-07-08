extends Node

var _cache: Dictionary = {}

func load_json(path: String) -> Dictionary:
	if _cache.has(path):
		return _cache[path]
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var text = file.get_as_text()
	var data = JSON.parse_string(text)
	_cache[path] = data
	return data

func get_puppet_part(part_id: String) -> Dictionary:
	var parts = load_json("res://data/puppet_parts.json")
	return parts.get(part_id, {})
