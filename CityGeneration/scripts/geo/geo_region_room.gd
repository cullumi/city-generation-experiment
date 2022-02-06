extends Region

class_name RoomRegion

func _init():
	name = "RoomRegion"

func generate():
	Count.increment("rooms")
	.generate()
	Count.increment("rooms_active", active)
