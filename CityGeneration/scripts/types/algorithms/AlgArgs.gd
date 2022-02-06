extends Reference

class_name AlgArgs

var parent:Region
var d:RegionVectors
var r:RegionVector
var defs:RegionDefs
var def:RegionDef
var regions:Array
var combiner:Node
var type

var axis:String
var const_axis:String
var span_axis:String
var other_axis:String
var other1_axis:String
var other2_axis:String
var stack_axis:String

var span_size:float

var offset:float
var a:float
var ta:float
var end:float

func _init(new_parent:Region=null, new_d:RegionVectors=null):
	self.parent = new_parent
	self.d = new_d
	if new_parent:
		self.defs = new_parent.defs

func select_type(type_string:String):
	self.def = defs[type_string]
	self.regions = parent[type_string+"s"]
	self.combiner = parent[type_string+"_combiner"]
	self.type = def.type

func set_args(aliases:Array=[], vals:Array=[], suffix:String=""):
	for i in range(0, aliases.size()):
		var alias = aliases[i]
		var val = vals[i]
		if alias != "":
			self[alias+suffix] = val
		else:
			self[suffix.trim_prefix("_")] = val

func set_axes(aliases:Array=[], axes:Array=[]):
	set_args(aliases, axes, "_axis")

func set_sizes(aliases:Array=[], vals:Array=[]):
	set_args(aliases, vals, "_size")
