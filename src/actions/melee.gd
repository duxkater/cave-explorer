class_name MeleeAction
extends Action

var target: Entity

func _init(_entity: Entity, _target: Entity) -> void:
	self.target = _target
	self.entity = _entity

func perform() -> bool:
	if not target:
		if entity.name == "Player":
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
		entity.game.get_log_manager().add_message(attack_description, attack_color)
		target.fighter_component.take_damage(damage)
	else:
		attack_description += " but does no damage."
		entity.game.get_log_manager().add_message(attack_description, attack_color)
	
	melee_animation()
	
	return true

func melee_animation():
	var start_pos = entity.global_position
	var target_pos = target.global_position
	var attack_pos = start_pos.lerp(target_pos, 0.3)
	var tween = entity.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(entity, "global_position", attack_pos, 0.1)
	tween.tween_property(entity, "global_position", start_pos, 0.1)
