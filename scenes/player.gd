extends Node2D

@onready var fishing_rod = $Pivot/FishingRod
@onready var pivot = $Pivot
@onready var extension_timer = $Timers/ExtensionTimer
@onready var reduction_timer = $Timers/ReductionTimer
@export var rotation_speed = 0.5
var hook: RigidBody2D

signal hooked_shrimp
signal caught_shrimp(shrimp: ShrimpType)
var is_fishing = false


func _ready():
	hook = fishing_rod.hoke

func handle_not_fishing_input(event: InputEvent):
	if event is InputEventMouseMotion:
		pivot.look_at(get_global_mouse_position())

func handle_fishing_input(event: InputEvent):
	if event is InputEventMouseMotion:
		fishing_rod.push_hook(get_global_mouse_position())
	

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
	
	if !is_fishing:
		handle_not_fishing_input(event)

func _physics_process(delta: float) -> void:
	if is_fishing:
		fishing_rod.push_hook(get_global_mouse_position())

func _on_extension_timer_timeout() -> void:
	fishing_rod.increase_rope()


func _on_reduction_timer_timeout() -> void:
	fishing_rod.decrease_rope()
	


func _on_fishing_rod_hooked_shrimp() -> void:
	hooked_shrimp.emit()


func _on_fishing_rod_caught_shrimp(shrimp: ShrimpType) -> void:
	caught_shrimp.emit(shrimp)


func _on_fishing_rod_changed_fishing_status(is_fishing: bool) -> void:
	self.is_fishing = is_fishing
