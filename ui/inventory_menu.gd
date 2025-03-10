extends CanvasLayer

@onready var item_slot_container = $Panel/ScrollContainer/HBoxContainer
@export var item_slot_prefab: PackedScene

func _ready():
	for i in range(Inventory.size):
		var item_slot = item_slot_prefab.instantiate()
		item_slot_container.add_child(item_slot)
