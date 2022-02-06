extends Reference

class_name RegionDef

var spacing:Vector3 = Vector3(0.25, 0.25, 0.25)
var margins:Vector3 = Vector3.ONE * 0.5
var variance:Vector3 = Vector3(0.5, 0.5, 0.5)
var avg_size:Vector3 = Vector3(1, 1, 1)
var min_size:Vector3 = Vector3(1, 1, 1)
var type

func set_all(key:String, value):
	if typeof(self[key]) == typeof(value):
		self[key] = value
	elif self[key] is Vector3 and value is float:
		self[key] = Vector3(value, value, value)