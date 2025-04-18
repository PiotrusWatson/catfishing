extends Node2D

@export var active_shrimps: Array[ShrimpType]
@export var fishing_limit = 1
@onready var player = $Player
@onready var hoke_cam = $HookCamera
@onready var ui = $UI
@onready var fishing_zone = $FishingZone

func _ready():
	if Globals.end_status != Enums.EndStatus.NOT_END:
		Globals.number_of_successful_fishes = fishing_limit
		for shrimp in active_shrimps:
			shrimp.reset()
		Globals.shrimp_pool = active_shrimps
		Inventory.reset()
		Globals.end_status = Enums.EndStatus.NOT_END
	
	if Globals.number_of_successful_fishes <= 0:
		game_end()
	
	hoke_cam.follow_target = player.hook
	player.hooked_shrimp.connect(ui.shrimp_on)
	player.caught_shrimp.connect(catch_shrimp)
	player.caught_shrimp.connect(ui.update_fishes_left)
	player.game_ended.connect(game_end)
	ui.update_fishes_left("JUNK")
	fishing_zone.init(active_shrimps)
	

func catch_shrimp(shrimp: ItemOrShrimp):
	if shrimp is Item:
		Inventory.add_and_show(shrimp)
		ui.play_jingle()
		fishing_zone.remove_spawned(shrimp)
		if Globals.number_of_successful_fishes == 0:
			game_end()
	else:
		Globals.current_shrimp = shrimp
		Globals.has_been_on_a_date = true
		ui.caught()
	
func game_end():
	ui.show_final_selection(active_shrimps)

func _on_ui_caught_text_faded() -> void:
	SceneChanger.change_scene(SceneChanger.Worlds.PLACEHOLDER_DATING)
