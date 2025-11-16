class_name BaseInputHandler
extends Node

@onready var map: Map = %Map
@onready var mainMenu = %MainMenu
@onready var game_menu = %GameMenu

func enter() -> void:
	pass

func exit() -> void:
	pass

func get_action(_player: Entity) -> Action:
	return null
