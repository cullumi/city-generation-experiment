extends Node

#class_name RegionAlgorithms


### Things to Know
# Note that algorithms may not necessarily follow a format exactly;
# they may not need every step, or there may be unique steps not listed.
# This is simply intended as a guideline to make interpreting them easier.

## Definition Algorithms
#
# Definition algorithms tend to use the following format:
#
#	func algorithm(args:AlgArgs):
#		1. Fetch some data from args
#		2. Create some data and put it in args
#		3. Execute something on that data or do some cleanup
#		4. return something important
#

## Creation Loops
#
# Creation loops tend to use the following format:
#
#	func creation_loop(parameters):
#		for (0 -> some count of regions):
#			1. Create a new instance
#			2. Extract some information from parameters
#			3. Set values on the new instance
#

## Post-Creation Modifiers
#
# Modifiers are to be applied to sets of regions that have already been created.
# They tend to use the following format:
#
#	func modifier(parameters, regions):
#		for Region in regions:
#			1. Sets values on Region bases on parameters
#

### Constants and Initializers

## Dictionaries
static func new_type_def() -> TypeDef:
	return TypeDef.new()

static func new_region_vector() -> RegionVector:
	return RegionVector.new()
	
static func new_region_vectors() -> RegionVectors:
	return RegionVectors.new()

## Constants
const X  = "x"
const Y = "y"
const Z = "z"
const T = "t"
const SUCCESS = true
const FAILURE = false
const DEBUG = true
const NOBUG = false

var debug_parent

### Routines

# Creates a grid of structures with varied heights
# - A good example of combining the "perfect_grid" algorithm with the "rough_surface" modifiers
func cityscape(parent:Region):
	var d = new_region_vectors()
	perfect_grid(parent, d, Y)
	create_plane(parent.type.region, d.r, parent.regions, parent.region_combiner, X, Z)
	create_spans(parent.type.path, d.p, parent.paths, parent.path_combiner)
	rough_surface(parent.type.region, parent.regions, Y)
	rough_surface(parent.type.path, parent.paths, Y)
	return SUCCESS

# An attempt to make a cityscape that is sideways
# - Needs to be paired with the appropriate Type_def data;
#   Perhaps a method for "rotating" the data temporarily would be useful?
func verticalcity(parent:Region):
	var d:RegionVectors = new_region_vectors()
#	var old_type = parent.type
	parent.type = parent.type.mirror()
	perfect_grid(parent, d, Z)
	create_plane(parent.type.region, d.r, parent.regions, parent.region_combiner, X, Y)
	create_spans(parent.type.path, d.p, parent.paths, parent.path_combiner)
	rough_surface(parent.type.region, parent.regions, Z)
	rough_surface(parent.type.path, parent.paths, Z)
#	parent.type = old_type
	return SUCCESS

# Creates a stack of floors restricted given margins
# - Basically an obvious example of using of the "stack" algorithm
func skyscraper(parent:Region):
	debug_parent = parent
	var d = new_region_vectors()
	var reg_def:RegionDef = parent.type.region
	stack(parent, d, Y)
	create_stack(reg_def, d.r, parent.regions, parent.region_combiner, Y)
	margins(parent.size, reg_def.margins, parent.regions, [X,Z])
	return SUCCESS


### Post-Creation Modifiers

# RoughSurface
func rough_surface(def:RegionDef, regions:Array, axis:String=Y):
	for region in regions:
		region.size[axis] = rand_from_avg(def.variance[axis], def.avg_size[axis])

# Margin
func margins(border:Vector3, margins:Vector3, regions:Array, axes:Array=[X,Z]):
	var pos = Vector3() + margins
	var size = border - (margins*2)
	for region in regions:
		set_position_axes(region, Axes.vals_from(pos, axes), axes)
		set_size_axes(region, Axes.vals_from(size, axes), axes)


### Creation Loops

func create_stack(base_reg:RegionDef, r:RegionVector, regions:Array, combiner:Node, axis:String=Y):
	for a in range(0, r.c[axis]):
		var region:Region = base_reg.random_type().new_instance()
		regions.append(region)
		combiner.add_child(region, true)
		
		set_size_axes(region, [r.l[axis][a]], [axis])
		set_position_axes(region, [r.p[axis][a]], [axis])

func create_plane(base_reg:RegionDef, r:RegionVector, regions:Array, combiner:Node, axis1:String=X, axis2:String=Z, debug:bool=NOBUG):
	for a1 in range(0, r.c[axis1]):
		for a2 in range(0, r.c[axis2]):
			var region:Region = base_reg.random_type().new_instance()
			regions.append(region)
			combiner.add_child(region, true)
			
			var l1 = r.l[axis1][a1]
			var l2 = r.l[axis2][a2]
			var p1 = r.p[axis1][a1]
			var p2 = r.p[axis2][a2]
			
			if debug: print("Plane:", 
				"\t%6.2f" % p1, " -> %6.2f" % (p1+l1), "\t", axis1.to_upper(), "\t%6.2f\n" % l1,
				"      \t%6.2f" % p2, " -> %6.2f" % (p2+l2), "\t", axis2.to_upper(), "\t%6.2f" % l2)
			set_size_axes(region, [r.l[axis1][a1], r.l[axis2][a2]], [axis1, axis2])
			set_position_axes(region, [r.p[axis1][a1], r.p[axis2][a2]], [axis1, axis2])

