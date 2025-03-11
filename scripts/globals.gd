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

func strip_to_alphanumeric(name: String):
	var regex = RegEx.new()
	regex.compile("[^A-Za-z0-9]")
	var result = regex.search(name)
	return result.get_string(0)
	
func save(filename: String):
	filename = strip_to_alphanumeric(filename)
	var save_file = FileAccess.open("user://" + filename + ".save", FileAccess.WRITE)
