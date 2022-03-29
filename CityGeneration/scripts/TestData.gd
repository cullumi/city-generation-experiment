extends Reference

class_name TestData

func ftm(value):
	return Convert.ft_to_m(value)

# Type Wrapping

var root_feature = "districts"

var features:Dictionary = {
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

var feature_hierarchy:Dictionary = {
	"provinces":		{"region":["counties"], 		"path":["paths"]},
	"counties":			{"region":["cities"], 			"path":["paths"]},
	"cities":			{"region":["districts"], 		"path":["paths"]},
	"districts":		{"region":["neighborhoods"], 	"path":["paths"]},
	"neighborhoods":	{"region":["structures"], 		"path":["paths"]},
	"structures":		{"region":["floors"], 			"path":["paths"]},
	"floors":			{"region":["rooms"], 			"path":["paths"]},
	"rooms":			{},
}


# Categories

var provinces =  {
	
}

var counties = {
	
}

var cities = {
	
}

var districts = {
	"big-city": {
		"region": {
			"variance": Vector3(0, 0, 0),
			"avg_size": Vector3(50, 100, 50),
			"types":["big-city", "small-city"],
		},
		"path": {
			"avg_size": ftm(Vector3(10,0.125,10)*2),
			"types":["avenue"],
		},
		"class": Region,
		"algorithms": ["cityscape"]
	}
}

var neighborhoods = {
	"big-city": {
		"region": {
			"avg_size": ftm(Vector3(18,45,18)*3*.5),
			"types": ["big-city"],
		},
		"path": {
			"avg_size": ftm(Vector3(5,0.125,5)*2),
			"types":["sidewalk"],
		},
		"class": NeighborhoodRegion,
		"algorithms": ["cityscape"],
	},
	"small-city": {
		"region": {
			"avg_size": ftm(Vector3(18,45,18)*3*.25),
			"types": ["big-city"],
		},
		"path": {
			"avg_size": ftm(Vector3(2.5,0.125,2.5)*2),
			"types":["dirtpath"],
		},
		"class": NeighborhoodRegion,
		"algorithms": ["cityscape"],
	}
}

var paths = {
	"sidewalk": {
		"class": PathRegion,
		"color": Color.gray,
	},
	"dirtpath": {
		"class": PathRegion,
		"color": Color.brown,
	},
	"avenue": {
		"class": PathRegion,
		"color": Color.darkgray,
	}
}

var structures = {
	"big-city": {
		"region": {
			"variance": {"y":0},
			"avg_size": {"y":ftm(8*1.5)},
			"types": ["big-city"]
		},
		"class": StructureRegion,
		"algorithms": ["skyscraper"]
	},
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
	"color": Color.white,
	"algorithms": [],
}

var default_region = {
	"spacing": Vector3.ONE * 0.5,
	"margins": Vector3.ONE * 0.5,
	"variance": Vector3.ONE * 0.5,
	"avg_size": Vector3.ONE,
	"min_size": Vector3.ONE,
	"types": [],
}

var default_path = {
	"spacing": Vector3.ONE * 0.5,
	"margins": Vector3.ONE * 0.5,
	"variance": Vector3(1, 0, 1) * 0.5,
	"avg_size": Vector3.ONE,
	"min_size": Vector3.ONE,
	"types": [],
}

var default_decoration = {
	"spacing": Vector3.ONE * 0.5,
	"margins": Vector3.ONE * 0.5,
	"variance": Vector3(1, 0, 1) * 0.5,
	"avg_size": Vector3.ONE,
	"min_size": Vector3.ONE,
	"types": [],
}
