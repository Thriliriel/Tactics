extends Node

func json_read_map(nameFile):
	if not FileAccess.file_exists(nameFile):
		print("Not found!")
		return
	var file = FileAccess.open(nameFile, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	return data

func json_update_local_units(units):
	#idplayer idunit name hp movement attack defense skill speed magic resistence luck constitution idclass lvl onteam 	
	# Save data
	var file = FileAccess.open("localunits.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(units))
	file.close()
	
func json_get_local_units():
	#idplayer idunit name hp movement attack defense skill speed magic resistence luck constitution idclass lvl onteam 	
	# Save data
	var file = FileAccess.open("localunits.json", FileAccess.READ)
	var j = JSON.new()
	var data = j.parse(file.get_as_text())
	file.close()
	return j.get_data()
