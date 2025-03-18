extends Node2D

enum HookIs{OUT, IN, BITTEN}
@onready var fishing_rod = $Pivot/FishingRod
@onready var pivot = $Pivot
@onready var extension_timer = $Timers/ExtensionTimer
@onready var reduction_timer = $Timers/ReductionTimer
@export var rope_tension = 20.0

var is_tense = false
var rotating = false
@export var rotation_speed = 0.5
var hook_status = HookIs.OUT
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Throw"):
		fishing_rod.reset_reel()
		extension_timer.start()
	elif event.is_action_released("Throw"):
		extension_timer.stop()
		
	if event.is_action_pressed("Pull"):
		fishing_rod.reset_reel()
		reduction_timer.start()
	elif event.is_action_released("Pull"):
		reduction_timer.stop()
	#if event.is_action_pressed("Throw") and hook_status == HookIs.OUT:
		#rotating = true	
	if event is InputEventMouseMotion:
		pivot.look_at(get_global_mouse_position())
		
func _physics_process(delta: float) -> void:
	if rotating:
		pivot.rotation = lerp(pivot.rotation, deg_to_rad(-45), rotation_speed)
	
	fishing_rod.update_rope(delta)
	
func _process(delta: float):
	pass

func _on_extension_timer_timeout() -> void:
	fishing_rod.increase_rope()


func _on_reduction_timer_timeout() -> void:
	fishing_rod.decrease_rope()
	
