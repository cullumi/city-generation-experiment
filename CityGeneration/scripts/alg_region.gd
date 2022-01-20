extends Object

class_name RegionAlgorithms


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


# Routines
static func cityscape(parent:Region):
	var d = new_region_vectors()
	perfect_grid(parent, d)
	create_horizontal(parent, parent.defs.region.type, d.r)
	create_spans(parent, parent.defs.path.type, d.p)
	roughen_surface(parent.defs.region, parent.regions, Y)	


# Create Sub Regions

static func create_horizontal(parent:Region, type, r:RegionVector):
	print("Create Split: ", r.c.x, " / ", r.c.y, " / ", r.c.z)
	print(r)
	for xx in range(0, r.c.x):
		for zz in range(0, r.c.z):
			var region = type.new()
			parent.regions.append(region)
			parent.child_combiner.add_child(region)
			region.set_size(Vector3(r.l.x[xx], 1, r.l.z[zz]))
			region.set_position(Vector3(r.p.x[xx], 0, r.p.z[zz]))

static func create_spans(parent:Region, type, r:RegionVector):
	create_span(parent, type, r, X)
	create_span(parent, type, r, Y)
	create_span(parent, type, r, Z)

static func create_span(parent:Region, type, r:RegionVector, axis:String):
	for aa in range(0, r.c[axis]):
		var region = type.new()
		parent.regions.append(region)
		parent.path_combiner.add_child(region)
		region.set_size(r.l[axis][aa])
		region.set_position(r.p[axis][aa])


# Algorithm Helpers

static func rand_from_avg(variance, avg):
	if (variance == 0):
		return avg
	else:
		return avg + (avg * fmod(randf(), variance))


### Algorithms

# Grid
static func perfect_grid(parent:Region, d:RegionVectors=null) -> RegionVectors:
	if d == null: d = new_region_vectors()
	aisles(parent, X, Y, Z, d)
	aisles(parent, Z, Y, X, d)
	return d

# RoughSurface
static func roughen_surface(def:RegionDef, regions:Array, axis:String):
	for region in regions:
		region.size[axis] *= rand_from_avg(def.variance[axis], def.avg_size[axis])

# Aisles
static func aisle_path(parent:Region, offset:float, p:RegionVector, path_def:RegionDef, axis:String, const_axis:String, span_axis:String) -> float:
	var aisle_width = rand_from_avg(path_def.variance[axis], path_def.avg_size[axis])
	var size = Vector3()
	size[axis] = aisle_width
	size[const_axis] = rand_from_avg(path_def.variance[const_axis], path_def.avg_size[const_axis])
	size[span_axis] = parent.size[span_axis]
	p.l[axis].append(size)
	var pos = Vector3()
	pos[axis] = offset
	p.p[axis].append(pos)
	p.c[axis] += 1
	return aisle_width

static func aisle_region(offset:float, r:RegionVector, reg_defs:RegionDef, axis:String) -> float:
	var region_length = rand_from_avg(reg_defs.variance[axis], reg_defs.avg_size[axis])
	r.l[axis].append(region_length)
	r.p[axis].append(offset)
	r.c[axis] += 1
	return region_length

static func aisles(parent:Region, axis:String, const_axis:String, span_axis:String, d:RegionVectors=null) -> RegionVectors:
	if d == null: d = new_region_vectors()
	var defs:RegionDefs = parent.defs
	var a:int = 0
	while (a < parent.size[axis]):
		var ta = a
		ta += aisle_path(parent, ta, d.p, defs.path, axis, const_axis, span_axis)
		a = ta + aisle_region(ta, d.r, defs.region, axis)
	d.r.c.y = 1
	return d
