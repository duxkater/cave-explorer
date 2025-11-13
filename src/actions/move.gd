class_name MovementAction
extends Action

var offset: Vector2i

func _init(_entity: Entity, dx: int, dy: int) -> void:
	super._init(_entity)
	offset = Vector2i(dx, dy)

func perform() -> bool:
	var destination: Vector2i = get_destination()
	var map: Map = get_map()
	var destination_tile: Tile = map.get_tile(destination)
	if not destination_tile or not destination_tile.is_walkable() or get_blocking_entity_at_destination():
		if entity == get_map().player:
			entity.game.get_log_manager().add_message("That way is blocked.", LoggerColors.IMPOSSIBLE)
		return false
	entity.move(offset)
	return true

func get_destination() -> Vector2i:
	return entity.grid_position + offset

func get_blocking_entity_at_destination() -> Entity:
	return get_map().get_blocking_entity_at_location(get_destination())
