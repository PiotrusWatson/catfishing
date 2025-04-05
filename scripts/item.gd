extends ItemOrShrimp
class_name Item

@export var name: String
@export var image: Texture2D

func serialise():
	return {
		"filename": resource_path
	}
