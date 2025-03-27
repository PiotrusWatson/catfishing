extends Node2D

@export var active_shrimps: Array[ShrimpType]
@onready var player = $Player
@onready var hoke_cam = $HookCamera
@onready var ui = $UI

func _ready():
	hoke_cam.follow_target = player.hook
	player.hooked_shrimp.connect(ui.shrimp_on)
	player.caught_shrimp.connect(catch_shrimp)
	player.caught_shrimp.connect(ui.update_fishes_left)
	player.game_ended.connect(game_end)
	ui.update_fishes_left("JUNK")
	


func catch_shrimp(shrimp: ShrimpType):
	Globals.current_shrimp = shrimp

	ui.caught()
	
func game_end():
	print("game over")
	ui.show_final_selection(active_shrimps)

func _on_ui_caught_text_faded() -> void:
	SceneChanger.change_scene(SceneChanger.Worlds.PLACEHOLDER_DATING)
