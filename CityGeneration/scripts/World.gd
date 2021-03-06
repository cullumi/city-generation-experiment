extends Spatial

onready var base_region:Region = $DistrictRegion
onready var world_defs:WorldDefs = WorldDefs.new()

func _ready():
	Count.make_counters([
		"regions", "regions_active", "regions_inactive", 
		"paths", "structures", "floors", "rooms",
		"paths_active", "structures_active", "floors_active", "rooms_active",
		"locals",
	])
	base_region.type = world_defs.get_typeDef(base_region.feature_name)
	var result = base_region.generate()
	if result is GDScriptFunctionState:
		result = yield(result, "completed")
	print("\n\nResults:")
	Count.pop_all()

var test:bool = true
func _process(_delta):
	if test and base_region.generated:
		Files.log_to_file(base_region.region_print(), "RegionTree")
		test = false

func _input(event):
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	elif event.is_action_pressed("restart_game"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("debug"):
		print("debug")
		add_child(CSGBox.new(), true)
