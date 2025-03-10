extends CanvasLayer

@onready var item_slot_container = $Panel/ScrollContainer/HBoxContainer
@onready var panel = $Panel
@export var item_slot_prefab: PackedScene

func _ready():
	for i in range(Inventory.size):
		var item_slot = item_slot_prefab.instantiate()
		item_slot_container.add_child(item_slot)

func update(items: Array[Item]):
	for i in range(Inventory.size):
		var item_slot = item_slot_container.get_child(i)
		item_slot.fill_details(null, i)
	
	for i in range(len(items)):
		var item_slot = item_slot_container.get_child(i)
		item_slot.fill_details(items[i], i)
		item_slot.item_deleted.connect(handle_deletion)
	

func toggle_show(is_show: bool):
	visible = is_show
	if is_show:
		panel.mouse_filter = panel.MOUSE_FILTER_STOP
	else:
		panel.mouse_filter = panel.MOUSE_FILTER_IGNORE

func handle_deletion(index: int):
	Inventory.remove_and_show(index)
	Inventory.toggle_show_inventory(true)
	
func _on_close_pressed() -> void:
	toggle_show(false)
