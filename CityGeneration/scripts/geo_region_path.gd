extends Region

class_name PathRegion

var body:CSGBox

func _enter_tree():
	body = CSGBox.new()
#	body.use_collision = true
	combiner.add_child(body)

func generate():
	body.translation.x = size.x / 2
	body.translation.y = size.y / 2
	body.translation.z = size.z / 2
	body.width = size.x
	body.height = size.y
	body.depth = size.z
	.generate()
