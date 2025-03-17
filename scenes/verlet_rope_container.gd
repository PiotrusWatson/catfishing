extends Marker2D

var rope_length = 30
var max_size: int
@export var constrain = 1
@export var gravity = Vector2(0, 9.8)
@export var dampening = 0.9

@onready var line = $VisibleRope

var positions: PackedVector2Array
var previous_positions: PackedVector2Array
var point_count : int

func init(rope_length, max_size):
	self.rope_length = rope_length
	self.max_size = max_size
	point_count = get_point_count(rope_length)
	resize_arrays()
	init_positions()

func get_point_count(distance: float) -> int:
	return int(ceil(distance / constrain))
	
func resize_arrays():
	positions.resize(point_count)
	previous_positions.resize(point_count)
	
func init_positions() -> void:
	for i in range(point_count):
		positions[i] = global_position + Vector2(constrain * i, 0)
		previous_positions[i] = global_position + Vector2(constrain * i, 0)
	#position = Vector2.ZERO
	
func set_start(point: Vector2):
	positions[0] = point
	previous_positions[0] = point

func set_last(point: Vector2):
	positions[point_count - 1] = point
	previous_positions[point_count - 1] = point

func update_line(delta):
	update_points(delta)
	update_constraints()
	line.points = positions

func update_points(delta):
	for i in range(point_count):
		if (i == 0):
			continue
		var velocity = (positions[i] - previous_positions[i]) * dampening
		previous_positions[i] = positions[i]
		positions[i] += velocity + (gravity * delta)
		


func update_constraints() -> void:
	for i in range(point_count):
		if i == point_count -1:
			return
			
		var distance = positions[i].distance_to(positions[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var direction = positions[i+1] - positions[i]
		if i == 0:
			positions[i+1] += direction * percent
		elif i == point_count - 1:
			pass
		else:
			positions[i] -= direction * (percent/2)
			positions[i + 1] += direction * (percent/2)
