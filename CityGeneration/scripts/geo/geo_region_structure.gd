extends Region

class_name StructureRegion

var body:CSGBox
var region_negatives:Array = []
var windows:Array = []
var winscale:Vector3 = Vector3(.85, .85, .85)

# Initialization

func _init(_new_type:TypeDef=null):
	name = "Structure"

func _enter_tree():
	body = add_csg_box("body")
	set_active(true, [LOCAL])

# Generation

func generate():
	Count.increment("structures")
	default_offset = Vector3(0, size.y/2, 0) # Used by floor negatives and windows.
	align_box(body)
	post_generators = ["generate_floor_negatives", "generate_windows"]
	.generate()
	Count.increment("structures_active", active)
#	assert_valid_locals()
#	if name == "Structure":
#		body.material = SpatialMaterial.new()
#		body.material.albedo_color = Color.red
#		body.material.albedo_color.a *= 0.5
#		body.material.flags_transparent = true

func generate_floor_negatives():
	for region in regions:
		var neg = add_csg_box("floorNeg")
		neg.operation = CSGShape.OPERATION_SUBTRACTION
		align_box(neg, region.position, region.size)
		region_negatives.append(neg)
#		yield(get_tree(), "idle_frame")

func generate_windows():
	for region in regions:
		for side in Side.hor_sides:
			add_window(region, Side.new(side))
#			yield(get_tree(), "idle_frame")

# Decorations

func shadow(match_to:CSGShape):
	var window:CSGShape = add_csg_box("shadow")
	window.material = SpatialMaterial.new()
	window.material.albedo_color = Color.blue
	window.material.albedo_color.a *= 0.5
	window.material.flags_transparent = true
	window.translation = match_to.translation
	window.width = match_to.width
	window.height = match_to.height
	window.depth = match_to.depth
	window.use_collision = false

func add_window(region:Region, side:Side=Side.new(Side.FRONT)):
	var window:CSGShape = add_csg_box("window")
	window.operation = CSGShape.OPERATION_SUBTRACTION
	var margins = type.region.margins
	var rsize = region.size
	var axis = side.axis
	var othax1 = Axes.find_first(side.axis)
	var othax2 = Axes.find_last(side.axis)
	var wsize = Axes.vector3(
		[rsize[othax1]*winscale[othax1], rsize[othax2]*winscale[othax2], margins[axis]],
		[othax1, othax2, axis]
	)
	var woff = Axes.vector3(
		[
			region.position[othax1],# - default_offset[othax1],
			region.position[othax2],# - default_offset[othax2],
			(region.position[axis] + (-wsize[axis])/2) * side.dir + region.position[axis],# - default_offset[axis],
		],
		[othax1, othax2, axis]
	)
	wsize[axis] += 0.005
	align_box(window, woff, wsize)
	windows.append(window)
#	shadow(window)
