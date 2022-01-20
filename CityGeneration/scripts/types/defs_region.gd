extends Object

class_name RegionDefs

var region:RegionDef = RegionDef.new()
var path:RegionDef = RegionDef.new()

func set_all(key:String, value):
	region.set_all(key, value)
	path.set_all(key, value)

func set_all_on(def:String, key:String, value):
	self[def].set_all(key, value)
