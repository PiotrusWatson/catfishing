extends Control


func _ready() -> void:
	if Globals.end_status == Enums.EndStatus.JUST_STARTED:
		GlobalMusicPlayer.play_menu()
func _on_play_pressed() -> void:
	SceneChanger.change_scene(SceneChanger.Worlds.PHYSICS_FISHING)
