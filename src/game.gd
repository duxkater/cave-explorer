extends Node

@onready var player: Entity
@onready var map: Map = %Map
@onready var entities = $Map/Entities
@onready var input_handler: InputHandler = $InputHandler
@onready var camera: Camera2D = $Camera2D
@onready var game_over_screen = %GameOverScreen

func _ready() -> void:
	input_handler.transition_to(InputHandler.InputHandlers.PAUSE)
	pass

func new_game():
	input_handler.transition_to(InputHandler.InputHandlers.MAIN_GAME)
	player = Entity.new(null, "player")
	entities.add_child(player)
	remove_child(camera)
	player.add_child(camera)
	map.generate(player)

func _physics_process(_delta: float) -> void:
	var action: Action = await input_handler.get_action(player)
	if action:
		if action.perform():
			_handle_enemy_turns()
			map.update_fov(player.grid_position)

func _handle_enemy_turns() -> void:
	for entity in map.entities.get_children():
		if entity.ai_component != null and entity != player:
			entity.ai_component.perform()

func game_over():
	input_handler.transition_to(InputHandler.InputHandlers.GAME_OVER)
	game_over_screen.show()
