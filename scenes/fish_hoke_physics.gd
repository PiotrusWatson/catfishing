extends RigidBody2D

signal hooked_shrimp
signal hook_moved(amount)
@export var strength = 3.0

@onready var hook = $Hook

func catch_shrimp(shrimp: CharacterBody2D):
	hook.node_b = shrimp

func push_hook(target: Vector2):
	var direction = (target - global_position).normalized()
	apply_central_force(direction * strength)
	
