extends Sprite2D

# node terrain type
# 0 = free (default)
# 1 = water
# 2 = mountain
# 3 = hill
# 4 = swamp
# 9 = wall - cannot pass
var terrainType = 0
#unit in the node
var unit: Node2D
#node index
var nodeIndex: int

#can be clicked?
var canClick = false
#unit clicked to move
var unitClicked

#signal to emit when player moved!
signal playerMoved

func _ready():
	nodeIndex = 0
	unit = null
	unitClicked = null

func _draw():
	var color = Color(0,0,0)
	
	var alignX = texture.get_width() / 2.0
	var alignY = texture.get_height() / 2.0
	
	draw_line(Vector2(0-alignX, 0-alignY), Vector2(texture.get_width()-alignX, 0-alignY), color)
	draw_line(Vector2(texture.get_width()-alignX, 0-alignY), Vector2(texture.get_width()-alignX, texture.get_height()-alignY), color)
	draw_line(Vector2(texture.get_width()-alignX, texture.get_height()-alignY), Vector2(0-alignX, texture.get_height()-alignY), color)
	draw_line(Vector2(0-alignX, texture.get_height()-alignY), Vector2(0-alignX, 0-alignY), color)


func _on_area_2d_input_event(viewport, event, shape_idx):
	if !canClick:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() && not event.is_echo():
				#update unit position, as well its node
				
				#take the unit out of the node.
				unitClicked.freeNode = unitClicked.node
				
				unitClicked.position = position
				unitClicked.lastNode = unitClicked.node
				unitClicked.node = nodeIndex
				unit = unitClicked
				
				#unit not clicked anymore
				unitClicked.isClicked = false
				unitClicked = null
				#release blocks!!
				playerMoved.emit(unit)
