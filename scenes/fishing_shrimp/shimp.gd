extends RigidBody2D

enum ShimpIs{ROAMING, CHASING, ON_HOOK, SCARED, CAUGHT}

@onready var sprite = $SubShimp/Sprite2D
@onready var sub_shrimp = $SubShimp
@onready var vision_cone = $SubShimp/VisionCone2D
@onready var vision_area = $SubShimp/ShimpVision
@onready var flee_timer = $Timers/FleeTimer
var shimp_status = ShimpIs.ROAMING
@export var contained_shrimp: ItemOrShrimp
@export var speed = 40.0
@export var flee_speed = 100.0
var target_direction: Vector2
var target: Node2D
var will_stop = false
var left_wall: float
var right_wall: float
var away_direction: Vector2

signal noticed_hook

func _ready():
	pick_direction()
	
func init(thing: ItemOrShrimp, walls: Walls):
	contained_shrimp = thing
	left_wall = walls.left_wall.global_position.x
	right_wall = walls.right_wall.global_position.x
	
	
func pick_direction():
	var is_left = bool(randi_range(0, 1))
	if is_left:
		target_direction = Vector2(-1, 0)
		sub_shrimp.scale = Vector2(-1, 1)
		vision_cone.scale = Vector2(-1, 1)
		vision_area.scale = Vector2(-1, 1)
		
	else:
		target_direction = Vector2(1, 0)
		sub_shrimp.scale = Vector2(1, 1)
		vision_cone.scale = Vector2(1, 1)
		vision_area.scale = Vector2(1, 1)
	will_stop = true

func reached_wall():
	return global_position.x < left_wall or global_position.x > right_wall
	
func get_direction_to_target():
	return (target.global_position - global_position).normalized()
func _physics_process(delta: float) -> void:
	match shimp_status:
		ShimpIs.ROAMING:
			apply_central_force(speed * target_direction* delta)
		ShimpIs.CHASING:
			var direction = get_direction_to_target()
			sub_shrimp.scale = Vector2(1, 1)
			vision_cone.scale = Vector2(1, 1)
			vision_area.scale = Vector2(1, 1)
			sub_shrimp.rotation = direction.angle()
			apply_central_force(speed * direction * delta)
		ShimpIs.ON_HOOK:
			set_collision_mask_value(3, false)
			set_collision_layer_value(2, false)
		ShimpIs.SCARED:
			away_direction = (target.global_position - global_position).normalized()
			sub_shrimp.rotation = away_direction.angle()
			apply_central_force(flee_speed * away_direction * delta)
		_:
			pass


func set_shrimp(shrimp: ItemOrShrimp):
	contained_shrimp = shrimp

func _on_bored_timer_timeout() -> void:
	if shimp_status == ShimpIs.ROAMING:
		pick_direction()


func _on_wall_detector_body_entered(body: Node2D) -> void:
	if shimp_status == ShimpIs.CHASING and body.is_in_group("Hook") and !body.is_hooked:
		body.hook_shrimp(self)
		shimp_status = ShimpIs.ON_HOOK
		return
	
	if shimp_status == ShimpIs.ROAMING:
		pick_direction()


func _on_shimp_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hook") and shimp_status == ShimpIs.ROAMING and !body.is_hooked:
		target = body
		shimp_status = ShimpIs.CHASING

		noticed_hook.emit()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if will_stop:
		linear_velocity = Vector2.ZERO
		will_stop = false


func _on_shimp_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Hook") and shimp_status == ShimpIs.CHASING:
		flee_timer.start()
		shimp_status = ShimpIs.SCARED


func _on_flee_timer_timeout() -> void:
	if shimp_status == ShimpIs.SCARED:
		shimp_status = ShimpIs.ROAMING
