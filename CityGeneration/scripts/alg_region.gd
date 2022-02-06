extends Node

#class_name RegionAlgorithms

# Dictionaries

static func new_region_defs() -> RegionDefs:
	return RegionDefs.new()

static func new_region_vector() -> RegionVector:
	return RegionVector.new()

static func new_region_vectors() -> RegionVectors:
	return RegionVectors.new()


# Constants

const X  = "x"
const Y = "y"
const Z = "z"
const T = "t"
const SUCCESS = true
const FAILURE = false

var debug_parent


### Routines

func cityscape(parent:Region):
	var d = new_region_vectors()
	perfect_grid(parent, d, Y)
	create_plane(parent.defs.region.type, d.r, parent.regions, parent.region_combiner, X, Z)
	create_spans(parent.defs.path.type, d.p, parent.paths, parent.path_combiner)
	rough_surface(parent.defs.region, parent.regions, Y)
	rough_surface(parent.defs.path, parent.paths, Y)
	return SUCCESS

func verticalcity(parent:Region):
	var d = new_region_vectors()
	perfect_grid(parent, d, Z)
#	create_horizontal(parent.defs.region.type, d.r, parent.regions, parent.region_combiner)
	create_plane(parent.defs.region.type, d.r, parent.regions, parent.region_combiner, X, Y)
	create_spans(parent.defs.path.type, d.p, parent.paths, parent.path_combiner)
	rough_surface(parent.defs.region, parent.regions, Z)
	return SUCCESS

func skyscraper(parent:Region):
	debug_parent = parent
	var d = new_region_vectors()
	var reg_def:RegionDef = parent.defs.region
	stack(parent, d, Y)
	create_stack(reg_def.type, d.r, parent.regions, parent.region_combiner, Y)
#	print(parent.regions[0].size)
	margins(parent.size, reg_def.margins, parent.regions, [X,Z])
#	print(parent.regions[0].size)	
	return SUCCESS


### Post-Creation Modifiers

# RoughSurface
func rough_surface(def:RegionDef, regions:Array, axis:String=Y):
	for region in regions:
		region.size[axis] = rand_from_avg(def.variance[axis], def.avg_size[axis])

# Margin
func margins(border:Vector3, margins:Vector3, regions:Array, axes:Array=[X,Z]):
	var pos = Vector3()
	var size = border - (margins*2)
	for region in regions:
		set_position_axes(region, Axes.vals_from(pos, axes), axes)
		set_size_axes(region, Axes.vals_from(size, axes), axes)


### Creation Loops

func create_stack(type, r:RegionVector, regions:Array, combiner:Node, axis:String=Y):
	for a in range(0, r.c[axis]):
		var region:Region = type.new()
		regions.append(region)
		combiner.add_child(region)
		set_size_axes(region, [r.l[axis][a]], [axis])
		set_position_axes(region, [r.p[axis][a]], [axis])

func create_plane(type, r:RegionVector, regions:Array, combiner:Node, axis1:String=X, axis2:String=Z):
	for a1 in range(0, r.c[axis1]):
		for a2 in range(0, r.c[axis2]):
			var region:Region = type.new()
			regions.append(region)
			combiner.add_child(region)
			set_size_axes(region, [r.l[axis1][a1], r.l[axis2][a2]], [axis1, axis2])
			set_position_axes(region, [r.p[axis1][a1], r.p[axis2][a2]], [axis1, axis2])

func create_spans(type, r:RegionVector, regions:Array, combiner:Node, axes:Array=[X, Y, Z]):
	for axis in axes:
		create_span(type, r, axis, regions, combiner)

func create_span(type, r:RegionVector, axis:String, regions:Array, combiner:Node):
	for aa in range(0, r.c[axis]):
		var region = type.new()
		regions.append(region)
		combiner.add_child(region)
		region.set_size(r.l[axis][aa])
		region.set_position(r.p[axis][aa])

## Creation Loop Helpers

func set_position_axes(region:Region, vals:Array, axes:Array):
	var position = Axes.vector3(vals, axes)
	position = Axes.copy_to(region.corner_position, position, Axes.complement(axes))
	region.set_corner_position(position)

func set_size_axes(region:Region, vals:Array, axes:Array):
	var size = Axes.vector3(vals, axes)
	size = Axes.copy_to(region.size, size, Axes.complement(axes))
	region.set_size(size)


### Definition Algorithms

