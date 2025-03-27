extends Control

@export var bad_end_scene: DialogueResource
@export var dialogue_box_prefab: PackedScene
var spawned_box

func _ready():
	make_box()
func handle_start_dialogue():
	match Globals.end_status:
		Enums.EndStatus.ALONE:
			pass
		Enums.EndStatus.PICKED:
			pass
		_:
			pass
func make_box():		
	spawned_box = dialogue_box_prefab.instantiate()
	spawned_box.ready.connect(handle_start_dialogue)
	add_child(spawned_box)
