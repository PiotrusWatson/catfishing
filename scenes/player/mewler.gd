extends AudioStreamPlayer2D

@export var mews: Array[AudioStream]
@export var pitch_range = Vector2(0.9, 1.1)
func mewl():
	stream = mews.pick_random()
	pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	play()
