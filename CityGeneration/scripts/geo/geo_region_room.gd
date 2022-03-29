extends Region

class_name RoomRegion

func _init(_new_type:TypeDef=null):
	name = "Room"

func generate():
	Count.increment("rooms")
	.generate()
	Count.increment("rooms_active", active)
