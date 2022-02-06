extends Reference

class_name ArrayVector3

var x:Array = []
var y:Array = []
var z:Array = []

func to_string():
	return "(["+String(x)+"]\n		["+String(y)+"]\n		["+String(z)+"])"
