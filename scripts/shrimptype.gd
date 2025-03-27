extends Resource
class_name ShrimpType

@export var name: String
@export var basic_image: Texture2D
@export var backgrounds: Array[Texture2D]
@export var basic_dialogue: DialogueResource
@export var ending_dialogue: DialogueResource
@export var basic_theme: Theme
@export var starting_love = 1
@export var liked_item: Item
@export var disliked_item: Item

signal received_item(mood: Enums.Mood)
var love: int

func _init():
	love = starting_love

func set_love(new_love):
	love = new_love

func increment_love():
	love += 1

func decrement_love():
	love -= 1
	
func give_item(item: Item):
	Globals.set_given_item(item)
	if item == liked_item:
		increment_love()
		increment_love()
		received_item.emit(Enums.Mood.HAPPY)
	elif item == disliked_item:
		decrement_love()
		received_item.emit(Enums.Mood.SAD)
	else:
		increment_love()
		received_item.emit(Enums.Mood.NEUTRAL)
		
		

func reset():
	love = starting_love
