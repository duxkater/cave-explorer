class_name InventoryComponent
extends Component

var items: Array[Entity]
var capacity: int

func _init(capacity: int) -> void:
	items = []
	self.capacity = capacity

func drop(item: Entity) -> void:
	items.erase(item)
	var map: Map = get_map_data()
	map.entities.add_child(item)
	item.map = map
	item.grid_position = entity.grid_position
	entity.game.get_log_manager().add_message("You dropped the %s." % item.get_entity_name(), Color.WHITE)
