extends CanvasLayer

@onready var image = $ItemBox/Image
@onready var get_text = $ItemBox/YouGot
@onready var item_box = $ItemBox
func _ready():
	visible = false

func show_get(item: Item):
	image.texture = item.image
	get_text.text = "You got the " + item.name
	visible = true
	item_box.focus_mode = Control.FocusMode.FOCUS_ALL

func show_give(item: Item):
	image.texture = item.image
	get_text.text = "Gave away your " + item.name
	visible = true
	item_box.focus_mode = Control.FocusMode.FOCUS_ALL

func _on_item_box_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and item_box.focus_mode != Control.FocusMode.FOCUS_NONE:
		item_box.focus_mode = Control.FocusMode.FOCUS_NONE
		visible = false
	if event is InputEventMouseButton:
		item_box.focus_mode = Control.FocusMode.FOCUS_NONE
		visible = false
