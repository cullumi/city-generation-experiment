extends Reference

class_name RegionVector

var c: Vector4 = Vector4.new() # Per-Axis Counts
var p: ArrayVector3 = ArrayVector3.new() # Per-Axis Position Arrays
var l: ArrayVector3 = ArrayVector3.new() # Per-Axis Length Arrays

func _to_string(indent:String=""):
	return "%sc: %s\n%sp: %s\n%sl: %s" % [
		indent, c._to_string(),
		indent, p._to_string(indent+"\t"),
		indent, l._to_string(indent+"\t"),
	]

func duplicate(deep:bool=false, d_type:GDScript=RegionVector):
	var dup:RegionVector = d_type.new()
	if (deep):
		dup.c = c.duplicate(deep)
		dup.p = p.duplicate(deep)
		dup.l = l.duplicate(deep)
	else:
		dup.c = c
		dup.p = p
		dup.l = l
	return dup

func mirror(axis:String=Axis.Y, deep:bool=false):
	var dup = duplicate(false)
	dup.c.mirror(axis, deep)
	dup.p.mirror(axis, deep)
	dup.l.mirror(axis, deep)
	return dup
