extends Reference

class_name TestData

func ftm(value):
	return Convert.ft_to_m(value)

# Type Wrapping

var root_feature = "neighborhoods"

var features = {
	"provinces":provinces,
	"counties":counties,
	"cities":cities,
	"districts":districts,
	"neighborhoods":neighborhoods,
	"paths":paths,
	"structures":structures,
	"floors":floors,
	"rooms":rooms,
}

var path_feature = "paths"
var feature_hierarchy = {
	"provinces":["counties"],
	"counties":["cities"],
	"cities":["districts"],
	"neighborhoods":["structures"],
	"structures":["floors"],
	"floors":["rooms"],
	"rooms":[],
}


# Categories

var provinces =  {
	
}

var counties = {
	
}

var cities = {
	
}

var districts = {
	
}

var neighborhoods = {
	"big-city": {
		"region": {
			"avg_size": ftm(Vector3(18,45,18)*3),
			"type": ["big-city"],
		},
		"path": {
			"avg_size": ftm(Vector3(10,0.125,10)*2),
			"types":["big-city"],
		},
		"class": NeighborhoodRegion,
		"algorithms": ["cityscape"]
	}
}

var paths = {
	"big-city": {
		"class": PathRegion
	}
}

var structures = {
	"big-city": {
		"region": {
			"variance": {"y":0},
			"avg_size": {"y":ftm(8*15)},
			"types": ["big-city"]
		},
		"class": StructureRegion,
		"algorithms": ["skyscraper"]
	}
}

var floors = {
	"big-city": {
		"region": {
			"types": ["big-city"]
		},
		"class": FloorRegion
	}
}

var rooms = {
	"big-city": {
		"class": RoomRegion
	}
}


# Defaults
# Notice: empty arrays correspond to "none". nulls correspond to "any".

var default_type = {
	"region": default_region,
	"path": default_path,
	"decoration": default_decoration,
	"class": Region,
	"algorithms": []
}

var default_region = {
	"spacing": Vector3.ONE * 0.5,
	"margins": Vector3.ONE * 0.5,
	"variance": Vector3.ONE * 0.5,
	"avg_size": Vector3.ONE,
	"min_size": Vector3.ONE,
	"types": null
}

var default_path = {
	"spacing": Vector3.ONE * 0.5,
	"margins": Vector3.ONE * 0.5,
	"variance": Vector3(1, 0, 1) * 0.5,
	"avg_size": Vector3.ONE,
	"min_size": Vector3.ONE,
	"types": null
}

var default_decoration = {
	"spacing": Vector3.ONE * 0.5,
	"margins": Vector3.ONE * 0.5,
	"variance": Vector3(1, 0, 1) * 0.5,
	"avg_size": Vector3.ONE,
	"min_size": Vector3.ONE,
	"types": null
}
