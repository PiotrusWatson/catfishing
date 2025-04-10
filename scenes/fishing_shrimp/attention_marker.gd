extends Node2D

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var exclamation_mark: Sprite2D = $ExclamationMark

@export var duration: float = 1.5

func _ready() -> void:
	exclamation_mark.visible = false

func _on_shimp_noticed_hook() -> void:
	_give_attention.call_deferred()

func _give_attention() -> void:
	animations.play("notice")
	await animations.animation_finished
	await get_tree().create_timer(duration).timeout

	animations.play("fade")
	await animations.animation_finished
	pass
