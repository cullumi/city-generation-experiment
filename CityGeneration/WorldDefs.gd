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


func _init():
	parse_test_data()
	interpret_features()


# Interpreting

func interpret_features():
	pass


# Parsing

func parse_test_data():
	var td:TestData = TestData.new()
	root_feature = td.root_feature
	default_type = td.default_type
	default_region = td.default_region
	default_path = td.default_path
	default_decoration = td.default_decoration
	for feature_key in td.keys():
		parse_feature(feature_key, td[feature_key])
		

func parse_feature(feat_key:String, feature:Dictionary):
	for type_key in feature.keys():
		parse_type(feat_key, type_key, feature[type_key])

func parse_type(feat_key:String, type_key:String, type:Dictionary):
	var type_def = default_type
	if not type.empty():
		default_type.duplicate(false)
		parse_type_region(type_def, "region", type)
		parse_type_region(type_def, "path", type)
		parse_type_region(type_def, "decoration", type)
		if type.has("class"): type_def.class = type.class
		if type.has("algorithms"): type_def.algorithms = type.algorithms
	self[feat_key] = type_def

func parse_type_region(type_def:Dictionary, tr_key:String, type:Dictionary):
	if not type.has(tr_key): return
	var tr:Dictionary = type[tr_key]
	type_def[tr_key] = type_def[tr_key].duplicate()
	for value_key in tr.keys():
		if (tr[value_key is Dictionary]):
			parse_region_value(type_def[tr_key], value_key, tr)
		else:
			type_def[tr_key][value_key] = tr[value_key]

func parse_region_value(type_region_def:Dictionary, v_key:String, type_region:Dictionary):
	var def_val = type_region_def[v_key]
	var rel_vals:Dictionary = type_region[v_key]
	for rel_key in rel_vals.keys():
		def_val[rel_key] = rel_vals[rel_key]
	type_region_def[v_key] = def_val
