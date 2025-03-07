extends Control

@onready var shrimp_image = $Shrimp
var shrimp_data: ShrimpType
var shrimp_dialogue: DialogueResource
func _ready():
	shrimp_data = Globals.current_shrimp
	shrimp_image = shrimp_data.basic_image
	shrimp_dialogue = shrimp_data.basic_dialogue
	DialogueManager.show_example_dialogue_balloon(shrimp_dialogue)
