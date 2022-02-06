extends Region

class_name NeighborhoodRegion

func _init():
	name = "NeighborhoodRegion"
	defs.set_all("variance", 0.5)
	defs.path.variance.y = 0
	defs.path.type = PathRegion
	defs.path.avg_size.y = Convert.ft_to_m(0.25)
	defs.path.avg_size.x = Convert.ft_to_m(10*2)
	defs.path.avg_size.z = Convert.ft_to_m(10*2)
	defs.region.type = StructureRegion
	defs.region.avg_size.y = Convert.ft_to_m(45*3)
	defs.region.avg_size.x = Convert.ft_to_m(18*3)
	defs.region.avg_size.z = Convert.ft_to_m(18*3)

func generate():
	var result = RegionAlgorithms.cityscape(self)
	if (result is GDScriptFunctionState):
		result = yield(result, "completed")
#	RegionAlgorithms.verticalcity(self)
	.generate()