func create_spans(base_reg:RegionDef, r:RegionVector, regions:Array, combiner:Node, axes:Array=[X, Y, Z], debug:bool=NOBUG):
	if debug: print("----------------------------------------------------")
	for axis in axes:
		create_span(base_reg, r, axis, regions, combiner)

func create_span(base_reg:RegionDef, r:RegionVector, axis:String, regions:Array, combiner:Node, debug:bool=NOBUG):
	for aa in range(0, r.c[axis]):
		var region = base_reg.random_type().new_instance()
		regions.append(region)
		combiner.add_child(region, true)
		
		var p = r.p[axis][aa]
		var v = r.l[axis][aa]
		
		if debug: print("Span  \t", 
			"%6.2f" % p[axis], " -> %6.2f" % (p[axis]+v[axis]), "\t",
			axis.to_upper(), "\t",
			"%6.2f" % r.l[axis][aa][axis]
		)
		region.set_size(r.l[axis][aa])
		region.set_corner_position(r.p[axis][aa])

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
# Algorithms that define various parameters using RegionVectors

## Stack
# Define evenly-spaced "cards" stacked one-atop the other
func stack_region(args:AlgArgs):
	var def = args.type.region
	var axis = args.stack_axis
	
	# Apply margins and spacing
	var max_ta = args.end - def.margins[axis]
	var new_ta = args.ta
	if new_ta == 0:
		new_ta += def.margins[axis]
	else:
		new_ta += def.spacing[axis]
	var card_thickness = rand_from_avg(def.variance[axis], def.avg_size[axis])
	# Is there not enough space to fit the new floor?
	if new_ta + card_thickness > max_ta:
		# "Penthouse" approach -- stretch the last floor to the top
		var last = args.d.r.p[axis].size()-1
		var og_length = args.d.r.l[axis][last]
		card_thickness = max_ta - new_ta + def.spacing[axis]
		args.d.r.l[axis][last] = og_length + card_thickness
	else:
		# Create another room like normal
		args.d.r.p[axis].append(new_ta)
		args.d.r.l[axis].append(card_thickness)
		args.d.r.c[axis] += 1
	# Prepare for the next floor
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

## Grid
# Create "aisles" going both directions
func perfect_grid(parent:Region, d:RegionVectors=null, const_axis:String=Y) -> RegionVectors:
	if d == null: d = new_region_vectors()
	var axis_1 = Axes.find_first(const_axis)
	var axis_2 = Axes.find_last(const_axis)
	
	aisles(parent, d, axis_1, const_axis, axis_2)
	aisles(parent, d, axis_2, const_axis, axis_1)
	
	return d

## Aisles
# Define parralel paths
func aisle_path(args:AlgArgs, debug:bool=false) -> float:
	var path_def = args.type.path
	var p = args.d.p
	var axis = args.axis
	var const_axis = args.const_axis
	var span_axis = args.span_axis
	
	var aisle_width = rand_from_avg(path_def.variance[axis], path_def.avg_size[axis])
	var size
	if args.end - args.ta < aisle_width:
		aisle_width = args.end - args.ta
		var r = args.d.r
		var last_pat:int = p.l[axis].size()-1
		var last_reg:int = r.p[axis].size()-1
		p.l[axis][last_pat][axis] += aisle_width
		r.p[axis][last_reg] += aisle_width
	else:
		var height = rand_from_avg(path_def.variance[const_axis], path_def.avg_size[const_axis])
		size = Axes.vector3([aisle_width, height, args.span_size], [axis, const_axis, span_axis])
		p.l[axis].append(size)
		var pos = Axes.vector3([args.ta], [axis])
		p.p[axis].append(pos)
		p.c[axis] += 1
	
	if debug: print("Path  \t",
		("%6.2f" % args.ta), " -> ", ("%6.2f" % (args.ta + aisle_width)), "\t",
		axis.to_upper(), "\t",
		("%6.2f" % aisle_width), "\t",
		size
	)
	return aisle_width

# Define parallel regions
func aisle_region(args:AlgArgs, debug:bool=NOBUG) -> float:
	var reg_def:RegionDef = args.type.region
	var r:RegionVector = args.d.r
	var axis:String = args.axis
	
	var region_length:float = rand_from_avg(reg_def.variance[axis], reg_def.avg_size[axis])
	if args.end - args.ta < region_length:
		region_length = args.end - args.ta
		var p = args.d.p
		var last_reg:int = r.l[axis].size()-1
		var last_pat:int = p.p[axis].size()-1
		r.l[axis][last_reg] += region_length
		p.p[axis][last_pat][axis] += region_length
	else:
		r.l[axis].append(region_length)
		r.p[axis].append(args.ta)
		r.c[axis] += 1
	
	if debug: print("%s\t" % args.parent.name,
		("%6.2f" % args.ta), " -> ", ("%6.2f" % (args.ta + region_length)), "\t",
		axis.to_upper(), "\t",
		("%6.2f" % region_length)
	)
	return region_length

# Define alternating parallel paths and regions
func aisles(parent:Region, d:RegionVectors=null, axis:String=X, const_axis:String=Y, span_axis:String=Z) -> RegionVectors:
	if d == null: d = new_region_vectors()
	
	var args = AlgArgs.new(parent, d)
	args.set_sizes(["span"],[parent.size[span_axis]])
	args.set_axes(["", "const", "span"], [axis, const_axis, span_axis])
	
	axis_loop(0, parent.size[axis], ["aisle_path", "aisle_region"], args)
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
