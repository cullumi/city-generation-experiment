extends Reference

class_name DupReference

func duplicate(deep:bool, d_type=get_script()):
	print(d_type)
	var dup = d_type.new()
	var properties:Array = get_property_list()
	for prop in properties:
		if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			if (prop.name != "defs"):
				var val = self[prop.name]
				if deep and val is Object and val.has_method("duplicate"):
					dup[prop.name] = val.duplicate(deep)
				else:
					dup[prop.name] = self[prop.name]
	return dup

#func get_property_list() -> Array:
#	return .get_property_list()
