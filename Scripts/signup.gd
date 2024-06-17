extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$LoginAlert.hide()

func _on_back_pressed():
	#go back to the menu scene
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_register_pressed():
	var email = $Email.text
	var userName = $User.text
	var password = $Password.text
	$Request.SignUp(email, userName, password)


func _on_request_signed_up(code):
	#if nope, nope
	#print(code)
	if int(code) != 42:
		$LoginAlert.show()
		#start the timer (so the alert vanishes after a time)
		$AlertTimer.start()
	else:
		#go back to the menu scene
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		
#alert vanishes
func _on_alert_timer_timeout():
	$LoginAlert.hide()
