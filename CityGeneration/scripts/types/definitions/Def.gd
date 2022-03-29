extends DupReference

class_name Def

func set_all(key:String, value):
	if typeof(self[key]) == typeof(value):
		self[key] = value
	elif self[key] is Vector3 and value is float:
		self[key] = Vector3(value, value, value)

func parse(dict:Dictionary):
	for key in dict.keys():
		self[key] = dict[key]
