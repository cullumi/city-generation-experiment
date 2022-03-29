extends Reference

class_name ArrayVector3

var x:Array = []
var y:Array = []
var z:Array = []

func _to_string(indent:String=""):
	return "(%s,\n%s%s,\n%s%s)" % [
		String(x),
		indent, String(y),
		indent, String(z),
	]

func duplicate(deep:bool=false, d_type:GDScript=get_script()):
	var dup = d_type.new()
	if deep:
		dup.x = x.duplicate(deep)
		dup.y = y.duplicate(deep)
		dup.z = z.duplicate(deep)
	else:
		dup.x = x
		dup.y = y
		dup.z = z
	return dup

func mirror(axis:String=Axis.Y, deep:bool=false):
	var dup = duplicate(deep)
	var axes:Array = Axes.complement([axis])
	var ax1:String = self[axes[0]]
	var ax2:String = self[axes[1]]
	dup[axes[0]] = ax2
	dup[axes[1]] = ax1
	return dup
