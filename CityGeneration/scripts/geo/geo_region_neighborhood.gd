extends Region

class_name NeighborhoodRegion

func _init():
	defs.set_all("variance", 0.5)
	defs.path.variance.y = Convert.ft_to_m(0)
	defs.path.type = PathRegion
	defs.path.avg_size.y = Convert.ft_to_m(0.25)
	defs.path.avg_size.x = Convert.ft_to_m(10)
	defs.path.avg_size.z = Convert.ft_to_m(10)
	defs.region.type = StructureRegion
	defs.region.avg_size.y = Convert.ft_to_m(45)
	defs.region.avg_size.x = Convert.ft_to_m(18)
	defs.region.avg_size.z = Convert.ft_to_m(18)

func generate():
	RegionAlgorithms.cityscape(self)
	.generate()
	
#	var d = {
#		"s": {	"c": { "x":0, "z":0 },
#				"p": { "x":[], "z":[] },
#				"l": { "x":[], "z":[] }, },
#		"p": {	"c": { "x":0, "z":0 },
#				"p": { "x":[], "z":[] },
#				"s": { "x":[], "z":[] }, }
#	}
#
#	var x:int = 0
#	while (x < size.x):
#		var tx = x
#		var path_width = rand_path_width()
#		d.p.s.x.append(Vector3(path_width, path_height, size.z))
#		d.p.p.x.append(tx)
#		d.p.c.x += 1
#		tx += path_width
#		var struct_length = rand_struct_length()
#		d.s.l.x.append(struct_length)
#		d.s.p.x.append(tx)
#		d.s.c.x += 1
#		x = tx + struct_length
#
#	var z:int = 0
#	while (z < size.z):
#		var tz = z
#		var path_width = rand_path_width()
#		d.p.s.z.append(Vector3(size.x, path_height, path_width))
#		d.p.p.z.append(z)
#		d.p.c.z += 1
#		tz += path_width
#		var struct_length = rand_struct_length()
#		d.s.l.z.append(struct_length)
#		d.s.p.z.append(tz)
#		d.s.c.z += 1
#		z = tz + struct_length
#
#	# Create & Arrange Pieces
#
#	for xx in range(0, d.s.c.x-1):
#		for zz in range(0, d.s.c.z-1):
#			var struct = StructureRegion.new()
#			regions.append(struct)
#			child_combiner.add_child(struct)
#			var height = rand_struct_height()
#			struct.set_size(Vector3(d.s.l.x[xx], height, d.s.l.z[zz]))
#			struct.set_position(Vector3(d.s.p.x[xx], 0, d.s.p.z[zz]))
#
#	for xx in range(0, d.p.c.x):
#		var path = PathRegion.new()
#		paths.append(path)
#		path_combiner.add_child(path)
#		path.set_size(d.p.s.x[xx])
#		path.set_position(Vector3(d.p.p.x[xx], 0, 0))
#
#	for zz in range(0, d.p.c.z):
#		var path = PathRegion.new()
#		paths.append(path)
#		path_combiner.add_child(path)
#		path.set_size(d.p.s.z[zz])
#		path.set_position(Vector3(0, 0, d.p.p.z[zz]))
