extends GPUParticles2D

@export var hearts: Texture2D
@export var sparkles: Texture2D
@onready var heart_sound = $HeartSound
@onready var sparkle_sound = $SparkleSound

func emit_hearts():
	texture = hearts
	emitting = true
	heart_sound.play()
	
func emit_sparkles():
	texture = sparkles
	emitting = true 
	sparkle_sound.play()
