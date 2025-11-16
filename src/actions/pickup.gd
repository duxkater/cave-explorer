class_name PickupAction
extends Action

func perform() -> bool:
	var inventory: InventoryComponent = entity.inventory_component
	var map = entity.map
	for item in map.get_items():
		if entity.grid_position == item.grid_position:
			if inventory.items.size() >= inventory.capacity:
				entity.game.get_log_manager().add_message("Your inventory is full.", LoggerColors.IMPOSSIBLE)
				return false

			item.get_parent().remove_child(item)
			inventory.items.append(item)
			entity.game.get_log_manager().add_message("You picked up the %s!" % item.get_entity_name(), Color.WHITE)
			return true
	
	entity.game.get_log_manager().add_message("There is nothing here to pick up.", LoggerColors.IMPOSSIBLE)
	return false
