class_name Dungeon_generator
extends Node

var width: int
var height: int
var max_rooms: int = 30
var room_max_size: int = 10
var room_min_size: int = 6
var _rng := RandomNumberGenerator.new()
var tiles: Array
var entities: Array
var player: Entity
var max_monsters_per_room: int = 2
var max_items_per_room: int = 2
var map: Map
var game

func _init(_width: int, _height: int, _player: Entity, _map: Map, _game):
	self.player = _player
	self.width = _width
	self.height = _height
	self.map = _map
	self.game = _game
	# fill with walls, to carve in
	for y in height:
		for x in width:
			tiles.append(Tile.new(Vector2i(x, y), "wall"))

func generate():
	generateLayout()
	return {"tiles": tiles, "entities": entities}

func generateLayout():
	var rooms: Array[Rect2i] = []
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(0, width - room_width - 1)
		var y: int = _rng.randi_range(0, height - room_height - 1)
		
		var new_room := Rect2i(x, y, room_width, room_height)
		var has_intersections := false
		for room in rooms:
			if room.intersects(new_room):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		if rooms.is_empty():
			player.grid_position = new_room.get_center()
		else:
			_tunnel_between(rooms.back().get_center(), new_room.get_center())
		
		carve_room(new_room)
		placeEntities(new_room)
		rooms.append(new_room)

func _tunnel_between(start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(start.y, start.x, end.x)
		_tunnel_vertical(end.x, start.y, end.y)
	else:
		_tunnel_vertical(start.x, start.y, end.y)
		_tunnel_horizontal(end.y, start.x, end.x)
		
func carve_room(room):
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			carve_tile(x, y)

func carve_tile(x: int, y: int):
	var tile = get_tile(Vector2i(x, y))
	tile.set_tile_type("grass")

func get_tile(grid_position: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_position)
	return tiles[tile_index]

func _tunnel_horizontal(y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		carve_tile(x, y)

func _tunnel_vertical(x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		carve_tile(x, y)

func placeEntities(room: Rect2i):
	var number_of_monsters: int = _rng.randi_range(0, max_monsters_per_room)
	
	for _i in number_of_monsters:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2i(x, y)
		
		var can_place = true
		for entity in entities:
			if entity && entity.grid_position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			var new_entity: Entity
			print(self.game)
			new_entity = Entity.new(map, game, "goblin", new_entity_position)
			entities.append(new_entity)

func grid_to_index(grid_position: Vector2i) -> int:
	return grid_position.y * width + grid_position.x
