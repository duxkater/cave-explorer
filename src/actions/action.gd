class_name Action
extends RefCounted

var entity: Entity

func _init(_entity: Entity) -> void:
	self.entity = _entity

# returns true if the action takes a turn
func perform() -> bool:
	return false

func get_map():
	return entity.map
