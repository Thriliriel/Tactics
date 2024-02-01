extends Node2D

signal charge

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		#if being targeted as target for an attack
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() && not event.is_echo():
				#emit signal
				charge.emit()
