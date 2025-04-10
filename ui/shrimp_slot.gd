extends PanelContainer

@onready var image = $ShrimpDeets/Image
@onready var name_text = $ShrimpDeets/Name
@onready var menu = $Menu
var shrimp_info: ShrimpType

func _ready() -> void:
	toggle_menu(false)
	
func fill_deets(shrimp: ShrimpType):
	shrimp_info = shrimp
	image.texture = shrimp.images.basic
	name_text.text = shrimp.name

func toggle_menu(is_active):
	menu.visible = is_active
	if is_active:
		menu.mouse_filter = MouseFilter.MOUSE_FILTER_STOP
	else:
		menu.mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		toggle_menu(true)


func _on_no_pressed() -> void:
	GlobalMusicPlayer.play_click()
	toggle_menu(false)


func _on_yes_pressed() -> void:
	GlobalMusicPlayer.play_click()
	Globals.current_shrimp = shrimp_info
	Globals.end_status = Enums.EndStatus.PICKED
	SceneChanger.change_scene(SceneChanger.Worlds.END_SCENE)
