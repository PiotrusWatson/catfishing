extends Node
class_name Fader

enum WeAre{IDLE, FADING, UNFADING}
@export var fade_speed = 0.5
var thing_to_fade: Control
var starting_colour: Color
var goal_colour: Color
var fading_status: WeAre


func init(thing: Control):
	thing_to_fade = thing
	starting_colour = thing_to_fade.modulate
	goal_colour = Color.TRANSPARENT
	fading_status = WeAre.IDLE
	
func _process(delta: float) -> void:
	match fading_status:
		WeAre.IDLE:
			pass
		WeAre.FADING:
			thing_to_fade.modulate = lerp(thing_to_fade.modulate, goal_colour, fade_speed)
			if thing_to_fade.modulate.is_equal_approx(goal_colour):
				fading_status = WeAre.IDLE
		WeAre.UNFADING:
			thing_to_fade.modulate = lerp(thing_to_fade.modulate, starting_colour, fade_speed)
			if thing_to_fade.modulate.is_equal_approx(starting_colour):
				fading_status = WeAre.IDLE

func start_fading():
	if fading_status == WeAre.IDLE:
		fading_status = WeAre.FADING

func start_unfading():
	if fading_status == WeAre.IDLE:
		fading_status = WeAre.UNFADING
