extends RigidBody2D

signal hooked_shrimp
signal hook_moved(amount)
signal caught_shrimp(shrimp: ItemOrShrimp)
signal changed_fishing_status(is_fishing: bool)
@export var strength = 3.0

@onready var hook = $Hook
@onready var plop = $Plop
var is_hooked = false
var is_fishing = false
var shrimp_info: ItemOrShrimp
var current_shrimp: Node2D

func hook_shrimp(shrimp: Node2D):
	shrimp.global_position = hook.global_position
	current_shrimp = shrimp
	hook.node_a = shrimp.get_path()
	hooked_shrimp.emit()
	is_hooked = true
	shrimp_info = shrimp.contained_shrimp

func push_hook(target: Vector2, force: float):
	var direction = (target - global_position).normalized()
	apply_central_force(direction * force)
	
func catch_shrimp():
	if is_hooked:
		caught_shrimp.emit(shrimp_info)
		if shrimp_info is Item and current_shrimp != null:
			is_hooked = false
			current_shrimp.queue_free()

func toggle_fishing(fishing):
	is_fishing = fishing		
	changed_fishing_status.emit(is_fishing)
	if is_fishing:
		plop.play()
	
