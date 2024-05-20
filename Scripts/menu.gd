extends Control

func _ready():
	$LoginAlert.hide()

func login():
	var login = $User.text
	var password = $Password.text
	#print(login, password)
	$Request.Login(login, password)

func _on_request_logged(json):
	#if nope, nope
	if json.resultCode != 42:
		$LoginAlert.show()
		#start the timer (so the alert vanishes after a time)
		$AlertTimer.start()
	else:
		#set player values
		Playervariables.playerId = int(json.result['0'])
		Playervariables.playerName = str(json.result['1'])
		#go to the choice scene
		get_tree().change_scene_to_file("res://Scenes/choice.tscn")

#alert vanishes
func _on_alert_timer_timeout():
	$LoginAlert.hide()

func _on_signup_pressed():
	#go to the signup scene
	get_tree().change_scene_to_file("res://Scenes/signup.tscn")
