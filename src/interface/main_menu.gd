extends CanvasLayer

@onready var game = $".."
@onready var mainMenu = %MainMenu

func _on_new_game_button_button_down() -> void:
	game.new_game()
	mainMenu.hide()

func _on_quit_button_button_down() -> void:
	get_tree().quit()
