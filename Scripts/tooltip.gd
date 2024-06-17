extends Node2D

func _ready():
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = Color.DIM_GRAY
	$Label.add_theme_stylebox_override("normal", new_sb)

func DrawTooltip(initialPos, text):
	#create new label
	#$Label.position.x = initialPos.x
	#$Label.position.y = initialPos.y
	$Label.text = text
