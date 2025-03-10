extends PanelContainer

var empty_texture: Texture2D
var empty_label = "Empty"
@onready var image = $FlowContainer/Image
@onready var label = $FlowContainer/HBoxContainer/Label
@onready var delete_button = $FlowContainer/HBoxContainer/Delete
signal item_deleted

func _ready():
	empty_texture = image.texture
	delete_button.disabled = true
	delete_button.visible = false
	
func fill_details(item: Item):
	image.texture = item.image
	label.text = item.name
	delete_button.disabled = false
	delete_button.visible = true

func remove_details():
	image.texture = empty_texture
	label.text = empty_label
	delete_button.disabled = true
	delete_button.visible = false
	item_deleted.emit()


func _on_delete_pressed() -> void:
	remove_details()
