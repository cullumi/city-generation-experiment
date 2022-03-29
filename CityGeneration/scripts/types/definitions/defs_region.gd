extends Defs

class_name RegionDefs

var region:RegionDef = RegionDef.new()
var path:RegionDef = RegionDef.new()
var decoration:RegionDef = RegionDef.new()

func parse(dict:Dictionary):
	for key in dict.keys():
		self[key] = dict[key]
