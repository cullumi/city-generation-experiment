extends Reference

class_name AlgArgs

var parent:Region # The parent region
var d:RegionVectors # Definition for path and sub-region RegionVectors
var r:RegionVector # Definition for sub-region RegionVector
var type:TypeDef # Parameters for an entire feature type
var def:RegionDef # Parameters for a category of region (sub-region, path, decoration...)
var regions:Array # A list of Regions
var combiner:Node # The combiner to add new Regions to

var axis:String # Defines the primary axis
var const_axis:String # Defines the axis that should be unchanged or consistent
var span_axis:String # Defines the axis that should stretch as far as possible
var other_axis:String # Unused
var other1_axis:String # Unused
var other2_axis:String # Unused
var stack_axis:String # Used by stack alogorithm

var span_size:float # Used by aisle_path algorithm

var offset:float # Unused
var a:float # A start value for looping
var ta:float # A non-uniform counter used for distribution
var end:float # An end value for looping

# Initialize w/ parent and RegionVectors
func _init(new_parent:Region=null, new_d:RegionVectors=null):
	self.parent = new_parent
	self.d = new_d
	if new_parent:
		self.type = new_parent.type

# fills out type-related variables
func select_type(type_string:String):
	self.def = type[type_string]
	self.regions = parent[type_string+"s"]
	self.combiner = parent[type_string+"_combiner"]
	self.type = def.type

# Set any arguments
func set_args(aliases:Array=[], vals:Array=[], suffix:String=""):
	for i in range(0, aliases.size()):
		var alias = aliases[i]
		var val = vals[i]
		if alias != "":
			self[alias+suffix] = val
		else:
			self[suffix.trim_prefix("_")] = val

# Shortcut helpers for set_args
func set_axes(aliases:Array=[], axes:Array=[]):
	set_args(aliases, axes, "_axis")

func set_sizes(aliases:Array=[], vals:Array=[]):
	set_args(aliases, vals, "_size")
