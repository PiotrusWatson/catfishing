extends RigidBody2D

signal hooked_shrimp
signal hook_moved(amount)
@export var strength = 3.0

@onready var hook = $Hook

func catch_shrimp(shrimp: Node2D):
	shrimp.global_position = hook.global_position
	hook.node_a = shrimp.get_path()

func push_hook(target: Vector2):
	var direction = (target - global_position).normalized()
	apply_central_force(direction * strength)
	
