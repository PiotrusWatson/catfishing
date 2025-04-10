extends AudioStreamPlayer

@onready var menu_music = preload("res://audio/music/ShrimpMenu2.mp3")
@onready var dating_music = preload("res://audio/music/ShrimpDate1.mp3")
@onready var fishing_music = preload("res://audio/music/FishingGame1.2.5.mp3")
@onready var alone_music = preload("res://audio/music/EndingSong_Alone_1.1.6..mp3")
@onready var menu_click = $MenuClick
func play_menu():
	stop()
	stream = menu_music
	play()

func play_dating():
	stop()
	stream = dating_music
	play()
	
func play_fishing():
	stop()
	stream = fishing_music
	play()

func play_alone():
	stop()
	stream = alone_music
	play()

func play_click():
	menu_click.play()

func set_volume(new_volume):
	volume_db = new_volume
