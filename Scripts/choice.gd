extends Control

func _ready():
	$Playername.text += Playervariables.playerName

func _on_signout_pressed():
	#clear player info
	Playervariables.playerId = 0
	Playervariables.playerName = ''
	
	#go back to the menu scene
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_playbutton_pressed():
	#go to the game scene
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
