extends Reference

class_name WorldDefs

var root_feature:String

var provinces:Dictionary
var counties:Dictionary
var cities:Dictionary
var districts:Dictionary
var neighborhoods:Dictionary
var paths:Dictionary
var structures:Dictionary
var floors:Dictionary
var rooms:Dictionary

var default_type:Dictionary
var default_region:Dictionary
var default_path:Dictionary
var default_decoration:Dictionary

var feature_keys:Array
var feature_hierarchy:Dictionary

func get_typeDef(ft_key:String=root_feature, t_key:String="") -> TypeDef:
	var feature:Dictionary = self[ft_key]
	if (t_key == ""):
		var keys = feature.keys()
		t_key = keys[(randi() % keys.size())]
	return feature[t_key]

func _init():
	parse_test_data()
	interpret()
	Files.log_to_file(Strings.string(self, "", true), "WorldDefs")

# Interpreting
func interpret():
	for f_key in feature_hierarchy.keys():
		var feature:Dictionary = self[f_key]
		for ft_key in feature.keys():
			var type:TypeDef = feature[ft_key]
			for r_key in feature_hierarchy[f_key].keys():
				var child_keys = feature_hierarchy[f_key][r_key]
				var region:RegionDef = type[r_key]
				var types:Array = []
				for t_key in region.types:
					for c_key in child_keys: 
						types.append(self[c_key][t_key])
				region.types = types

# Parsing

func parse_test_data():
	var td:TestData = TestData.new()
	root_feature = td.root_feature
	default_type = td.default_type
	default_region = td.default_region
	default_path = td.default_path
	default_decoration = td.default_decoration
	feature_keys = td.features.keys()
	feature_hierarchy = td.feature_hierarchy
	for f_key in td.features.keys():
		self[f_key] = parse_feature(td[f_key])

func parse_feature(feature:Dictionary) -> Dictionary:
	var feature_def:Dictionary = {}
	for type_name in feature.keys():
		feature_def[type_name] = parse_type(type_name, feature[type_name])
	return feature_def

func parse_type(name:String, type:Dictionary) -> TypeDef:
	var type_def:TypeDef = TypeDef.new()
	type_def.name = name
	if not type.empty():
		type_def.region = parse_region(default_region, type, "region")
		type_def.path = parse_region(default_path, type, "path")
		type_def.decoration = parse_region(default_decoration, type, "decoration")
		if type.has("class"): type_def.t_class = type.class
		else: type_def.t_class = default_type.class
		if type.has("color"): type_def.color = type.color
		else: type_def.color = default_type.color
		if type.has("algorithms"): type_def.algorithms = type.algorithms
		else: type_def.algorithms = default_type.algorithms
	return type_def

func parse_region(default_rd:Dictionary, type:Dictionary, rd_prop:String) -> RegionDef:
	var relative_rd:Dictionary = {}
	if (type.has(rd_prop)): relative_rd = type[rd_prop]
	var region_def:RegionDef = RegionDef.new()
	region_def.parse(default_rd)
	for prop in relative_rd.keys():
		var relative_value = relative_rd[prop]
		if (relative_value is Dictionary):
			var default_value = default_rd[prop]
			region_def[prop] = parse_prop(default_value, relative_value)
		else:
			region_def[prop] = relative_value
	return region_def

func parse_prop(default_values, relative_values:Dictionary) -> Dictionary:
	var final_values = default_values
	for key in relative_values.keys():
		final_values[key] = relative_values[key]
	return final_values
