extends Node

var first_time = true
var current_shrimp: ShrimpType
var current_scene_type: Enums.SceneType
var item_being_given: Item
var current_love: int
var number_of_successful_fishes: int = -1
var end_status = Enums.EndStatus.NOT_END

func make_tiny_timer():
	return get_tree().create_timer(0.01)

func set_current_shrimp(new_shrimp):
	current_shrimp = new_shrimp
	current_love = current_shrimp.love

func increment_current_love():
	current_shrimp.increment_love()

func decrement_current_love():
	current_shrimp.decrement_love()

func set_given_item(item: Item):
	item_being_given = item

func strip_to_alphanumeric(name: String):
	var regex = RegEx.new()
	regex.compile("[^A-Za-z0-9]")
	var result = regex.search(name)
	return result.get_string(0)
	
func save(filename: String):
	filename = strip_to_alphanumeric(filename)
	var save_file = FileAccess.open("user://" + filename + ".save", FileAccess.WRITE)
	
func intersect_arrays(arr1, arr2):
	var arr2_dict = {}
	for v in arr2:
		arr2_dict[v] = true

	var in_both_arrays = []
	for v in arr1:
		if arr2_dict.get(v, false):
			in_both_arrays.append(v)
	return in_both_arrays
	
func not_in_second_array(arr1, arr2):
	var arr2_dict = {}
	for v in arr2:
		arr2_dict[v] = true

	var not_in_second_array = []
	for v in arr1:
		if not arr2_dict.get(v, false):
			not_in_second_array.append(v)
	return not_in_second_array
