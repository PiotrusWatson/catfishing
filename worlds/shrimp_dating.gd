extends Control


@onready var shrimp_image = $Shrimp
@onready var background = $Background
@onready var emotes = $Shrimp/Emotes
@export var dialogue_box_prefab: PackedScene
@export var generic_item_ask_dialogue: DialogueResource
@export var something_for_me_dialogue: DialogueResource
@export var debug_shrimp: ShrimpType
@onready var end_dialogue = preload("res://dialogues/end_dialogue.dialogue")

var shrimp_data: ShrimpType
var shrimp_dialogue: DialogueResource
var spawned_box: Node
var state = Enums.DatingState.ITEM_CHECK
var check_state_at_end = false

func _ready():
	if Globals.current_shrimp == null:
		Globals.current_shrimp = debug_shrimp
	shrimp_data = Globals.current_shrimp
	shrimp_image.texture = shrimp_data.images.basic
	shrimp_dialogue = shrimp_data.basic_dialogue
	background.texture = shrimp_data.backgrounds[0]
	make_box()
	
func handle_start_dialogue():
	spawned_box.set_theme(shrimp_data.basic_theme)
	match state:
		Enums.DatingState.CHARACTER:
			DialogueManager.show_dialogue_balloon_scene(spawned_box, shrimp_dialogue)
			state = Enums.DatingState.END
		Enums.DatingState.END:
			DialogueManager.show_dialogue_balloon_scene(spawned_box, end_dialogue)
			state = Enums.DatingState.NONE
		Enums.DatingState.ITEM_CHECK:
			if len(Inventory.items) > 0:
				DialogueManager.show_dialogue_balloon_scene(spawned_box, generic_item_ask_dialogue)
				check_state_at_end = true
			else:
				state = Enums.DatingState.CHARACTER
				handle_end_dialogue("junk")
		Enums.DatingState.ITEM_GIVE:
			Inventory.toggle_show_inventory(true)
			DialogueManager.show_dialogue_balloon_scene(spawned_box, something_for_me_dialogue)
			check_state_at_end = true
		Enums.DatingState.ITEM_RECEIVE:
			DialogueManager.show_dialogue_balloon_scene(spawned_box, shrimp_data.item_receive_dialogue)
			state = Enums.DatingState.END
		_:
			SceneChanger.change_scene(SceneChanger.Worlds.PHYSICS_FISHING)
		
func handle_end_dialogue(resource):
	if check_state_at_end:
		state = Globals.temp_dating_state
		check_state_at_end = false
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
		if tag == "angry":
			shrimp_image.texture = shrimp_data.images.angry
		elif tag == "nervous":
			shrimp_image.texture = shrimp_data.images.nervous
		elif tag == "sparkle":
			shrimp_image.texture = shrimp_data.images.sparkle
		elif tag == "love":
			shrimp_image.texture = shrimp_data.images.love
		elif tag == "sad":
			shrimp_image.texture = shrimp_data.images.sad
		elif tag == "normal":
			shrimp_image.texture = shrimp_data.images.basic
		elif tag.begins_with("background"):
			var index = int(tag.split("=")[1])
			background.texture = shrimp_data.backgrounds[index]
			
			
