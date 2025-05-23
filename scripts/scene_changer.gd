extends Node

enum Worlds{PLACEHOLDER_FISHING, PHYSICS_FISHING, PLACEHOLDER_DATING, END_SCENE, MAIN_MENU, CREDITS}
var current_scene_type: Enums.SceneType
var current_scene = Worlds.MAIN_MENU
@onready var scene_names_to_scenes = {
	Worlds.PLACEHOLDER_FISHING : "res://worlds/piotrus_world.tscn",
	Worlds.PHYSICS_FISHING: "res://worlds/fishing_world.tscn",
	Worlds.PLACEHOLDER_DATING: "res://worlds/shrimp_dating.tscn",
	Worlds.END_SCENE: "res://worlds/end_scene.tscn",
	Worlds.MAIN_MENU:"res://worlds/title.tscn",
	Worlds.CREDITS: "res://worlds/credits.tscn"
}

@onready var scene_names_to_types = {
	Worlds.PLACEHOLDER_FISHING: Enums.SceneType.FISHING,
	Worlds.PHYSICS_FISHING: Enums.SceneType.FISHING,
	Worlds.PLACEHOLDER_DATING: Enums.SceneType.DATING,
	Worlds.END_SCENE: Enums.SceneType.DATING,
	Worlds.MAIN_MENU: Enums.SceneType.MENU,
	Worlds.CREDITS: Enums.SceneType.MENU
}

func change_scene(name: Worlds):
	current_scene_type = scene_names_to_types[name]
	var last_scene = current_scene
	current_scene = name
	handle_music(last_scene, current_scene)
	get_tree().change_scene_to_file(scene_names_to_scenes[name])
	

func handle_music(last_scene: Worlds, new_scene: Worlds):
	if scene_names_to_types[last_scene] == scene_names_to_types[new_scene]:
		return
	match scene_names_to_types[new_scene]:
		Enums.SceneType.FISHING:
			GlobalMusicPlayer.play_fishing()
		Enums.SceneType.DATING:
			GlobalMusicPlayer.stop()
		Enums.SceneType.MENU:
			GlobalMusicPlayer.play_menu()
