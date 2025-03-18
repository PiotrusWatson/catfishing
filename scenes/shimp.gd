extends CharacterBody2D

enum ShimpIs{ROAMING, CHASING, ON_HOOK, CAUGHT}

var shimp_status = ShimpIs.ROAMING
var contained_shrimp: ShrimpType
@export var speed = 40.0
var target_direction: Vector2

func _ready():
	pick_direction()
	
func pick_direction():
	target_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
func _physics_process(delta: float) -> void:
	if shimp_status == ShimpIs.ROAMING:
		velocity = speed * target_direction
	
	move_and_slide()


func _on_bored_timer_timeout() -> void:
	pick_direction()
