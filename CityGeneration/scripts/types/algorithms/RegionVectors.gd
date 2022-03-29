extends Reference

class_name RegionVectors

var r:RegionVector = RegionVector.new() # sub-regions
var p:RegionVector = RegionVector.new() # paths

func _to_string():
	return "{\n\tregion:\n%s\n\tpath:\n%s\n}" % [r._to_string("\t\t"), p._to_string("\t\t")]

func duplicate(deep:bool=false, d_type:GDScript=RegionVectors):
	var dup:RegionVectors = d_type.new()
	if deep:
		dup.r = r.duplicate(deep)
		dup.p = p.duplicate(deep)
	else:
		dup.r = r
		dup.p = p
	return dup

func mirror(axis:String=Axis.Y, deep:bool=false):
	var dup = duplicate(true)
	dup.r.mirror(axis, deep)
	dup.p.mirror(axis, deep)
	return dup
