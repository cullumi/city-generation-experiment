extends Def

class_name RegionDef

var spacing:Vector3 = Vector3(0.25, 0.25, 0.25)
var margins:Vector3 = Vector3.ONE * 0.5
var variance:Vector3 = Vector3(0.5, 0.5, 0.5)
var avg_size:Vector3 = Vector3(1, 1, 1)
var min_size:Vector3 = Vector3(1, 1, 1)
var types:Array
var vectors:Array = ["spacing", "margins", "variance", "avg_size", "min_size"]

func random_type():
	return types[randi() % types.size()]

func mirror_vector(vector:Vector3, axis:String=Axis.Y):
#	var dup = duplicate(false)
	var axes:Array = Axes.complement([axis])
	var ax1:float = vector[axes[0]]
	var ax2:float = vector[axes[1]]
	vector[axes[0]] = ax2
	vector[axes[1]] = ax1
	return vector

func mirror(axis:String=Axis.Y, deep:bool=false):
	var dup = duplicate(deep)
	for vector in vectors:
		dup.mirror_vector(self[vector], axis)
	return dup
