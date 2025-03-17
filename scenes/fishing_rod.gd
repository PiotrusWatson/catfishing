extends StaticBody2D

@onready var rope_container = $VerletRopeContainer
@export var string_strength = 10
@export var starting_size = 30
@export var max_size = 300
@export var rope_amount = 10
var hook: RigidBody2D

func _ready():
	rope_container.init(starting_size, max_size)
	rope_container.set_start(rope_container.global_position)
	rope_container.set_last(rope_container.global_position + Vector2(0, -starting_size))
	#hook = rope_container.hook
	
	
func push_hook(strength):
	var direction = rope_container.get_rope_direction()
	hook.apply_central_force(direction * strength)
	
func extend():
	rope_container.make_bigger()
	

func reel():
	rope_container.make_smaller()

func update_rope(delta):
	rope_container.set_start(rope_container.global_position)
	rope_container.update_line(delta)
