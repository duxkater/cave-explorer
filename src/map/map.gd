class_name Map
extends Node2D

var width: int = 80
var height: int = 45
var player: Entity
var pathfinder: AStarGrid2D
const entity_pathfinding_weight = 10.0
@onready var game = $".."
@onready var tiles: Node2D = $Tiles
@onready var entities: = $Entities
@onready var dungeon_generator: Dungeon_generator
@onready var camera: Camera2D = $"../Camera2D"
@onready var field_of_view: FieldOfView = $FieldOfView

func generate(_player) -> void:
	player = _player
	player.map = self
	dungeon_generator = Dungeon_generator.new(width, height, player, self, game)
	var dungeon = dungeon_generator.generate()
	for tile in dungeon.tiles:
		tiles.add_child(tile)
	for entity in dungeon.entities:
		entities.add_child(entity)
	setup_pathfinding()
	update_fov(player.grid_position)

func setup_pathfinding() -> void:
	pathfinder = AStarGrid2D.new()
	pathfinder.region = Rect2i(0, 0, width, height)
	pathfinder.update()

func get_tile(grid_position: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_position)
	if tile_index == -1:
		return null
	if tiles.get_children().size() == 0:
		return null
	return tiles.get_child(tile_index)

func grid_to_index(grid_position: Vector2i) -> int:
	if not is_in_bounds(grid_position):
		return -1
	return grid_position.y * width + grid_position.x

func get_actors() -> Array[Entity]:
	var actors: Array[Entity] = []
	for entity in entities.get_children():
		if entity.get_entity_type() == Entity.EntityType.ACTOR and entity.is_alive():
			actors.append(entity)
	return actors

func get_actor_at_location(location: Vector2i) -> Entity:
	for actor in get_actors():
		if actor.grid_position == location:
			return actor
	return null

func is_in_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
	)

func register_blocking_entity(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_position, entity_pathfinding_weight)

func unregister_blocking_entity(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_position, 0)

func get_blocking_entity_at_location(grid_position: Vector2i) -> Entity:
	for entity in entities.get_children():
		if entity.is_blocking_movement() and entity.grid_position == grid_position:
			return entity
	return null

func get_tile_xy(x: int, y: int) -> Tile:
	var grid_position := Vector2i(x, y)
	return get_tile(grid_position)

func update_fov(player_position: Vector2i) -> void:
	field_of_view.update_fov(self, player_position, 8)
	
	for entity in entities.get_children():
		entity.visible = get_tile(entity.grid_position).is_in_view
