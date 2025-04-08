extends AudioStreamPlayer

@onready var menu_music = preload("res://audio/music/ShrimpMenu2.mp3")
@onready var dating_music = preload("res://audio/music/ShrimpDate1.mp3")

func play_menu():
	stop()
	stream = menu_music
	play()

func play_dating():
	stop()
	stream = dating_music
	play()

func set_volume(new_volume):
	volume_db = new_volume
