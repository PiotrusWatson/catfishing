extends Area2D

var held_shrimp: PackedScene

func _on_despawn_timer_timeout() -> void:
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("catch_shrimp"):
		body.catch_shrimp(held_shrimp)

func set_shrimp(shrimp):
	held_shrimp = shrimp
