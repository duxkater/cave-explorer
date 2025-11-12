class_name Tile
extends Sprite2D

const tile_types = {
	"wall": preload("res://resources/tiles/wall.tres"),
	"grass": preload("res://resources/tiles/grass.tres")
}

var _definition: TileDefinition
var key: String

var is_explored: bool = false:
	set(value):
		is_explored = value
		if is_explored and not visible:
			visible = true

var is_in_view: bool = false:
	set(value):
		is_in_view = value
		modulate = _definition.color_lit if is_in_view else _definition.color_dark
		if is_in_view and not is_explored:
			is_explored = true

func _init(grid_position: Vector2i, _key: String):
	visible = false
	centered = false
	self.key = _key
	self.position = Grid.grid_to_world(grid_position)
	set_tile_type(key)

func set_tile_type(_key: String) -> void:
	_definition = tile_types[_key]
	self.texture = _definition.texture
	self.modulate = _definition.color_lit

func is_walkable() -> bool:
	return _definition.is_walkable

func is_transparent() -> bool:
	return _definition.is_transparent
