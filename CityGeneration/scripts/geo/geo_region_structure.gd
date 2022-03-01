extends Region

class_name StructureRegion

var body:CSGBox
var region_negatives:Array = []
var windows:Array = []
var winscale:Vector3 = Vector3(1, 1, 1)

# Initialization

func _init():
	name = "StructureRegion"
	defs.region.type = FloorRegion
	defs.region.variance.y = 0
	defs.region.avg_size.y = Convert.ft_to_m(8*1.5)

func _enter_tree():
	body = add_csg_box()
	set_active(true, [LOCAL])

# Generation

func generate():
	Count.increment("structures")
	default_offset = Vector3(0, size.y/2, 0) # Used by floor negatives and windows.
	align_box(body)
	var result = RegionAlgorithms.skyscraper(self)
	if (result is GDScriptFunctionState):
		result = yield(result, "completed")
	.generate()
	Count.increment("structures_active", active)
	generate_floor_negatives()
	generate_windows()
	if name == "StructureRegion":
		body.material = SpatialMaterial.new()
		body.material.albedo_color = Color.red
		body.material.albedo_color.a *= 0.5
		body.material.flags_transparent = true

func generate_floor_negatives():
	for region in regions:
		var neg = add_csg_box(body)
		neg.operation = CSGShape.OPERATION_SUBTRACTION
		align_box(neg, region.position - default_offset, region.size)
		region_negatives.append(neg)

func generate_windows():
	for region in regions:
		for side in Side.hor_sides:
			add_window(region, Side.new(side))

# Decorations

func add_window(region:Region, side:Side=Side.new(Side.FRONT)):
	var window:CSGShape = add_csg_box(body)
	window.operation = CSGShape.OPERATION_SUBTRACTION
	var margins = defs.region.margins
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
			region.position[othax1] - default_offset[othax1],
			region.position[othax2] - default_offset[othax2],
			(region.corner_position[axis] - default_offset[axis] + (-wsize[axis])/2) * side.dir
		],
		[othax1, othax2, axis]
	)
	wsize[axis] += 0.001
	align_box(window, woff, wsize)
	windows.append(window)