# Stack
func stack_region(args:AlgArgs):
	var def = args.defs.region
	var axis = args.stack_axis
	var max_ta = args.end - def.margins[axis]
	var new_ta = args.ta
	if new_ta == 0:
		new_ta += def.margins[axis]
	else:
		new_ta += def.spacing[axis]
	var card_thickness = rand_from_avg(def.variance[axis], def.avg_size[axis])
	if new_ta + card_thickness > max_ta:
		card_thickness = max_ta - new_ta
	args.d.r.p[axis].append(new_ta)
	args.d.r.l[axis].append(card_thickness)
	args.d.r.c[axis] += 1
	new_ta += card_thickness
	if new_ta == max_ta:
		new_ta = args.end
	var diff = new_ta - args.ta
	return diff

func stack(parent:Region, d:RegionVectors=null, stack_axis:String=Y) -> RegionVectors:
	if d == null: d = new_region_vectors()	
	var other1 = Axes.find_first(stack_axis)
	var other2 = Axes.find_last(stack_axis)
	
	var args = AlgArgs.new(parent, d)
	args.set_axes(["stack","other1","other2"], [stack_axis, other1, other2])
	
	axis_loop(0, parent.size[stack_axis], ["stack_region"], args)
	return d

# Grid
func perfect_grid(parent:Region, d:RegionVectors=null, const_axis:String=Y) -> RegionVectors:
	if d == null: d = new_region_vectors()
	var axis_1 = Axes.find_first(const_axis)
	var axis_2 = Axes.find_last(const_axis)
	
	aisles(parent, d, axis_1, const_axis, axis_2)
	aisles(parent, d, axis_2, const_axis, axis_1)
	return d

# Aisles
#func aisle_path(span_size:float, offset:float, p:RegionVector, path_def:RegionDef, axis:String=X, const_axis:String=Y, span_axis:String=Z) -> float:
func aisle_path(args:AlgArgs) -> float:
	var path_def = args.defs.path
	var p = args.d.p
	var axis = args.axis
	var const_axis = args.axis
	var span_axis = args.span_axis
	
	var aisle_width = rand_from_avg(path_def.variance[axis], path_def.avg_size[axis])
	var height = rand_from_avg(path_def.variance[const_axis], path_def.avg_size[const_axis])
	var size = Axes.vector3([aisle_width, height, args.span_size], [axis, const_axis, span_axis])
	p.l[axis].append(size)
	var pos = Axes.vector3([args.ta], [axis])
	p.p[axis].append(pos)
	p.c[axis] += 1
	return aisle_width

#func aisle_region(offset:float, r:RegionVector, reg_defs:RegionDef, axis:String=X) -> float:
func aisle_region(args:AlgArgs) -> float:
	var reg_defs:RegionDef = args.defs.region
	var r:RegionVector = args.d.r
	var axis:String = args.axis
	
	var region_length:float = rand_from_avg(reg_defs.variance[axis], reg_defs.avg_size[axis])
	r.l[axis].append(region_length)
	r.p[axis].append(args.ta)
	r.c[axis] += 1
	return region_length

func aisles(parent:Region, d:RegionVectors=null, axis:String=X, const_axis:String=Y, span_axis:String=Z) -> RegionVectors:
	if d == null: d = new_region_vectors()
	var defs:RegionDefs = parent.defs
	
	var args = AlgArgs.new(parent, d)
	args.set_sizes(["span"],[parent.size[span_axis]])
	args.set_axes(["", "const", "span"], [axis, const_axis, span_axis])
	
	axis_loop(0, parent.size[axis], ["aisle_path", "aisle_region"], args)
#	var a:int = 0
#	while (a < parent.size[axis]):
#		var ta = a
#		ta += aisle_path(parent.size[span_axis], ta, d.p, defs.path, axis, const_axis, span_axis)
#		a = ta + aisle_region(ta, d.r, defs.region, axis)
	return d

## Definition Algorithm Helpers

func rand_from_avg(variance, avg):
	if (variance == 0):
		return avg
	else:
		var off = (avg * fmod(randf(), variance * 2)) - (avg * variance)
		return avg + off

func axis_loop(start, end, funcs:Array=[], args:AlgArgs=null):
	if args == null: args = AlgArgs.new()
	args.a = start
	args.end = end
	while (args.a < end):
		args.ta = args.a
		for fun in funcs:
			args.ta += call(fun, args)
		args.a = args.ta
#		print("Looping...")
