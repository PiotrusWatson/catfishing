extends PanelContainer

@onready var image = $ShrimpDeets/Image
@onready var name_text = $ShrimpDeets/Name
@onready var menu = $Menu
var shrimp_info: ShrimpType

func _ready() -> void:
	toggle_menu(false)
	
func fill_deets(shrimp: ShrimpType):
	shrimp_info = shrimp
	image.texture = shrimp.basic_image
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
		print("woa its oipen")


func _on_no_pressed() -> void:
	toggle_menu(false)
