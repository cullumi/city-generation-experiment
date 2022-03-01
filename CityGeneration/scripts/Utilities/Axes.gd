extends Reference

class_name Axes

static func all_axes() -> Array:
	return [Axis.X, Axis.Y, Axis.Z]

static func find_first(axis) -> String:
	var arr = all_axes()
	arr.erase(axis)
	return arr.pop_front()

static func find_last(axis) -> String:
	var arr = all_axes()
	arr.erase(axis)
	return arr.pop_back()

static func find_one(axis1, axis2) -> String:
	var arr = all_axes()
	arr.erase(axis1)
	arr.erase(axis2)
	return arr.pop_front()

static func complement(axes:Array) -> Array:
	var arr = all_axes()
	for axis in axes:
		arr.erase(axis)
	return arr

static func vals_from(vector, axes:Array=all_axes()) -> Array:
	var arr:Array = []
	for axis in axes:
		arr.append(vector[axis])
	return arr

static func copy_to(src_vector, dst_vector, axes:Array=all_axes()) -> Vector3:
	for axis in axes:
		dst_vector[axis] = src_vector[axis]
	return dst_vector

static func vector3(vals:Array, axes=all_axes(), debug:bool=false) -> Vector3:
	var vector = Vector3()
	for a in range(0, vals.size()):
		vector[axes[a]] = vals[a]
	if debug: print(vals, " -> ", vector, "\t", axes)
	return vector
