extends Spatial

var base_region:Region = StructureRegion.new()
var world_defs:WorldDefs = WorldDefs.new()

func _init():
	Count.make_counters([
		"regions", "regions_active", "regions_inactive", 
		"paths", "structures", "floors", "rooms",
		"paths_active", "structures_active", "floors_active", "rooms_active",
		"locals",
	])
	add_child(base_region)
	base_region.size = Vector3(10, 30, 10)
	base_region.position += Vector3(10, 0, 10)

func _ready():
	base_region.type = world_defs.get_typeDef("structures")
	var result = base_region.generate()
	if result == GDScriptFunctionState:
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
		base_region.local_combiner.add_child(CSGBox.new(), true)
