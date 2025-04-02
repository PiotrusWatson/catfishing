extends StaticBody2D

@export var string_strength = 10
@export var starting_size = 30
@export var max_size = 300
@export var rope_amount = 10
@export var starting_reel = 5
@export var acceleration = 3
@export var hook_speed = 50
var reel_amount
@onready var rope = $Rope
@onready var hoke = $FishHoke
@onready var rope_interaction = $RopeInteraction
@onready var pin_point = $PinPoint

signal hooked_shrimp()
signal caught_shrimp(shrimp: ItemOrShrimp)
signal changed_fishing_status(is_fishing: bool)

func _ready():
	reel_amount = starting_reel
	
func set_rope(amount):
	rope.rope_length = amount

func increase_rope():
	if rope.rope_length < max_size:
		rope.rope_length += reel_amount
		reel_amount += acceleration
		
func decrease_rope():
	if rope.rope_length > 1:
		rope.rope_length -= reel_amount
		reel_amount += acceleration

func reset_reel():
	reel_amount = starting_reel
	
func reset_rope():
	reset_reel()
	rope.rope_length = starting_size

func launch_hook(target: Vector2, force: float):
	hoke.push_hook(target, force)
	
func push_hook_at_force(point: Vector2, force: float):
	var direction = (point - pin_point.global_position).normalized()
	pin_point.velocity = direction * force
	pin_point.move_and_slide()
	
func push_hook_with_gravity(point: Vector2, force: float):
	push_hook_at_force(point, force)
	push_hook_at_force(Vector2.DOWN, force)
func push_hook(point: Vector2):
	push_hook_at_force(point, hook_speed)

func _on_fish_hoke_hooked_shrimp() -> void:
	hooked_shrimp.emit()


func _on_fish_hoke_caught_shrimp(shrimp: ItemOrShrimp) -> void:
	caught_shrimp.emit(shrimp)


func _on_fish_hoke_changed_fishing_status(is_fishing: bool) -> void:
	changed_fishing_status.emit(is_fishing)
