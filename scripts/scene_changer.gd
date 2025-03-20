extends Node


var current_scene_type: Enums.SceneType
@onready var scene_names_to_scenes = {
	"placeholder_fishing" : "res://worlds/piotrus_world.tscn",
	"physics_fishing": "res://worlds/fishing_world.tscn",
	"placeholder_dating": "res://worlds/shrimp_dating.tscn",
	"main_menu":"res://worlds/title.tscn"
}

@onready var scene_names_to_types = {
	"placeholder_fishing": Enums.SceneType.FISHING,
	"physics_fishing": Enums.SceneType.FISHING,
	"placeholder_dating": Enums.SceneType.DATING,
	"main_menu": Enums.SceneType.MENU
}

func change_scene(name: String):
	current_scene_type = scene_names_to_types[name]
	get_tree().change_scene_to_file(scene_names_to_scenes[name])
