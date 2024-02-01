extends Node2D

#size of the map
var mapSize = Vector2i(10,10)
#size of each block
var blockSize = Vector2(0,0)
#json filename
var jsonFileName = "clearMap.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	json_create_map()

func json_create_map():
	var dict = {}
	
	#iterate
	for i in range(0, mapSize.x):
		var row = []
		for j in range(0, mapSize.y):
			row.append(0)
		
		dict["Row"+str(i)] = row
	
	#print(dict)
	
	var json_string = JSON.stringify(dict, "", false)
	#print(json_string)
	# Save data
	var file = FileAccess.open(jsonFileName, FileAccess.WRITE)
	file.store_string(json_string)
	file.close() 
