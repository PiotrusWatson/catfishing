extends StaticBody2D

@export var string_strength = 10
@export var starting_size = 30
@export var max_size = 300
@export var rope_amount = 10
@onready var rope = $Rope
var hook: RigidBody2D

func _ready():
	pass

func increase_rope():
	if rope.rope_length < max_size:
		rope.rope_length += 5
		print(rope.rope_length)
func decrease_rope():
	if rope.rope_length > 1:
		rope.rope_length -= 5


func update_rope(delta):
	pass
