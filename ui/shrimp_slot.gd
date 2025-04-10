extends Control

@onready var image = $ShrimpDeets/Image
@onready var name_text = $ShrimpDeets/Name
@onready var menu = $Menu
var shrimp_info: ShrimpType
signal picked_shrimp(shrimp: ShrimpType)

	
func fill_deets(shrimp: ShrimpType):
	shrimp_info = shrimp
	image.texture = shrimp.images.basic
	name_text.text = shrimp.name


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		GlobalMusicPlayer.play_click()
		picked_shrimp.emit(shrimp_info)
