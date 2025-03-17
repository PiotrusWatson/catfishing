extends PinJoint2D

@export var rope_segment_prefab: PackedScene
@export var hook_prefab: PackedScene
var hook: RigidBody2D
var rope_stack: Array[RigidBody2D]
var max_size: int
func init(starting_size, max_size):
	self.max_size = max_size
	add_first()
	for i in starting_size - 1:
		make_bigger()
		
func get_rope_direction():
	return hook.global_position - global_position

func pop_segment():
	var last_segment = rope_stack.pop_back()
	var end = rope_stack[-1]
	add_hook_to_end(end)
	last_segment.queue_free()
	
func make_bigger_by_amount(amount):
	for i in range(amount):
		if !make_bigger():
			return
			
func make_smaller_by_amount(amount):
	for i in range(amount):
		if !make_smaller():
			return
	
func make_bigger():
	if len(rope_stack) >= max_size:
		return false
	push_segment()
	return true

func make_smaller():
	if len(rope_stack) <= 1:
		return false
	pop_segment()
	return true

func push_segment():
	var rope_segment = make_segment()
	var end = rope_stack[-1]
	rope_segment.global_position = end.get_end()
	end.attach_thing(rope_segment)
	add_hook_to_end(rope_segment)
	rope_stack.push_back(rope_segment)
	
func add_first():
	var rope_segment = make_segment()
	rope_segment.global_position = global_position
	node_b = rope_segment.get_path()
	rope_stack.push_back(rope_segment)
	add_hook_to_end(rope_segment)

func add_hook_to_end(end: RigidBody2D):
	if hook == null:
		hook = make_hook()
	hook.global_position = end.get_end()
	end.attach_thing(hook)

func make_hook():
	hook = hook_prefab.instantiate()
	add_child(hook)
	return hook
func make_segment():
	var rope_segment: RigidBody2D = rope_segment_prefab.instantiate()
	add_child(rope_segment)
	return rope_segment
