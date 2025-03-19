extends Area2D

@export var thing_to_spawn: PackedScene
@export var shrimp_to_choose: Array[ShrimpType]
@onready var shape = $Shape

func _ready():
	if not Globals.first_time:
		return
	for shrimp in shrimp_to_choose:
		shrimp.reset()
	Globals.first_time = false
	
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
	var chosen_shrimp = choose_shrimp()
	spawned_thing.set_shrimp(chosen_shrimp)
	spawned_thing.position = get_point_in_bounds()
	return spawned_thing
	
func choose_shrimp():
	return shrimp_to_choose.pick_random()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("toggle_fishing"):
		body.toggle_fishing(true)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("toggle_fishing"):
		body.toggle_fishing(false)
