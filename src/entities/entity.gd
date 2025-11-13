class_name Entity
extends Sprite2D

enum AIType {NONE, HOSTILE}
const entity_types = {
	"player": "res://resources/actors/player.tres",
	"goblin": "res://resources/actors/goblin.tres"
}
enum EntityType {CORPSE, ITEM, ACTOR}

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)
var _definition: EntityDefinition
var entity_name: String
var blocks_movement: bool
var map: Map
var game

var type: EntityType:
	set(value):
		type = value
		z_index = type

var fighter_component: FighterComponent
var ai_component: BaseAIComponent
# var consumable_component: ConsumableComponent
# var inventory_component: InventoryComponent

func _init(_map: Map, _game, key: String = "", _position = null) -> void:
	centered = false
	game = _game
	if _position:
		grid_position = _position
	self.map = _map
	set_entity_type(key)

func set_entity_type(key: String) -> void:
	var entity_definition: EntityDefinition = load(entity_types[key])
	_definition = entity_definition
	type = _definition.type
	blocks_movement = _definition.is_blocking_movement
	entity_name = _definition.name
	texture = entity_definition.texture
	modulate = entity_definition.color
	
	match entity_definition.ai_type:
		AIType.HOSTILE:
			ai_component = HostileEnemyAIComponent.new()
			add_child(ai_component)
			
	if entity_definition.fighter_definition:
		fighter_component = FighterComponent.new(entity_definition.fighter_definition)
		add_child(fighter_component)
		
func is_alive() -> bool:
	return ai_component != null

func get_entity_name() -> String:
	return entity_name

func move(move_offset: Vector2i) -> void:
	map.unregister_blocking_entity(self)
	grid_position += move_offset
	map.register_blocking_entity(self)

func is_blocking_movement() -> bool:
	return blocks_movement

func get_entity_type() -> int:
	return _definition.type

func player_died():
	map.game.game_over()
