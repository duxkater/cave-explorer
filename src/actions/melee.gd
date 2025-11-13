class_name MeleeAction
extends Action

var target: Entity

func _init(_entity: Entity, _target: Entity) -> void:
	self.target = _target
	self.entity = _entity

func perform() -> bool:
	if not target:
		if entity.name == "Player":
			print("nothing to attack")
			entity.game.get_log_manager().add_message("Nothing to attack.", LoggerColors.IMPOSSIBLE)
		return false

	var damage: int = entity.fighter_component.power - target.fighter_component.defense
	var attack_color: Color
	if entity.name == "Player":
		attack_color = LoggerColors.PLAYER_ATTACK
	else:
		attack_color = LoggerColors.ENEMY_ATTACK
	var attack_description: String = "%s attacks %s" % [entity.get_entity_name(), target.get_entity_name()]
	if damage > 0:
		attack_description += " for %d hit points." % damage
		target.fighter_component.take_damage(damage)
	else:
		attack_description += " but does no damage."
	entity.game.get_log_manager().add_message(attack_description, attack_color)
	return true
