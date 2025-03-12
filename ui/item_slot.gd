extends PanelContainer

var empty_texture: Texture2D
var empty_label = "Empty"
var index: int
var filled = false
@onready var image = $ItemDetails/Image
@onready var label = $ItemDetails/Name
@onready var button_box = $ButtonBox
@onready var give_button = $ButtonBox/Give
signal item_deleted(index: int)

func _ready():
	empty_texture = image.texture
	toggle_button_box(false)
	
func fill_details(item: Item, index: int):
	if item == null:
		image.texture = empty_texture
		label.text = empty_label
		filled = false
		return
	image.texture = item.image
	label.text = item.name
	self.index = index
	filled = true

func remove_details():
	item_deleted.emit(index)
	toggle_button_box(false)
	

func _on_delete_pressed() -> void:
	remove_details()
	
func toggle_button_box(is_show: bool):
	button_box.visible = is_show
	if is_show:
		button_box.mouse_filter = button_box.MOUSE_FILTER_STOP
		button_box.focus_mode = button_box.FOCUS_CLICK
	else:
		button_box.mouse_filter = button_box.MOUSE_FILTER_IGNORE
		focus_mode = Control.FOCUS_CLICK

func toggle_give(is_show: bool):
	give_button.visible = is_show
	give_button.disabled = !is_show

func _on_close_pressed() -> void:
	toggle_button_box(false)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and filled:
		toggle_button_box(true)
