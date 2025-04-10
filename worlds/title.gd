extends Control


func _ready() -> void:
	if Globals.end_status == Enums.EndStatus.JUST_STARTED:
		GlobalMusicPlayer.play_menu()
func _on_play_pressed() -> void:
	GlobalMusicPlayer.play_click()
	if Globals.end_status == Enums.EndStatus.JUST_STARTED:
		SceneChanger.change_scene(SceneChanger.Worlds.END_SCENE)
		return
	SceneChanger.change_scene(SceneChanger.Worlds.PHYSICS_FISHING)
