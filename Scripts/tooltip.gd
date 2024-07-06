extends Node2D

var totalSize: Vector2
var initialPosition: Vector2
var referencePosition: Vector2

func _ready():
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = Color.DIM_GRAY
	$Label.add_theme_stylebox_override("normal", new_sb)
	totalSize = get_viewport().get_visible_rect().size
	#print(get_viewport().get_visible_rect().size)
	#print($Label.size)
	#print(initialPosition)
	#print(referencePosition)
	#if tooltip goes beyong the boundaries, adjust
	if initialPosition.y + referencePosition.y + $Label.size.y > totalSize.y:
		#print("aaa")
		$Label.position.y =  totalSize.y - initialPosition.y - referencePosition.y - $Label.size.y
	#get_global_mouse_position()

func DrawTooltip(refPosition, unit, text):	
	initialPosition = unit.position
	referencePosition = refPosition
	#create new label
	#$Label.position.x = initialPos.x
	#$Label.position.y = initialPos.y
	$Label.text = text
