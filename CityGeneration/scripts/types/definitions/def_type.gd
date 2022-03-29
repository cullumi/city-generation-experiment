extends Defs

class_name TypeDef

var name:String
var region:RegionDef
var path:RegionDef
var decoration:RegionDef
var t_class:GDScript
var color:Color
var algorithms:Array

func new_instance():
	var new_region:Object = t_class.new()
	new_region.type = self
	return new_region

func mirror(axis:String=Axis.Y, deep:bool=false):
	var dup = duplicate(deep)
	for def in dup.defs:
		print(def)
		dup[def].mirror(axis, deep)
	return dup
