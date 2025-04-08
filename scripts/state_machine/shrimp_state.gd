class_name ShrimpState extends Node

const ROAMING = "Roaming"
const CHASING = "Chasing"
const ON_HOOK = "OnHook"
const FLEEING = "Fleeing"

var shrimp

func _ready() -> void:
	await owner.ready
	shrimp = owner
	assert(shrimp != null, "ShrimpStates must be children of a shrimp type")
