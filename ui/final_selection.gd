extends Control

@export var debug_shrimps: Array[ShrimpType]
@export var love_threshold = 0
@export var slot_scene: PackedScene
@export var is_debug = false
@onready var character_box = $Panel/ScrollContainer/Characters
@onready var question_box = $TheQuestion
var candidate_shrimp: ShrimpType
func _ready():
	if is_debug:
		show_shrimps(debug_shrimps)
	else:
		toggle_selection(false)
	toggle_question(false)
func toggle_selection(is_active: bool):
	visible = is_active
	if is_active:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		
func toggle_question(is_active: bool):
	question_box.visible = is_active
	if is_active:
		question_box.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		question_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
func show_shrimps(shrimps: Array[ShrimpType]):
	for shrimp in shrimps:
		if shrimp.love > love_threshold:
			var slot = slot_scene.instantiate()
			character_box.add_child(slot)
			slot.fill_deets(shrimp)
			slot.picked_shrimp.connect(date_shrimp)
			
	toggle_selection(true)
	
func date_shrimp(shrimp: ShrimpType):
	candidate_shrimp = shrimp
	toggle_question(true)

func _on_go_alone_pressed() -> void:
	date_shrimp(null)
	GlobalMusicPlayer.play_click()


func _on_yes_pressed() -> void:
	GlobalMusicPlayer.play_click()
	if candidate_shrimp == null:
		Globals.end_status = Enums.EndStatus.ALONE
	else:
		Globals.end_status = Enums.EndStatus.PICKED
	Globals.current_shrimp = candidate_shrimp
	SceneChanger.change_scene(SceneChanger.Worlds.END_SCENE)


func _on_no_pressed() -> void:
	GlobalMusicPlayer.play_click()
	toggle_question(false)
