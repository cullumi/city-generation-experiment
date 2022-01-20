extends Spatial

onready var base_region:Region = $NeighborhoodRegion

func _ready():
	base_region.generate()

func _input(event):
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	elif event.is_action_pressed("restart_game"):
		get_tree().reload_current_scene()
