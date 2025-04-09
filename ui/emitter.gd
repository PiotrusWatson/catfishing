extends GPUParticles2D

@export var hearts: Texture2D
@export var sparkles: Texture2D

func emit_hearts():
	texture = hearts
	emitting = true

func emit_sparkles():
	texture = sparkles
	emitting = true 
