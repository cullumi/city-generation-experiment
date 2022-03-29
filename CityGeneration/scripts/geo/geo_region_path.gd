extends Region

class_name PathRegion

var body:CSGBox

func _init(_new_type:TypeDef=null):
	name = "Path"

func _enter_tree():
	body = add_csg_box("body")
	set_active(true, [LOCAL])

func generate():
	Count.increment("paths")
	align_box(body, size/2)
	body.material = SpatialMaterial.new()
	body.material.albedo_color = type.color
	.generate()
	Count.increment("paths_active", active)
