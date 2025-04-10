extends CanvasLayer



func _on_inventory_pressed() -> void:
	GlobalMusicPlayer.play_click()
	Inventory.toggle_show_inventory(true)
