extends Reference

class_name Side

enum {LEFT, RIGHT, UP, DOWN, FORWARD, BACKWARD}
const all_sides = [LEFT, RIGHT, UP, DOWN, FORWARD, BACKWARD]
const hor_sides = [LEFT, RIGHT, FORWARD, BACKWARD]
const vert_sides = [UP, DOWN]
const for_sides = [FORWARD, BACKWARD]
const str_sides = [LEFT, RIGHT]
const dirs = [1, -1, 1, -1, 1, -1]
const axes = [Axis.X, Axis.X, Axis.Y, Axis.Y, Axis.Z, Axis.Z]

var dir:int
var axis:String

func _init(num_dir:int=FORWARD, new_axis:String=""):
	if new_axis == "":
		dir = dirs[num_dir]
		axis = axes[num_dir]
	else:
		dir = num_dir
		axis = new_axis

#static func Left(): return Side.new(LEFT)
#static func Right(): return Side.new(RIGHT)
#static func Up(): return Side.new(UP)
#static func Down(): return Side.new(DOWN)
#static func Forward(): return Side.new(FORWARD)
#static func Backward(): return Side.new(BACKWARD)
