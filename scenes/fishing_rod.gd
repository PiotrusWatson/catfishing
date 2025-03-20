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

signal hooked_shrimp()
signal caught_shrimp(shrimp: ShrimpType)
signal changed_fishing_status(is_fishing: bool)

func _ready():
	reel_amount = starting_reel

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
	
func push_hook(point: Vector2):
	pass

func _on_fish_hoke_hooked_shrimp() -> void:
	hooked_shrimp.emit()


func _on_fish_hoke_caught_shrimp(shrimp: ShrimpType) -> void:
	caught_shrimp.emit(shrimp)


func _on_fish_hoke_changed_fishing_status(is_fishing: bool) -> void:
	changed_fishing_status.emit(is_fishing)
