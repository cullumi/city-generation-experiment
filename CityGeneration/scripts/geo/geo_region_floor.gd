extends Region

class_name FloorRegion

var body:CSGBox

func _init():
	name = "FloorRegion"
	defs.region.type = RoomRegion

#func _enter_tree():
#	body = add_csg_box()
#	body.operation = CSGShape.OPERATION_SUBTRACTION
#	set_active(true, [LOCAL])

func generate():
	Count.increment("floors")
#	body.translation.x = size.x / 2
#	body.translation.y = size.y / 2
#	body.translation.z = size.z / 2
#	body.width = size.x
#	body.height = size.y
#	body.depth = size.z
#	body.material = SpatialMaterial.new()
#	body.material.albedo_color = Color.red
	.generate()
	Count.increment("floors_active", active)
