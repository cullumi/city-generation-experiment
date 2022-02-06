extends Spatial

class_name Region

# Parameters
export (Vector3) var size = Vector3() setget set_size
var position:Vector3 = Vector3() setget set_position
var corner_position:Vector3 = Vector3() setget set_corner_position, get_corner_position
var paths:Array = []
var regions:Array = []
var locals:Array = []
var parent:Region = null
var sides:Array = [0, 0, 0, 0, 0, 0]
var connections:Array = []
var defs:RegionDefs = RegionDefs.new()

var default_offset = Vector3()

# Constants
const PATH = "path"
const REGION = "region"
const LOCAL = "local"

# Combiners
var region_combiner:CSGCombiner
var path_combiner:CSGCombiner
var local_combiner:CSGCombiner
var active = false

# Iniitialization
func _init():
	name = "Region"

func _enter_tree():
	region_combiner = add_combiner("Region")
	path_combiner = add_combiner("Path")
	local_combiner = add_combiner("Local")

# Generation
func generate():
	var active_regions = false
	for region in regions:
		region.generate()
		Count.increment("subs")
		if region.active: active_regions = true
	var active_paths = false
	for path in paths:
		path.generate()
		Count.increment("subs")
		if path.active: active_paths = true
	var active_locals = false
	for local in locals:
		if local is CSGShape: active_locals = true
	set_active([active_regions, active_paths, active_locals])
	assert_activated_correctly(active_regions, active_paths, active_locals)
	if (active):
		Count.increment("subs_active")
	else:
		Count.increment("subs_inactive")

# Activation Assertions
func assert_activated_correctly(ar, ap, al):
	var check = ar or ap or al
	assert(check == active, "Active doesn't match child combiners")
	assert(region_combiner.use_collision == ar)
	assert(path_combiner.use_collision == ap)
	assert(local_combiner.use_collision == al)

# Setters
func set_position(new_position:Vector3):
	position = new_position
	translation = new_position

func set_corner_position(new_position:Vector3):
	var new_pos = (size/2) + new_position
	self.position = new_pos

func get_corner_position():
	return self.position - (size/2)

func set_size(new_size:Vector3):
	size = new_size

# Combiner Addition
func add_combiner(c_name:String="Combiner", p_node:Node=self):
	var combiner = CSGCombiner.new()
	combiner.name = c_name + " Combiner"
	combiner.calculate_tangents = false
	combiner.use_collision = false
	p_node.add_child(combiner)
	return combiner

# Combiner Activation
func make_active(type:String, val:bool):
	var key = type+"_combiner"
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
func add_csg_box(p_node=local_combiner):
	var new_body = CSGBox.new()
	new_body.use_collision = true
	p_node.add_child(new_body)
	locals.append(new_body)
	return new_body

func align_box(box:CSGBox, b_offset:Vector3=default_offset, b_size:Vector3=size):
#	box.translation = (b_size / 2) + b_offset
	box.translation = b_offset
	box.width = b_size.x
	box.height = b_size.y
	box.depth = b_size.z
