extends Spatial

onready var base_region:Region = $NeighborhoodRegion

func _ready():
	Count.make_counters([
		"subs", "subs_active", "subs_inactive", 
		"paths", "structures", "floors", "rooms",
		"paths_active", "structures_active", "floors_active", "rooms_active",
	])
	var result = base_region.generate()
	if result == GDScriptFunctionState:
		result = yield(result, "completed")
	Count.pop_all()

func _input(event):
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	elif event.is_action_pressed("restart_game"):
		get_tree().reload_current_scene()
