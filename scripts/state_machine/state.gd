class_name State extends Node

signal finished(next_state_path: String, data: Dictionary)

func handle_input(_event: InputEvent) -> void:
	pass
	
func process(_delta: float) -> void:
	pass
	
func physics_process(_delta: float) -> void:
	pass
	
func enter(previous_state_path: String, data := {}) -> void:
	pass
	
func exit() -> void:
	pass
