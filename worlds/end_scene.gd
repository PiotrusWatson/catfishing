extends Control

@export var bad_end_scene: DialogueResource
@export var dialogue_box_prefab: PackedScene
var spawned_box

func _ready():
	make_box()
	
func handle_end_dialogue(stuff):
	SceneChanger.change_scene(SceneChanger.Worlds.CREDITS)
func handle_start_dialogue():
	match Globals.end_status:
		Enums.EndStatus.ALONE:
			DialogueManager.show_dialogue_balloon_scene(spawned_box, bad_end_scene)
		Enums.EndStatus.PICKED:
			assert(Globals.current_shrimp != null)
			var end_dialogue = Globals.current_shrimp.ending_dialogue
			DialogueManager.show_dialogue_balloon_scene(spawned_box, end_dialogue)
		_:
			assert(false, "We've reached the end scene illegally :(")
func make_box():	
	DialogueManager.dialogue_ended.connect(handle_end_dialogue)	
	spawned_box = dialogue_box_prefab.instantiate()
	spawned_box.ready.connect(handle_start_dialogue)
	add_child(spawned_box)
