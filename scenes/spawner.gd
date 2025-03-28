extends Area2D

@export var thing_to_spawn: PackedScene
@export var max_shrimp = 6
@export var max_items = 5
@onready var left_wall = $Walls/Left
@onready var right_wall = $Walls/Right
@onready var shape = $Shape
@onready var spawn_timer = $SpawnTimer
var spawning_pool: Array[ShrimpType]
var spawned: Array[ShrimpType]
signal pool_exhausted


func init(shrimps: Array[ShrimpType]):
	spawning_pool = shrimps
	spawn_timer.start()
	
func get_non_haters() -> Array[ShrimpType]:
	var not_haters: Array[ShrimpType] = []
	for shrimp in spawning_pool:
		if shrimp.love >= 0:
			not_haters.append(shrimp)
	return not_haters
	
func spawn_shrimp():
	var not_haters: Array[ShrimpType] = get_non_haters()
	if len(not_haters) == 0:
		pool_exhausted.emit()
		return
	var shrimp_to_spawn = pick_shrimp(not_haters)
	if shrimp_to_spawn == null or len(spawned) >= max_shrimp:
		return
	spawn_silhouette(shrimp_to_spawn)

func pick_shrimp(shrimp_pool: Array[ShrimpType]):
	var legal_shrimps = Globals.not_in_second_array(shrimp_pool, spawned)
	if len(legal_shrimps) == 0:
		return null
	return legal_shrimps.pick_random()
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("toggle_fishing"):
		body.toggle_fishing(true)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("toggle_fishing"):
		body.toggle_fishing(false)
		
	if body.is_in_group("Hook"):
		body.catch_shrimp()
	
func pick_point_in_bounds():
	var rect: Rect2 = shape.shape.get_rect()
	var start = rect.position
	var end = rect.end
	var x = randf_range(start.x, end.x)
	var y = randf_range(start.y, end.y)
	return Vector2(x, y)
	
func spawn_silhouette(shrimp: ShrimpType):
	var spawned_thing = thing_to_spawn.instantiate()
	spawned_thing.contained_shrimp = shrimp
	spawned.append(shrimp)
	add_child(spawned_thing)
	spawned_thing.position = pick_point_in_bounds()
	return spawned_thing
	
	


func _on_spawn_timer_timeout() -> void:
	spawn_shrimp()
