extends Spatial

class_name Region

export (Vector3) var size = Vector3() setget set_size
var position:Vector3 = Vector3() setget set_position
var paths:Array = []
var regions:Array = []
var parent:Region = null
var sides:Array = [0, 0, 0, 0, 0, 0]
var connections:Array = []

enum SIDE { LEFT, BACK, RIGHT, FRONT, TOP, BOTTOM }

var combiner:CSGCombiner
var child_combiner:CSGCombiner
var path_combiner:CSGCombiner

func _enter_tree():
	combiner = CSGCombiner.new()
	combiner.name = "Combiner"
	combiner.use_collision = true
	add_child(combiner)
	child_combiner = CSGCombiner.new()
	child_combiner.name = "Child Combiner"
	child_combiner.use_collision = false
	combiner.add_child(child_combiner)
	path_combiner = CSGCombiner.new()
	path_combiner.name = "Path Combiner"
	path_combiner.use_collision = false
	combiner.add_child(path_combiner)

func set_position(new_position:Vector3):
	position = new_position
	translation = new_position

func set_size(new_size:Vector3):
	size = new_size

func generate():
	for region in regions:
		region.generate()
	for path in paths:
		path.generate()

static func rand_from_avg(variance, avg):
	var off = fmod(randf(), variance)
	return avg * (1 + off)
