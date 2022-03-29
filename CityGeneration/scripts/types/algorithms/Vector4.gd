extends Reference

class_name Vector4

var x:float = 0
var y:float = 0
var z:float = 0
var t:float = 0

func _to_string():
	return "(%6.2f, %6.2f, %6.2f, %6.2f)" % [x, y, z, t]

func duplicate(_deep:bool=false, d_type:GDScript=Vector4):
	var dup = d_type.new()
	dup.x = x
	dup.y = y
	dup.z = z
	return dup

func mirror(axis:String=Axis.Y, _deep:bool=false):
	var dup = duplicate(false)
	var axes:Array = Axes.complement([axis])
	var ax1:String = self[axes[0]]
	var ax2:String = self[axes[1]]
	dup[axes[0]] = ax2
	dup[axes[1]] = ax1
	return dup
