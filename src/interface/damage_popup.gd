extends Node

func show(target: Node2D, amount: int, color: Color = Color(1,0,0)):
	var label := Label.new()
	label.text = str(amount)
	label.modulate = color
	label.z_index = 999
	get_tree().current_scene.add_child(label)
	label.global_position = target.global_position

	var tween := label.create_tween()
	tween.set_parallel(true)

	tween.tween_property(label, "global_position:y",
		label.global_position.y - 20,
		0.6
	)
	tween.tween_property(label, "modulate:a", 0.0, 0.6)

	tween.finished.connect(label.queue_free)
