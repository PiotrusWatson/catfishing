extends Node2D

var hook_out = false
var hoke: RigidBody2D
var fish_hook: Node2D
@export var fish_hook_prefab: PackedScene

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		toggle_launch()


func toggle_launch():
	if not hook_out:
		fish_hook = fish_hook_prefab.instantiate()
		add_child(fish_hook)
		fish_hook.caught_shrimp.connect(handle_caught_shrimp)
		fish_hook.global_position = get_global_mouse_position()
		hook_out = true
	else:
		retract_hook()
		
func retract_hook():
	hook_out = false
	fish_hook.queue_free()
func handle_caught_shrimp(shrimp):
	retract_hook()
	SceneChanger.change_scene(SceneChanger.Worlds.PLACEHOLDER_DATING)
	
