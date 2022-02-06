extends Region

class_name PathRegion

var body:CSGBox

func _enter_tree():
	body = CSGBox.new()
	body.use_collision = true
	local_combiner.add_child(body)
	locals.append(body)
	set_active(true, [LOCAL])

func generate():
	Count.increment("paths")
	body.translation.x = size.x / 2
	body.translation.y = size.y / 2
	body.translation.z = size.z / 2
	body.width = size.x
	body.height = size.y
	body.depth = size.z
	body.material = SpatialMaterial.new()
	body.material.albedo_color = Color.brown
	.generate()
	Count.increment("paths_active", active)
