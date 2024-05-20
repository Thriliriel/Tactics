extends Node

#web service link
var webservicelink = "http://127.0.0.1:5000/"

signal logged (json)
signal signedUp (code)

func SignUp(email, user, password):
	var text = {"email": [email], "user": [user], "password": [password]}
	var json = JSON.stringify(text)
	#print("GO!!")
	$WebRequest.request_completed.connect(_on_signup_completed)
	$WebRequest.request(webservicelink+"signup", ["Authorization: rendervouz", "Content-Type: application/json"], HTTPClient.METHOD_POST, json)
	#print("Sent!!")

func _on_signup_completed(result, response_code, headers, body):
	#print("BACK!!")
	var json = JSON.parse_string(body.get_string_from_utf8())
	var jsonOBJ = toJson(json)
	var code = jsonOBJ.resultCode
	
	#return the signal with the code
	signedUp.emit(code)

func Login(user, password):
	var text = {"user": [user], "password": [password]}
	var json = JSON.stringify(text)
	#print("GO!!")
	$WebRequest.request_completed.connect(_on_login_completed)
	$WebRequest.request(webservicelink+"login", ["Authorization: rendervouz", "Content-Type: application/json"], HTTPClient.METHOD_POST, json)
	#print("Sent!!")

func _on_login_completed(result, response_code, headers, body):
	#print("BACK!!")
	var json = JSON.parse_string(body.get_string_from_utf8())
	#print(json)
	logged.emit(toJson(json))

func UpdateLocalUnitFile():
	var user = "thriliriel"
	var text = {"user": [user]}
	var json = JSON.stringify(text)
	#print("GO!!")
	$WebRequest.request_completed.connect(_on_updatelocalunitfile_completed)
	$WebRequest.request(webservicelink+"updateLocalFiles", ["Authorization: rendervouz", "Content-Type: application/json"], HTTPClient.METHOD_POST, json)
	#print("Sent!!")

func _on_updatelocalunitfile_completed(result, response_code, headers, body):
	#print("BACK!!")
	var json = JSON.parse_string(body.get_string_from_utf8())
	var jsonOBJ = toJson(json)
	var allUnits = jsonOBJ.result["1"]
	#print(allUnits)
	#idplayer idunit name hp movement attack defense skill speed magic resistence luck constitution idclass lvl onteam
	var pretty = {}
	for un in allUnits:
		var assemble = {}
		assemble["idplayer"] = un[0]
		assemble["idunit"] = un[1]
		assemble["name"] = un[2]
		assemble["hp"] = un[3]
		assemble["movement"] = un[4]
		assemble["attack"] = un[5]
		assemble["defense"] = un[6]
		assemble["skill"] = un[7]
		assemble["speed"] = un[8]
		assemble["magic"] = un[9]
		assemble["resistence"] = un[10]
		assemble["luck"] = un[11]
		assemble["constitution"] = un[12]
		assemble["idclass"] = un[13]
		assemble["lvl"] = un[14]
		assemble["onteam"] = un[15]
		pretty[pretty.size()] = assemble
		
	Utils.json_update_local_units(pretty)
	
	#var teste = Utils.json_get_local_units()
	#print(teste["0"])
	
func toJson(stuff):
	var json_object = JSON.new()
	#print(stuff)
	var parse_err = json_object.parse(stuff)
	#print(parse_err)
	return json_object.get_data()
