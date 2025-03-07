extends Control

@onready var shrimp_image = $Shrimp
@export var dialogue_box_prefab: PackedScene
var shrimp_data: ShrimpType
var shrimp_dialogue: DialogueResource
var spawned_box: Node
func _ready():
	shrimp_data = Globals.current_shrimp
	shrimp_image = shrimp_data.basic_image
	shrimp_dialogue = shrimp_data.basic_dialogue
	spawned_box = dialogue_box_prefab.instantiate()
	spawned_box.ready.connect(start_dialogue)
	add_child(spawned_box)
	
func start_dialogue():
	spawned_box.set_theme(shrimp_data.basic_theme)
	DialogueManager.show_dialogue_balloon_scene(spawned_box, shrimp_dialogue)
