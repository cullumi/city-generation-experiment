extends Object

class_name Files

static func log_to_file(string:String, file_name:String="out"):
	var file = File.new()
	file.open("res://logs/" + file_name + ".log", File.WRITE)
	file.store_string(string)
	file.close()
