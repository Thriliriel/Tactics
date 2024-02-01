extends Node2D

#blocks scene
@export var blockScene: PackedScene
#unit scene
@export var unitScene: PackedScene
#size of the map
var mapSize = Vector2i(1,1)
#size of each block
var blockSize = Vector2(0,0)
#store all blocks of the map
var blocks
#store all units
var units = []
#camera speed
var cameraSpeed = 400
#map to load
var mapToLoad = "clearMap.json"
#if a player is selected, no other can be selected
var playedClicked = Node2D
signal playerSelected
signal playerDeselected

#if a unit can attack another, keeps a list of attackable ones
var foundEnemies
#unit chosen to be attacked
var attackedUnit: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide the actions and the target
	$HUDActions.hide()
	$HUDTarget.hide()
	$CanvasLayer/ChooseUnit.hide()
	$HUDConfirmAttack.hide()
	
	foundEnemies = []
	
	#draw the map
	draw_map()
	#place the unit in the map
	var unit = unitScene.instantiate()
	#get the first node to place the player in
	var firstNode = 0
	#position of the unit
	unit.position = blocks[firstNode].position
	#set the unit node
	unit.node = firstNode
	unit.lastNode = firstNode
	blocks[firstNode].unit = unit
	#manually bind the clicked signal of the unit to the calc_star, alongside other signals
	unit.clicked.connect(calc_star.bind())
	unit.cancelClick.connect(cancelMovement.bind())
	unit.selectedTarget.connect(selectAttackTarget.bind())
	playerSelected.connect(unit.selectAnotherPlayer.bind())
	playerDeselected.connect(unit.deselectAnotherPlayer.bind())
	#add child
	add_child(unit)
	units.append(unit)
	
	#another unit in the map, jjust to test
	unit = unitScene.instantiate()
	#get the first node to place the player in
	firstNode = len(blocks)-1
	#position of the unit
	unit.position = blocks[firstNode].position
	#set the unit node
	unit.node = firstNode
	unit.lastNode = firstNode
	#manually bind the clicked signal of the unit to the calc_star, alongside other signals
	unit.clicked.connect(calc_star.bind())
	unit.cancelClick.connect(cancelMovement.bind())
	unit.selectedTarget.connect(selectAttackTarget.bind())
	playerSelected.connect(unit.selectAnotherPlayer.bind())
	playerDeselected.connect(unit.deselectAnotherPlayer.bind())
	#add child
	add_child(unit)
	units.append(unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#camera movement
	var velocity = Vector2.ZERO # The camera's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * cameraSpeed
		
	$Camera.position += velocity * delta
	
#create the map
func draw_map():
	#load the json with the map info
	var map = Utils.json_read_map(mapToLoad)
	#mapSize: x is the qnt of keys, y is the qnt inside each key
	mapSize.x = len(map)
	mapSize.y = len(map["Row0"])
	
	#prepare the map
	var posX = 0
	var posY = 0
	
	for key in map:
		#update x
		if posY > 0:
			posY = 0
			posX += blockSize.x
		for value in map[key]:
			var newBlock = blockScene.instantiate()
			#position
			newBlock.position = Vector2(posX, posY)
			#name
			newBlock.name = "block_"+str(posX)+"_"+str(posY)
			#terrain type
			newBlock.terrainType = value
			
			#manually bind the player moved signal of the block to the releaseBlocks
			newBlock.playerMoved.connect(releaseBlocks.bind())
			
			#add in the game
			add_child(newBlock)
			
			#get block size, if didnt yet
			if blockSize == Vector2(0,0):
				blockSize = newBlock.scale
				
			#update y
			posY += blockSize.y
			
	#store all blocks, for performance
	blocks = get_tree().get_nodes_in_group("block")
	for i in range(0, len(blocks)):
		blocks[i].nodeIndex = i
	#redraw scene
	#queue_redraw()
	
#when player click on unit, calculate possible route
func calc_star(unit):
	#there is a player selected
	playedClicked = unit
	playerSelected.emit()
	
	#print(len(blocks))
	#for starters, all nodes change to a shade of gray, except the one the unit is in
	for block in blocks:
		#print(block.name)
		if block.name != blocks[unit.node].name:
			block.modulate = Color(0.5, 0.5, 0.5)
		
	#use the node index of the unit to find the needed nodes inside the projected matrix
	#Godot gets from the drawing by columns. So, to do so, index/size = column. index%size = row
	#using speed of movement, iterate through the indexes
	var unitRow = unit.node % mapSize.y
	var unitCol = floor(unit.node / mapSize.y)
	
	#use the row and the column to get the limits
	var limLeft = unitCol - unit.movement
	var limRight = unitCol + unit.movement
	var limUp = unitRow - unit.movement
	var limDown = unitRow + unit.movement
	
	#check limts
	if limLeft < 0:
		limLeft = 0
	if limUp < 0:
		limUp = 0
	if limRight >= mapSize.x:
		limRight = mapSize.x-1
	if limDown >= mapSize.y:
		limDown = mapSize.y-1
	
	#print("Unit: ")
	#print (unitRow)
	#print (unitCol)
	#print("Lims: ")
	#print(limLeft)
	#print(limRight)
	#print(limUp)
	#print(limDown)
	
	#iterate through the lims, checking if possible
	for i in range(limLeft, limRight+1):
		for j in range(limUp, limDown+1):
			var indx = i * mapSize.y + j
			
			#if it is the node, dont change
			if indx == unit.node:
				continue
				
			#check rows and columns, so it is not a square movement
			if ((unitCol-i) + (unitRow-j)) > unit.movement:
				continue
			if ((unitCol-i) + (j-unitRow)) > unit.movement:
				continue
			if ((i-unitCol) + (j-unitRow)) > unit.movement:
				continue
			if ((i-unitCol) + (unitRow-j)) > unit.movement:
				continue
			
			#if terrain type if 0, free to move
			if 	blocks[indx].terrainType == 0:
				blocks[indx].modulate = Color(0, 1, 0)
				blocks[indx].canClick = true
				blocks[indx].unitClicked = unit
			#if terrain type is 9, nothing can pass
			elif blocks[indx].terrainType == 9:
				blocks[indx].modulate = Color(1, 0, 0)
				blocks[indx].canClick = false
				
			#if there is already a unit, cannot enter
			if blocks[indx].unit != null:
				blocks[indx].modulate = Color(1, 0, 0)
				blocks[indx].canClick = false
		
#when player moves, we can release the possible moving blocks and show the actions HUD
func releaseBlocks(unit):
	playerDeselected.emit()
	
	if unit.freeNode != -1:
		blocks[unit.freeNode].unit = null
		unit.freeNode = -1
	
	#print(unit.node)
	for block in blocks:
		block.modulate = Color(1, 1, 1)
		block.canClick = false
		
	$HUDActions.unitPanel = unit
		
	controlHUDOptions(unit)	
		
	$HUDActions.show()

#when showing HUD actions, need to put only the buttons that can be used
#for instance, if there are no enemy units around, dont need to show the Attack button
func controlHUDOptions(unit):
	for child in $HUDActions.get_children():
		if child.is_in_group("action"):
			#for each of them, hide or show. Wait, Item and Cancel are default, so they are always there
			#attack button
			if child.name.contains("Attack"):
				foundEnemies = checkForEnemies(unit)
				if !foundEnemies.is_empty():
					child.show()
				else:
					child.hide()	

#check is there is any unit nearby
func checkForEnemies(unit): 
	#list with the enemies found nearby
	var found = []
	
	#to check, get the blocks north, south, west and east
	#Godot gets from the drawing by columns. So, to do so, index/size = column. index%size = row
	var unitRow = unit.node % mapSize.y
	var unitCol = floor(unit.node / mapSize.y)
	
	#print("Node: " + str(unit.node))
	#print("Row: " + str(unitRow))
	#print("Col: " + str(unitCol))
	
	#west
	var indx = unitCol * mapSize.y + (unitRow-1)
	if blocks[indx].unit != null:
		found.append(blocks[indx].unit)
	#print("West: " + str(indx))
	#east
	indx = unitCol * mapSize.y + (unitRow+1)
	if blocks[indx].unit != null:
		found.append(blocks[indx].unit)
	#print("East: " + str(indx))
	#north
	indx = (unitCol-1) * mapSize.y + unitRow
	if blocks[indx].unit != null:
		found.append(blocks[indx].unit)
	#print("North: " + str(indx))
	#south
	indx = (unitCol+1) * mapSize.y + unitRow
	if blocks[indx].unit != null:
		found.append(blocks[indx].unit)
	#print("South: " + str(indx))
	return found

#when player clicks with right mouse button, or cancel in the HUD, cancel movement
func cancelMovement(unit):
	#release the blocks
	releaseBlocks(unit)
	
	#reset the units
	resetUnits()
	
	$HUDActions.hide()

func cancelMovementHUD(unit):
	#reattach the player to the last node
	blocks[unit.node].unit = null
	unit.node = unit.lastNode
	blocks[unit.node].unit = unit
	unit.position = blocks[unit.node].position
	
	cancelMovement(unit)

func _on_hud_actions_cancel_press(unit):
	cancelMovementHUD(unit)

func _on_hud_actions_wait_press():
	$HUDActions.hide()

func _on_hud_actions_attack_press(unit):
	$HUDActions.hide()
	
	$CanvasLayer/ChooseUnit.show()
	
	#when attacking, the unit cant be clicked, and the possible enemies can be clicked to be selected only
	unit.canClick = false
	for enemy in foundEnemies:
		enemy.possibleTarget = true
	
func selectAttackTarget(targetUnit):
	attackedUnit = targetUnit
	
	$CanvasLayer/ChooseUnit.hide()
	
	#put the target at the position of the first enemy in the list
	$HUDTarget.position = attackedUnit.position	
	$HUDTarget.show()
	
	#also, show the confirmation attack image
	$HUDConfirmAttack.position = attackedUnit.position - Vector2(30,30)
	$HUDConfirmAttack.show()

#attack unit!
func charge():
	print(attackedUnit.hp)
	attackedUnit.hp -= playedClicked.attack - attackedUnit.defense
	print(attackedUnit.hp)
	
	#reset stuff
	$HUDTarget.hide()
	$HUDConfirmAttack.hide()
	attackedUnit = null
	playedClicked = null
	resetUnits()
	
#reset all units
func resetUnits():
	for un in units:
		un.resetStuff()
