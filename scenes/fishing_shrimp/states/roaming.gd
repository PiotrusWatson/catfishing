extends ShrimpState
class_name Roaming

@onready var bored_timer = $BoredTimer
func enter(previous_state_path: String, data:= {}) -> void:
	bored_timer.start()
	
func exit():
	bored_timer.stop()
	


func _on_bored_timer_timeout() -> void:
	pass
