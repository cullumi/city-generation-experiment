
extends Region

class_name NeighborhoodRegion

func _init(new_defs):
	name = "NeighborhoodRegion"
	defs = new_defs

func generate():
	.generate()
