extends RigidBody2D

signal hooked_shrimp
signal hook_moved(amount)
signal caught_shrimp(shrimp: ItemOrShrimp)
signal changed_fishing_status(is_fishing: bool)
@export var strength = 3.0

@onready var hook = $Hook
var is_hooked = false
var is_fishing = false
var shrimp_info: ItemOrShrimp

func hook_shrimp(shrimp: Node2D):
	shrimp.global_position = hook.global_position
	hook.node_a = shrimp.get_path()
	hooked_shrimp.emit()
	is_hooked = true
	shrimp_info = shrimp.contained_shrimp

func push_hook(target: Vector2):
	var direction = (target - global_position).normalized()
	apply_central_force(direction * strength)
	
func catch_shrimp():
	if is_hooked:
		caught_shrimp.emit(shrimp_info)

func toggle_fishing(fishing):
	is_fishing = fishing		
	changed_fishing_status.emit(is_fishing)
