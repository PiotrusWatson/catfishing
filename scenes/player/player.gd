extends Node2D


enum PlayerIs{IDLE, LEAVING_WATER, THROWING, CASTING, FISHING, HOOKING, CATCHING}
@onready var fishing_rod = $Pivot/FishingRod
@onready var pivot = $Pivot
@onready var extension_timer = $Timers/ExtensionTimer
@onready var reduction_timer = $Timers/ReductionTimer
@onready var cast_timer = $Timers/CastTimer
@onready var force_increaser = $Timers/ForceIncreaser
@onready var leaving_water_timer = $Timers/LeavingWaterTimer
@onready var target: GravityPoint = $GravityPoint
@onready var gravity_spawn_point = $GravitySpawnPoint
@onready var fishing_bar = $UI/FishingBar
@onready var tooltip = $UI/Tooltip
@onready var animator = $AnimationPlayer
@onready var mewler = $Mewler
@onready var reel = $Reel
@onready var plop = $Plop
@onready var slurp = $Slurp

@export var rotation_speed = 0.5
@export var max_force = 5.0
@export var force_step = 0.3
@export var rope_float_divisor = 5
@export var hook_speed = 300
var starting_force = 0.1
var desired_force
var is_reeling = false
var hook: RigidBody2D
var force

signal hooked_shrimp
signal caught_shrimp(shrimp: ItemOrShrimp)
signal reduced_fish_counter(counter: int)
signal game_ended
var is_fishing = false
var player_status = PlayerIs.IDLE
var distance_to_target: float
var is_starting = true


func set_target(target_position: Vector2):
	target.freeze = false
	target.politely_command_to_teleport_to(target_position)
	distance_to_target = target_position.distance_to(global_position)
	force = desired_force * distance_to_target


func stop_target():
	target.freeze = true

func reset_force():
	desired_force = starting_force
	force_increaser.stop()
	fishing_bar.update(desired_force)

func _ready():
	if Globals.has_been_on_a_date:
		tooltip.visible = false
	hook = fishing_rod.hoke
	player_status = PlayerIs.IDLE
	reset_force()
	stop_target()
	fishing_bar.init(max_force, force_step, starting_force)
	animator.play("default")


func _unhandled_input(event: InputEvent) -> void:
	if is_starting:
		return
	match player_status:
		PlayerIs.FISHING:
			handle_fishing_input(event)
		PlayerIs.IDLE:
			handle_not_fishing_input(event)


func handle_not_fishing_input(event: InputEvent):
	if event is InputEventMouseMotion:
		#pivot.look_at(get_global_mouse_position())
		pass
	if event.is_action_pressed("Throw"):
		force_increaser.start()
		animator.play("start_fish")
	if event.is_action_released("Throw"):
		force_increaser.stop()
		fishing_rod.reset_reel()
		extension_timer.start()
		reel.play()
		player_status = PlayerIs.THROWING
		animator.play("fish")
		mewler.mewl()
	
func handle_fishing_input(event: InputEvent):
	if event is InputEventMouseMotion:
		fishing_rod.push_hook(get_global_mouse_position())
	
	if event.is_action_pressed("Throw"):
		fishing_rod.reset_reel()
		extension_timer.start()
		reel.play()
	elif event.is_action_released("Throw"):
		extension_timer.stop()
		fishing_rod.reset_reel()
		reel.stop()
		
	if event.is_action_pressed("Pull"):
		reel.play()
		fishing_rod.reset_reel()
		reduction_timer.start()
		is_reeling = true
	elif event.is_action_released("Pull"):
		reel.stop()
		reduction_timer.stop()
		fishing_rod.reset_reel()
		is_reeling = false
		
func _physics_process(delta: float) -> void:
	match player_status:
		PlayerIs.THROWING:
			_update_rope_amount_on_throw()
		PlayerIs.FISHING:
			fishing_rod.push_hook_with_gravity(get_global_mouse_position(), hook_speed)
			if is_reeling:
				fishing_rod.push_hook(global_position)
		PlayerIs.CASTING:
			fishing_rod.push_hook_at_force(target.global_position, force)
		PlayerIs.LEAVING_WATER:
			fishing_rod.push_hook_with_gravity(global_position, hook_speed)

func _update_rope_amount_on_throw():
	set_target(get_target_from_mouse())
	var rope_amount = force / rope_float_divisor
	fishing_rod.set_rope(rope_amount)
	player_status = PlayerIs.CASTING
	cast_timer.start()

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
	if player_status == PlayerIs.CASTING:
		return
	if is_fishing:
		player_status = PlayerIs.FISHING
	else:
		player_status = PlayerIs.LEAVING_WATER
		leaving_water_timer.start()
		is_reeling = false
		
		
func get_target_from_mouse():
	var mouse_position = get_global_mouse_position()
	return Vector2(mouse_position.x, gravity_spawn_point.global_position.y)

	


func _on_cast_timer_timeout() -> void:
	extension_timer.stop()
	reel.stop()
	plop.play()
	stop_target.call_deferred()
	player_status = PlayerIs.FISHING
	fishing_rod.reset_reel()
	reset_force()
	tooltip.fade_out()


func _on_force_increaser_timeout() -> void:
	if desired_force < max_force:
		desired_force += 0.3
		fishing_bar.update(desired_force)


func _on_leaving_water_timer_timeout() -> void:
	reduction_timer.stop()
	reel.stop()
	slurp.play()
	fishing_rod.reset_rope()
	player_status = PlayerIs.IDLE
	tooltip.fade_in()
	animator.play("default")


func _on_start_timer_timeout() -> void:
	is_starting = false
