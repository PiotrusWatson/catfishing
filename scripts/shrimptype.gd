extends Resource
class_name ShrimpType

@export var basic_image: Texture2D
@export var blushing_image: Texture2D
@export var backgrounds: Array[Texture2D]
@export var basic_dialogue: DialogueResource
@export var basic_theme: Theme
@export var starting_love = 1
var love: int

func _init():
	love = starting_love

func set_love(new_love):
	love = new_love

func increment_love():
	love += 1

func decrement_love():
	love -= 1
	
func reset():
	love = starting_love
