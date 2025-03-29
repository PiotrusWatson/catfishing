extends RigidBody2D

@onready var endpoint = $EndPoint
func attach_thing(thing: RigidBody2D):
	endpoint.node_b = thing.get_path()
	
func get_end():
	return endpoint.global_position
