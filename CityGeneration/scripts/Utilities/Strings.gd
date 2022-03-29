extends Node

class_name Strings

static func string(value, indent:String="", debug:bool=false) -> String:
	var res = ""
	if value is String:
		res = value
		dprint(res, debug)
	elif value is Object:
		res = object_string(value, indent, debug)
	elif value is Dictionary:
		res = dict_string(value, value.keys(), indent, debug)
	elif value != null:
		res = String(value)
		dprint(res, debug)
	return res

static func script_vars(object):
	var props = object.get_property_list()
	var names:Array = []
	for prop in props:
		if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			names.append(prop.name)
	return names

static func object_string(object:Object, indent:String="", debug:bool=false):
	var string:String = "(" + object.to_string() + ")\n"
	var names = script_vars(object)
	dprint(string, debug)
	string += dict_string(object, names, indent, debug)
	return string

static func dict_string(dict, keys:Array, indent:String="", debug:bool=false) -> String:
	var string:String = "(Dictionary)\n" if dict is Dictionary else ""
	indent += "\t"
	var i:int = 1
	var newline = "\n"
	for key in keys:
		if (dict[key] is Dictionary or dict[key] is Object):
			string += sub_dict_string(dict, key, indent, newline, debug)
		else:
			string += sub_string(dict, key, indent, newline, debug)
		i += 1
		if (i == keys.size()):
			newline = ""
	return string

static func sub_string(dict, key:String, indent:String="", newline:String="\n", debug:bool=false) -> String:
	var string:String = indent + key + ": "
	dprint(string, debug)
	string += string(dict[key], indent, debug)
	dprint(newline, debug)
	string += newline
	return string

static func sub_dict_string(dict, key:String, indent:String="", newline:String="\n", debug:bool=false) -> String:
	var string:String = ""
	dict = dict[key]
	string += indent + key + ": "
	dprint(string, debug)
	var res = string(dict, indent, debug)
	if (dict is Dictionary):
		newline = ""
	string += res + newline
	dprint(newline, debug)
	return string

static func dprint(content, debug:bool=false):
	if debug: printraw(content)
