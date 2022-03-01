extends Reference

class_name Defs

var defs:Array = []

func _init():
	var properties:Array = get_property_list()
	for prop in properties:
		if prop.type == typeof(Def) and prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			defs.append(prop.name)

func set_all(key:String, value):
	for def in defs:
		self[def].set_all(key, value)

func set_all_on(def:String, key:String, value):
	self[def].set_all(key, value)
