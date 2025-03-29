extends CanvasLayer

enum ShownText{ON, CAUGHT}
@onready var big_text = $UILayer/BigScreenText
@onready var fade_timer = $Timers/FadeTimer
@onready var fishes_left = $UILayer/FishesLeft
@onready var final_selection = $FinalSelection
signal caught_text_faded
var shown_text : ShownText
func _ready():
	big_text.visible = false
	
func show_text():
	big_text.visible = true
	fade_timer.start()

func shrimp_on():
	big_text.text = "Shrimp On"
	shown_text = ShownText.ON
	show_text()

func caught():
	big_text.text = "Caught!"
	shown_text = ShownText.CAUGHT
	show_text()
	
func show_final_selection(shrimps: Array[ShrimpType]):
	final_selection.show_shrimps(shrimps)
	
func update_fishes_left(_junk):
	fishes_left.text = "Fishes left: " + str(Globals.number_of_successful_fishes)

func _on_fade_timer_timeout() -> void:
	if big_text.visible:
		big_text.visible = false
	if shown_text == ShownText.CAUGHT:
		caught_text_faded.emit()
