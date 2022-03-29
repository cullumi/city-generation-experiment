extends Region

class_name FloorRegion

var body:CSGBox

func _init():
	name = "Floor"

#func _enter_tree():
#	body = add_csg_box("body")
#	set_active(false, [LOCAL])
#	body.use_collision = false
#	body.material = SpatialMaterial.new()
#	body.material.albedo_color = Color.green
#	body.material.albedo_color.a *= 0.5
#	body.material.flags_transparent = true

func generate():
	Count.increment("floors")
#	align_box(body)
	.generate()
	Count.increment("floors_active", active)
