extends Node2D

enum HookIs{OUT, IN, BITTEN}
@onready var fishing_rod = $Pivot/FishingRod
@onready var pivot = $Pivot
@onready var extension_timer = $Timers/ExtensionTimer
@export var rope_tension = 20.0

var is_tense = false
var rotating = false
@export var rotation_speed = 0.5
var hook_status = HookIs.OUT
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Throw"):
		extension_timer.start()
	elif event.is_action_released("Throw"):
		extension_timer.stop()
	if event.is_action_pressed("Throw") and hook_status == HookIs.OUT:
		rotating = true	
		
func _physics_process(delta: float) -> void:
	if is_tense:
		fishing_rod.push_hook(rope_tension)
	if rotating:
		pivot.rotation = lerp(pivot.rotation, -PI, rotation_speed)
	
	fishing_rod.update_rope(delta)
	
func _process(delta: float):
	pass

func _on_extension_timer_timeout() -> void:
	#fishing_rod.extend()
	pass
