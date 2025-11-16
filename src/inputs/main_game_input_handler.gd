class_name MainGameInputHandler
extends BaseInputHandler

const directions = {
	"move_up": Vector2i.UP,
	"move_down": Vector2i.DOWN,
	"move_left": Vector2i.LEFT,
	"move_right": Vector2i.RIGHT,
	"move_up_left": Vector2i.UP + Vector2i.LEFT,
	"move_up_right": Vector2i.UP + Vector2i.RIGHT,
	"move_down_left": Vector2i.DOWN + Vector2i.LEFT,
	"move_down_right": Vector2i.DOWN + Vector2i.RIGHT,
}

#const inventory_menu_scene = preload("res://src/GUI/InventorMenu/inventory_menu.tscn")

#@export var reticle: Reticle

func get_action(player: Entity) -> Action:
	var action: Action = null
	
	for direction in directions:
		if Input.is_action_just_pressed(direction):
			var offset: Vector2i = directions[direction]
			action = BumpAction.new(player, offset.x, offset.y)
			
	if Input.is_action_just_pressed("get"):
		action = PickupAction.new(player)
	
	if Input.is_action_just_pressed("quit"):
		mainMenu.visible = !mainMenu.visible

	return action
