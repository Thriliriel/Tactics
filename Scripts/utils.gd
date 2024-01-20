extends Node

func json_read_map(nameFile):
	if not FileAccess.file_exists(nameFile):
		print("Not found!")
		return
	var file = FileAccess.open(nameFile, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	return data
