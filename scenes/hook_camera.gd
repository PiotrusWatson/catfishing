extends Camera2D

@export var follow_target: Node2D
@export var speed = 0.5
@onready var dead_zone = $DeadZone
var original_position: Vector2

func _ready():
	original_position = global_position
	
func _process(delta: float) -> void:
	#if is_in_bounds(follow_target.position):
	global_position.y = lerp(global_position.y, follow_target.global_position.y, speed)

func is_in_bounds(point: Vector2):
	var rect = dead_zone.shape.get_rect()
	var end = rect.end
	var start = rect.position
	return point.y < end.y and point.y > start.y
