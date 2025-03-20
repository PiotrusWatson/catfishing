extends RigidBody2D

enum ShimpIs{ROAMING, CHASING, ON_HOOK, CAUGHT}

@onready var sprite = $Sprite2D
var shimp_status = ShimpIs.ROAMING
@export var contained_shrimp: ShrimpType
@export var speed = 40.0
var target_direction: Vector2
var target: Node2D
var will_stop = false
func _ready():
	pick_direction()
	
func pick_direction():
	target_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	rotation = target_direction.angle()
	will_stop = true

func get_direction_to_target():
	return (target.global_position - global_position).normalized()
func _physics_process(delta: float) -> void:
	if shimp_status == ShimpIs.ROAMING:
		apply_central_force(speed * target_direction* delta)
	elif shimp_status == ShimpIs.CHASING:
		var direction = get_direction_to_target()
		add_constant_central_force(speed * direction * delta)
	elif shimp_status == ShimpIs.ON_HOOK:
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
	


func set_shrimp(shrimp: ShrimpType):
	contained_shrimp = shrimp

func _on_bored_timer_timeout() -> void:
	if shimp_status == ShimpIs.ROAMING:
		pick_direction()


func _on_wall_detector_body_entered(body: Node2D) -> void:
	if shimp_status == ShimpIs.CHASING and body.is_in_group("Hook"):
		body.catch_shrimp(self)
		shimp_status = ShimpIs.ON_HOOK
		return
	
	if shimp_status == ShimpIs.ROAMING:
		pick_direction()


func _on_shimp_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hook") and shimp_status == ShimpIs.ROAMING:
		target = body
		shimp_status = ShimpIs.CHASING
		pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if will_stop:
		linear_velocity = Vector2.ZERO
		will_stop = false
