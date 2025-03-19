extends RigidBody2D

signal hooked_shrimp
signal hook_moved(amount)

@onready var hook = $Hook

func catch_shrimp(shrimp: CharacterBody2D):
	hook.node_b = shrimp
