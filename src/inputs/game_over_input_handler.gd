class_name GameOverInputHandler
extends BaseInputHandler


func enter() -> void:
	mainMenu.visible = true
	pass

func exit() -> void:
	pass

func get_action(player: Entity) -> Action:
	return null
