class_name GravityPoint
extends RigidBody2D

var is_asked_to_teleport: bool = false
var target_position: Vector2 = Vector2.ZERO

func politely_command_to_teleport_to(target_position: Vector2) -> void:
	is_asked_to_teleport = true
	self.target_position = target_position

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if (is_asked_to_teleport):
		state.linear_velocity = Vector2.ZERO
		global_position = target_position

		is_asked_to_teleport = false
		target_position = Vector2.ZERO
