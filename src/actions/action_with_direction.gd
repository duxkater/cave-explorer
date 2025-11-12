class_name ActionWithDirection
extends Action

var offset: Vector2i

func _init(entity: Entity, dx: int, dy: int) -> void:
	super._init(entity)
	offset = Vector2i(dx, dy)

func get_destination() -> Vector2i:
	return entity.grid_position + offset

func get_blocking_entity_at_destination() -> Entity:
	return entity.map.get_blocking_entity_at_location(get_destination())

func get_target_actor() -> Entity:
	return entity.map.get_actor_at_location(get_destination())
