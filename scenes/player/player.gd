extends Node2D


enum PlayerIs{IDLE, CASTING, FISHING, HOOKING, CATCHING}
@onready var fishing_rod = $Pivot/FishingRod
@onready var pivot = $Pivot
@onready var extension_timer = $Timers/ExtensionTimer
@onready var reduction_timer = $Timers/ReductionTimer
@onready var change_state_timer = $Timers/ChangeStateTimer
@onready var target = $GravityPoint
@onready var gravity_spawn_point = $GravitySpawnPoint
@export var rotation_speed = 0.5
@export var desired_force = 5000
@export var rope_float_divisor = 5
var hook: RigidBody2D
var force

signal hooked_shrimp
signal caught_shrimp(shrimp: ItemOrShrimp)
signal reduced_fish_counter(counter: int)
signal game_ended
var is_fishing = false
var player_status = PlayerIs.IDLE
var distance_to_target: float

var first_time: bool
var moving_target = false



func set_target(target_position: Vector2):
	target.freeze = false
	PhysicsServer2D.body_set_state(
	target.get_rid(),
	PhysicsServer2D.BODY_STATE_TRANSFORM,
	Transform2D.IDENTITY.translated(target_position)
	)
	distance_to_target = target_position.distance_to(global_position)
	force = desired_force * distance_to_target
	moving_target = true
	
	
func stop_target():
	target.freeze = true
	

func _ready():
	hook = fishing_rod.hoke
	player_status = PlayerIs.IDLE
	stop_target()
	first_time = true


func _unhandled_input(event: InputEvent) -> void:
	match player_status:
		PlayerIs.FISHING:
			handle_fishing_input(event)
		PlayerIs.IDLE:
			handle_not_fishing_input(event)

		
func handle_not_fishing_input(event: InputEvent):
	if event is InputEventMouseMotion:
		#pivot.look_at(get_global_mouse_position())
		pass
	if event.is_action_released("Throw"):
		fishing_rod.reset_reel()
		extension_timer.start()
		set_target(get_target_from_mouse())
		var rope_amount = force / rope_float_divisor
		#fishing_rod.set_rope(distance_to_target)
		player_status = PlayerIs.CASTING
		
	
func handle_fishing_input(event: InputEvent):
	if event is InputEventMouseMotion:
		fishing_rod.push_hook(get_global_mouse_position())
	
	if event.is_action_pressed("Throw"):
		fishing_rod.reset_reel()
		extension_timer.start()
	elif event.is_action_released("Throw"):
		extension_timer.stop()
		fishing_rod.reset_reel()
		
	if event.is_action_pressed("Pull"):
		fishing_rod.reset_reel()
		reduction_timer.start()
	elif event.is_action_released("Pull"):
		reduction_timer.stop()
		fishing_rod.reset_reel()
		
func _physics_process(delta: float) -> void:
	if player_status == PlayerIs.FISHING:
		fishing_rod.push_hook(get_global_mouse_position())
	elif player_status == PlayerIs.CASTING:
		fishing_rod.push_hook_at_force(target.global_position, force)

func _on_extension_timer_timeout() -> void:
	fishing_rod.increase_rope()


func _on_reduction_timer_timeout() -> void:
	fishing_rod.decrease_rope()
	

func _on_fishing_rod_hooked_shrimp() -> void:
	hooked_shrimp.emit()


func _on_fishing_rod_caught_shrimp(shrimp: ItemOrShrimp) -> void:
	Globals.number_of_successful_fishes -=1
	caught_shrimp.emit(shrimp)


func _on_fishing_rod_changed_fishing_status(is_fishing: bool) -> void:
	if is_fishing:
		extension_timer.stop()
		stop_target()
		player_status = PlayerIs.FISHING
		fishing_rod.reset_reel()
	else:
		player_status = PlayerIs.IDLE
		reduction_timer.stop()
		
func get_target_from_mouse():
	var mouse_position = get_global_mouse_position()
	return Vector2(mouse_position.x, gravity_spawn_point.global_position.y)

	
