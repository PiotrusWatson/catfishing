extends Control
@onready var fader = $Fader
func _ready():
	fader.init(self)

func fade_in():
	fader.start_unfading()

func fade_out():
	fader.start_fading()
	
