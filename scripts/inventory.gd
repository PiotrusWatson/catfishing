extends Node

enum ItemIs{ADDED, REMOVED, ATTEMPTED_ADD}
var items: Array[Item]
var given_items: Array[Item]

@onready var item_get_prefab = preload("res://ui/get_item.tscn")
@onready var possible_items = {
	"kirby_toes": preload("res://resources/items/placeholder/sam_lake.tres") as Item
	}
@onready var inventory_menu_prefab = preload("res://ui/inventory.tscn")
var item_get: Node
var inventory_menu: Node
var size = 20

func get_possible_items():
	return possible_items.values()
func reset():
	items.clear()
	given_items.clear()
	
func add(item: Item):
	if len(items) < size:
		items.append(item)

func remove(index: int):
	return items.pop_at(index)

func add_and_show(item: Item):
	##TODO: inform player when full
	add(item)
	show_get_item(item, ItemIs.ADDED)

func remove_and_show(index: int):
	var removed = remove(index)
	show_get_item(removed, ItemIs.REMOVED)
	given_items.append(removed)
	return removed

func show_get_item(item: Item, status: ItemIs):
	if item_get == null:
		item_get = item_get_prefab.instantiate()
	# HACK: mighht get rly slow so let's maybe get rid of if it is
	var current_scene = get_current_scene.call()
	if !has_child(current_scene, item_get):
		current_scene.add_child(item_get)
	
	if status == ItemIs.ADDED:
		item_get.show_get(item)
	else:
		item_get.show_give(item)
		
		
func toggle_show_inventory(is_shown: bool):
	if inventory_menu == null:
		inventory_menu = inventory_menu_prefab.instantiate()
		
	var current_scene = get_current_scene.call()
	if !has_child(current_scene, inventory_menu):
		current_scene.add_child(inventory_menu)
	
	inventory_menu.update(items)
	inventory_menu.toggle_show(is_shown)

func has_child(node: Node, to_find: Node):
	for child in node.get_children():
		if child == to_find:
			return true
	return false
		
func serialise():
	pass		
		
var get_current_scene: Callable = func():
	var current_scene: Node = Engine.get_main_loop().current_scene
	if current_scene == null:
		current_scene = Engine.get_main_loop().root.get_child(Engine.get_main_loop().root.get_child_count() - 1)
	return current_scene
