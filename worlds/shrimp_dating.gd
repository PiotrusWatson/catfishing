extends Control
enum DatingState{NONE, CHARACTER, END}

@onready var shrimp_image = $Shrimp
@export var dialogue_box_prefab: PackedScene
@onready var end_dialogue = preload("res://dialogues/end_dialogue.dialogue")
var shrimp_data: ShrimpType
var shrimp_dialogue: DialogueResource
var spawned_box: Node
var state = DatingState.CHARACTER

func _ready():
	shrimp_data = Globals.current_shrimp
	shrimp_image.texture = shrimp_data.basic_image
	shrimp_dialogue = shrimp_data.basic_dialogue
	make_box()
	
func handle_start_dialogue():
	spawned_box.set_theme(shrimp_data.basic_theme)
	if state == DatingState.CHARACTER:
		DialogueManager.show_dialogue_balloon_scene(spawned_box, shrimp_dialogue)
		state = DatingState.END
	elif state == DatingState.END:
		DialogueManager.show_dialogue_balloon_scene(spawned_box, end_dialogue)
		state = DatingState.NONE
	else:
		get_tree().change_scene_to_file("res://worlds/piotrus_world.tscn")
		
func handle_end_dialogue(resource):
	spawned_box.queue_free()
	make_box()
	
func make_box():
	DialogueManager.dialogue_ended.connect(handle_end_dialogue)
	DialogueManager.got_dialogue.connect(parse_tags)
	spawned_box = dialogue_box_prefab.instantiate()
	spawned_box.ready.connect(handle_start_dialogue)
	add_child(spawned_box)
	
func parse_tags(line):
	for tag in line.tags:
		if tag == "blushing":
			shrimp_image.texture = shrimp_data.blushing_image
		elif tag == "normal":
			shrimp_image.texture = shrimp_data.basic_image
