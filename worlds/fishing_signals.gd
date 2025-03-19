extends Node2D

@onready var player = $Player
@onready var hoke_cam = $HookCamera

func _ready():
	hoke_cam.follow_target = player.hook
