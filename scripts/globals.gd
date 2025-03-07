extends Node

var first_time = true
var current_shrimp: ShrimpType
var current_love: int


func make_tiny_timer():
	return get_tree().create_timer(0.01)

func set_current_shrimp(new_shrimp):
	current_shrimp = new_shrimp
	current_love = current_shrimp.love

func increment_current_love():
	current_shrimp.increment_love()
	print(current_shrimp.love)

func decrement_current_love():
	current_shrimp.decrement_love()
	print(current_shrimp.love)
