extends Spatial

func _input(event):
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	elif event.is_action_pressed("restart_game"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("debug"):
		$CSGCombiner.add_child(CSGBox.new(), true)
