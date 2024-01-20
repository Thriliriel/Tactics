extends CanvasLayer

#when player cancel the movement of the unit
signal cancelPress
#when player finishes to movement the unit
signal waitPress

#unit which opened the panel
var unitPanel: Node2D

func _on_cancel_button_pressed():
	cancelPress.emit(unitPanel)


func _on_wait_button_pressed():
	waitPress.emit()
