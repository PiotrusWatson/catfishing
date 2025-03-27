extends Node2D

@onready var player = $Player
@onready var hoke_cam = $HookCamera
@onready var ui = $UI

func _ready():
	hoke_cam.follow_target = player.hook
	player.hooked_shrimp.connect(ui.shrimp_on)
	player.caught_shrimp.connect(catch_shrimp)
	player.caught_shrimp.connect(ui.update_fishes_left)
	ui.update_fishes_left("JUNK")
	


func catch_shrimp(shrimp: ShrimpType):
	Globals.current_shrimp = shrimp
	ui.caught()
	


func _on_ui_caught_text_faded() -> void:
	SceneChanger.change_scene(SceneChanger.Worlds.PLACEHOLDER_DATING)
