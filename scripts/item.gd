extends Resource
class_name Item

@export var name: String
@export var image: Texture2D
@export var value: float
@export var type: Enums.ItemType

func serialise():
	return {
		"filename": resource_path
	}
