extends Area2D

@export var thing_to_spawn: PackedScene
@export var item_thing_to_spawn: PackedScene
@export var max_stuff = 9
@export var shrimp_to_item_ratio = 0.3
@onready var walls = $Walls
@onready var left_wall = $Walls/Left
@onready var right_wall = $Walls/Right
@onready var shape = $Shape
@onready var spawn_timer = $SpawnTimer
@onready var tooltip = $UI/ToolTip
var spawning_pool: Array[ShrimpType]
var spawned: Array[ItemOrShrimp]
signal pool_exhausted

var max_shrimp
var max_item
var shrimp_counter: int
var item_counter: int

func init(shrimps: Array[ShrimpType]):
	if Globals.has_been_on_a_date:
		tooltip.visible = false
	spawning_pool = shrimps
	spawn_timer.start()
	max_shrimp = int(max_stuff * shrimp_to_item_ratio)
	max_item = int(max_stuff * (1 - shrimp_to_item_ratio))
	shrimp_counter = 0
	item_counter = 0
	tooltip.fade_out()
	
func get_non_haters() -> Array[ShrimpType]:
	var not_haters: Array[ShrimpType] = []
	for shrimp in spawning_pool:
		if shrimp.love >= 0:
			not_haters.append(shrimp)
	return not_haters
	
func spawn_shrimp():
	var not_haters: Array[ShrimpType] = get_non_haters()
	if len(not_haters) == 0:
		pool_exhausted.emit()
		return
	var shrimp_to_spawn = pick_shrimp(not_haters)
	if shrimp_to_spawn == null or len(spawned) >= max_stuff:
		return
	spawn_silhouette(shrimp_to_spawn)
	shrimp_counter += 1
	
func get_possible_items():
	var inventory = Inventory.items
	var given_items = Inventory.given_items
	var items_to_not_give = inventory + given_items + spawned
	return Globals.not_in_second_array(Inventory.get_possible_items(), items_to_not_give)

func pick_item():
	var possible_items = get_possible_items()
	print(possible_items)
	if len(possible_items) == 0:
		return null
	return possible_items.pick_random()

func spawn_item():
	var item = pick_item()
	if item == null:
		return
	spawned.append(item)
	spawn_silhouette(item)
	item_counter += 1


func pick_shrimp(shrimp_pool: Array[ShrimpType]):
	var legal_shrimps = Globals.not_in_second_array(shrimp_pool, spawned)
	if len(legal_shrimps) == 0:
		return null
	return legal_shrimps.pick_random()
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("toggle_fishing"):
		body.toggle_fishing(true)
		tooltip.fade_in()
		


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("toggle_fishing"):
		body.toggle_fishing(false)
		tooltip.fade_out()
		
	if body.is_in_group("Hook"):
		body.catch_shrimp()
	
func pick_point_in_bounds():
	var rect: Rect2 = shape.shape.get_rect()
	var start = rect.position
	var end = rect.end
	var x = randf_range(start.x, end.x)
	var y = randf_range(start.y, end.y)
	return Vector2(x, y)
	
func spawn_silhouette(shrimp: ItemOrShrimp):
	var spawned_thing: Node2D
	if shrimp is ShrimpType:
		spawned_thing = thing_to_spawn.instantiate()
	elif shrimp is Item:
		spawned_thing = item_thing_to_spawn.instantiate()
	spawned_thing.init(shrimp, walls)
	spawned.append(shrimp)
	add_child(spawned_thing)
	spawned_thing.position = pick_point_in_bounds() + position
	return spawned_thing
	
	
func spawn_item_or_shrimp():
	if shrimp_counter >= max_shrimp:
		spawn_item()
		return
	elif item_counter >= max_item:
		spawn_shrimp()
		return
	elif shrimp_counter >= max_shrimp and item_counter >= max_item:
		return
	
	var is_item = bool(randi_range(0, 1))
	if is_item:
		spawn_item()
	else:
		spawn_shrimp()
		

func remove_spawned(thing_to_look_for: ItemOrShrimp):
	for i in range(len(spawned)):
		if spawned[i] == thing_to_look_for:
			spawned.remove_at(i)
			return


func _on_spawn_timer_timeout() -> void:
	spawn_item_or_shrimp()
