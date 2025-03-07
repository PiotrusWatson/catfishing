extends CollisionShape2D

@export var thing_to_spawn: PackedScene
@export var shrimp_to_choose: Array[PackedScene]

func get_point_in_bounds():
	var rect = shape.get_rect()
	var end = rect.end
	var start = rect.position
	var x_point = randf_range(start.x, end.x)
	var y_point = randf_range(start.y, end.y)
	return Vector2(x_point, y_point)
	
func spawn_thing():
	var spawn_point = get_point_in_bounds()
	var spawned_thing = thing_to_spawn.instantiate()
	add_child(spawned_thing)
	spawned_thing.position = get_point_in_bounds()
	spawned_thing.set_shrimp(choose_shrimp())
	return spawned_thing
	
func choose_shrimp():
	return shrimp_to_choose.pick_random()

func _on_spawn_timer_timeout() -> void:
	spawn_thing()
