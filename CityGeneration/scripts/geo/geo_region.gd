extends Spatial

class_name Region

# Parameters
export (Vector3) var size = Vector3() setget set_size
export (String) var node_name = "Region"
export (String) var feature_name = "regions"
var position:Vector3 = Vector3() setget set_position
var corner_position:Vector3 = Vector3() setget set_corner_position
var corner_offset:Vector3 = Vector3() setget , get_corner_offset
var paths:Array = []
var regions:Array = []
var locals:Array = []
var parent:Region = null
var sides:Array = [0, 0, 0, 0, 0, 0]
var connections:Array = []
var post_generators:Array = []
var type:TypeDef = TypeDef.new()

var default_offset = Vector3()
var generated:bool = false

# Constants
const PATH = "path"
const REGION = "region"
const LOCAL = "local"
const debug_name = "Structure"

# Combiners
var region_combiner:Spatial
var path_combiner:Spatial
var local_combiner:CSGCombiner
const combiners:Array = []
var active = false

# Iniitialization
func _init(new_type:TypeDef=type):
	name = node_name
	type = new_type

func _enter_tree():
	region_combiner = add_combiner("region")
	path_combiner = add_combiner("path")
	local_combiner = add_combiner("local")

# Algorithm Execution

func execute_algorithms():
	for algorithm in type.algorithms:
		var res = RegionAlgorithms.call(algorithm, self)
		if res is GDScriptFunctionState: yield(res, "completed")
#		yield(get_tree(), "idle_frame")

func execute_post_generators():
	for gen in post_generators:
		var res = call(gen)
		if res is GDScriptFunctionState: yield(res, "completed")
#		yield(get_tree(), "idle_frame")

# Threading
#func start_generation_threads(g_regions:Array) -> Array:
#	var threads:Array = []
#	for region in g_regions:
#		var thread = Thread.new()
#		threads.append(thread)
#		thread.start(region, "generate")
#	return threads
#
#func end_generation_threads(threads:Array):
#	while not threads.empty():
#		for thread in threads:
#			if not thread.is_alive():
#				thread.wait_to_finish()
#		yield(get_tree(), "idle_frame")
#	print("test2")
#
## Generation
#func generate_regions(g_regions:Array) -> bool:
#	var threads:Array = start_generation_threads(g_regions)
##	yield(end_generation_threads(threads), "completed")
#	end_generation_threads(threads)
#	print("test")
#	var active_regions = false
#	for region in g_regions:
#		if region.active: active_regions = true
#	return active_regions

func generate_regions(g_regions:Array) -> bool:
	var active_regions = false
	for region in g_regions:
		region.generate()
		if region.active: active_regions = true
		yield(get_tree(), "idle_frame")
	return active_regions

func generate():
	generated = false
	Count.increment("regions")
	
	var res = execute_algorithms()
	if res is GDScriptFunctionState: yield(res, "completed")
	
	res = execute_post_generators()
	if res is GDScriptFunctionState: yield(res, "completed")
	
	res = generate_regions(regions)
	if res is GDScriptFunctionState: yield(res, "completed")
	
	res = generate_regions(paths)
	if res is GDScriptFunctionState: yield(res, "completed")
	
	var active_locals = locals_active(locals)
	set_active(active_locals, [LOCAL])
	assert_activated_correctly(active_locals)
	if (active):
		Count.increment("regions_active")
	else:
		Count.increment("regions_inactive")
	generated = true

# Assertions
func assert_activated_correctly(al):
	assert(local_combiner.use_collision == al)

func assert_valid_locals():
	for local in locals:
		assert(local.width > 0)
		assert(local.height > 0)
		assert(local.depth > 0)

# Setters
func set_position(new_position:Vector3, looped:bool=false):
	position = new_position
	if not looped:
		set_corner_position(new_position - (size/2), true)

func set_corner_position(new_position:Vector3, looped:bool=false):
	corner_position = new_position
	translation = new_position
	if not looped:
		set_position((size/2) + new_position, true)

func set_size(new_size:Vector3):
	size = new_size
	self.corner_position = corner_position

func get_corner_offset():
	return corner_position - position

# Combiner Addition
func add_combiner(c_name:String="Combiner", p_node:Node=self):
	var combiner
	if c_name == "local":
		combiner = CSGCombiner.new()
		combiner.calculate_tangents = false
		combiner.use_collision = false
	else:
		combiner = Spatial.new()
	combiners.append(combiner)
	combiner.name = c_name + " Combiner"

	p_node.add_child(combiner, true)
	return combiner

# Combiner Activation

func locals_active(g_locals):
	var active_locals = false
	for local in g_locals:
		if local is CSGShape:
			if local.use_collision:
				active_locals = true
	return active_locals

func make_active(ctype:String, val:bool):
	if ctype == "local":
		var key = ctype+"_combiner"
		self[key].use_collision = val
		self[key].calculate_tangents = val

func set_active(val, subs:Array=[REGION, PATH, LOCAL]):
	if val is Array:
		for i in range(0, subs.size()):
			make_active(subs[i], val[i])
		active = val.has(true)
	else:
		for sub in subs:
			make_active(sub, val)
		active = val

# CSG Helpers
func add_csg_box(n_name:String="CSGBox", p_node:Node=local_combiner):
	var new_body = CSGBox.new()
	Count.increment("locals")
	new_body.use_collision = true
	new_body.name = n_name
	p_node.add_child(new_body, true)
	locals.append(new_body)
	return new_body

func align_box(box:CSGBox, b_offset:Vector3=-self.corner_offset, b_size:Vector3=size):
	box.translation = b_offset
	box.width = b_size.x
	box.height = b_size.y
	box.depth = b_size.z

# Verification
func locals_valid():
	for local in locals:
		if local.width <= 0 or local.height <= 0 or local.depth <= 0:
			return false
	return true
func local_combiner_valid():
	var combiner = local_combiner
	var count:int = combiner.get_child_count()
	if count == 0:
		if combiner.calculate_tangents or combiner.use_collision:
			return false
	return true
func lc_empty():
	return local_combiner.get_child_count() == 0 or locals.empty()
func lc_ls_same():
	return local_combiner.get_child_count() == locals.size()
func combiners_valid():
	return local_combiner_valid()

# Print Helpers
func empty(boolean:bool): return "empty" if boolean else "full"
func valid(boolean:bool): return "valid" if boolean else "invalid"
func same(boolean:bool): return "same" if boolean else "diff"
func act(boolean:bool): return "active" if boolean else "inactive"
func region_print(indent:String="") -> String:
	var string:String = ""
	var lv:String = valid(locals_valid())
	var cv:String = valid(combiners_valid())
	var lce:String = empty(lc_empty())
	var lcls:String = same(lc_ls_same())
	var ra:String = act(active)
	string += indent
	string += "%s (%s/%s/%s/%s/%s){" % [name, lv, cv, lce, lcls, ra]
	if locals.empty(): string += "}\n"
	else: string += "\n"
	indent += "\t"
	for local in locals:
		var vector = "(%5.2f, %5.2f, %5.2f)" % [local.width, local.height, local.depth]
		string += indent + "\tlocal: " + vector + "\t" + local.name + "\n"
	if not locals.empty(): string += indent + "}\n"
	for region in regions:
		string += region.region_print(indent)
	for path in paths:
		string += path.region_print(indent)
	return string
