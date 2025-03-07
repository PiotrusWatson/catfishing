extends RigidBody2D

signal caught_shrimp(shrimp)

func catch_shrimp(shrimp):
	Globals.current_shrimp = shrimp
	caught_shrimp.emit(shrimp)
	queue_free()
