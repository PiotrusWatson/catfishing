extends ItemOrShrimp
class_name ShrimpType

@export var name: String
@export var images: ShrimpImages
@export var backgrounds: Array[Texture2D]
@export var basic_dialogue: DialogueResource
@export var ending_dialogue: DialogueResource
@export var item_receive_dialogue: DialogueResource
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
	if item == liked_item:
		increment_love()
		increment_love()
		increment_love()
		increment_love()
		return Enums.Mood.HAPPY
	elif item == disliked_item:
		decrement_love()
		decrement_love()
		decrement_love()
		decrement_love()
		return Enums.Mood.SAD
	else:
		increment_love()
		return Enums.Mood.NEUTRAL
		
		

func reset():
	love = starting_love
