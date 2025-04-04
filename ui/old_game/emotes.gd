extends Control

@onready var blush = $Blush
@onready var sweat = $Sweat
@onready var sparkle = $Sparkle
@onready var question = $Question
@onready var exclamation = $Exclamation

func _ready() -> void:
	reset_all()
	
func reset_all():
	for child in get_children():
		child.visible = false

func start_blush():
	reset_all()
	blush.visible = true

func start_sweat():
	reset_all()
	sweat.visible = true

func start_sparkle():
	reset_all()
	sparkle.visible = true

func start_question():
	reset_all()
	question.visible = true

func start_exclamation():
	reset_all()
	exclamation.visible = true
