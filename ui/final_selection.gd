extends Control

@export var debug_shrimps: Array[ShrimpType]
@export var love_threshold = 0
@export var slot_scene: PackedScene
@export var is_debug = false
@onready var character_box = $Panel/Characters

func _ready():
	if is_debug:
		show_shrimps(debug_shrimps)
	else:
		toggle_selection(false)

func toggle_selection(is_active: bool):
	visible = is_active
	if is_active:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		
func show_shrimps(shrimps: Array[ShrimpType]):
	for shrimp in shrimps:
		if shrimp.love > love_threshold:
			print("started")
			var slot = slot_scene.instantiate()
			character_box.add_child(slot)
			slot.fill_deets(shrimp)
			print(shrimp)
			
	toggle_selection(true)
	


func _on_go_alone_pressed() -> void:
	pass # Replace with function body.
