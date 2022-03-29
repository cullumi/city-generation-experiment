
extends Region

class_name NeighborhoodRegion

var body:CSGBox

func _init(_new_type:TypeDef=null):
	name = "Neighborhood"

#func _enter_tree():
#	body = add_csg_box("body")
#	set_active(false, [LOCAL])
#	body.use_collision = false
#	body.material = SpatialMaterial.new()
#	body.material.albedo_color = Color.red
#	body.material.albedo_color.a *= 0.5
#	body.material.flags_transparent = true

func generate():
#	self.position.y += size.y/2
#	default_offset = Vector3(0, size.y/2, 0)
#	align_box(body)
	.generate()
