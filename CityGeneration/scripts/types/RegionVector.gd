extends Object

class_name RegionVector

var c: Vector4 = Vector4.new() # Per-Axis Counts
var p: ArrayVector3 = ArrayVector3.new() # Per-Axis Position Arrays
var l: ArrayVector3 = ArrayVector3.new() # Per-Axis Length Arrays

func _to_string():
	return 	"[c:	" + c.to_string() + "	]\n[p:	" + p.to_string() + "	]\n[l:	" + l.to_string() + "	]"
