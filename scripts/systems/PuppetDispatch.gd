extends Node

var dispatched_puppets: Dictionary = {}

func dispatch_puppet(puppet: Puppet, region_id: String, duration: int, mission_type: String) -> bool:
	if puppet.dispatch_status.is_dispatched:
		return false

	var exploration = Exploration.new()
	var region = exploration.get_region(region_id)
	if region.is_empty():
		return false

	puppet.dispatch_status = {
		"is_dispatched": true,
		"target_region": region_id,
		"remaining_time": duration,
		"mission_type": mission_type
	}

	EventBus.puppet_dispatched.emit(puppet, region_id)

	var timer = Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout

	_finish_dispatch(puppet)
	return true

func _finish_dispatch(puppet: Puppet):
	var exploration = Exploration.new()
	var result = exploration.calculate_dispatch_result(
		puppet,
		puppet.dispatch_status.target_region,
		puppet.dispatch_status.remaining_time
	)

	puppet.dispatch_status.is_dispatched = false

	if result.has("damage"):
		puppet.durability -= result.damage
		if puppet.durability <= 0:
			EventBus.puppet_destroyed.emit(puppet)

	EventBus.puppet_returned.emit(puppet, result)

func remote_view(puppet: Puppet, character_spirit: int) -> bool:
	if not puppet.dispatch_status.is_dispatched:
		return false
	if character_spirit < 10:
		return false
	return true
