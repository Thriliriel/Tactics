extends Node2D

var mapSize = Vector2(5, 5)
#block
@export var blockScene: PackedScene
#unit scene
@export var unitScene: PackedScene
#tooltip scene
@export var tooltipScene: PackedScene
#size of each block
var blockSize = Vector2(0,0)
#map blocks
var blocks = []
#all units
var units = []

# Called when the node enters the scene tree for the first time.
func _ready():	
	#prepare the map
	var posX = 50
	var posY = 50
	
	for i in mapSize.x:
		#update x
		if posY > 0:
			posY = 0
			posX += blockSize.x
		for j in mapSize.y:
			var newBlock = blockScene.instantiate()
			#position
			newBlock.position = Vector2(posX, posY)
			#name
			newBlock.name = "block_"+str(posX)+"_"+str(posY)
			#terrain type
			newBlock.terrainType = 0
			
			#add in the game
			add_child(newBlock)
			
			#add to map, to use later
			blocks.append(newBlock)
			
			#get block size, if didnt yet
			if blockSize == Vector2(0,0):
				blockSize = newBlock.scale
				
			#update y
			posY += blockSize.y
	
	#get the units of the player and position them	
	var teste = Utils.json_get_local_units()
	
	#node
	var nodeUsed = 0
	for key in teste:
		var unitPlayer = teste[key]
		#print(unitPlayer)
		var image = "res://Images/"+str(unitPlayer.idclass)+".png"
		#print(image)
		var new_texture = load("res://Images/"+str(unitPlayer.idclass)+".png")
		
		#place the unit in the map
		var unit = unitScene.instantiate()
		#image
		unit.get_node("Sprite2D").texture = new_texture
		#position of the unit
		unit.position = blocks[nodeUsed].position
		
		#attributes
		unit.unitName = unitPlayer.name
		unit.attack = unitPlayer.attack
		unit.constitution = unitPlayer.constitution
		unit.defense = unitPlayer.defense
		unit.hp = unitPlayer.hp
		unit.idClass = unitPlayer.idclass
		unit.luck = unitPlayer.luck
		unit.lvl = unitPlayer.lvl
		unit.magic = unitPlayer.magic
		unit.movement = unitPlayer.movement
		unit.onteam = unitPlayer.onteam
		unit.resistance = unitPlayer.resistence
		unit.skill = unitPlayer.skill
		unit.speed = unitPlayer.speed
		
		#text to tooltip
		var textTp = unit.unitName+' - '+str(unit.idClass)+'
Attack = '+str(unit.attack)+'
Constitution = '+str(unit.constitution)+'
Defense = '+str(unit.defense)+'
Hp = '+str(unit.hp)+'
Luck = '+str(unit.luck)+'
Level = '+str(unit.lvl)+'
Magic = '+str(unit.magic)+'
Movement = '+str(unit.movement)+'
Resistance = '+str(unit.resistance)+'
Skill = '+str(unit.skill)+'
Speed = '+str(unit.speed)
		
		#set the unit node
		unit.node = nodeUsed
		unit.lastNode = nodeUsed
		blocks[nodeUsed].unit = unit
		#manually bind the signals for tooltip
		unit.get_node("Area2D").mouse_entered.connect(createTooltip.bind(unit, textTp))
		unit.get_node("Area2D").mouse_exited.connect(destroyTooltip.bind(unit))
		#add child
		add_child(unit)
		units.append(unit)
		
		nodeUsed += 1
		
	#test
	#var newTooltip = tooltipScene.instantiate()
	#add_child(newTooltip)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func createTooltip(unit, unitName):
	var newTooltip = tooltipScene.instantiate()
	newTooltip.DrawTooltip(unit.position, unitName)
	unit.add_child(newTooltip)
	newTooltip.scale = Vector2(newTooltip.scale.x*(1/unit.scale.x), newTooltip.scale.y*(1/unit.scale.y))
	
func destroyTooltip(unit):
	unit.get_node("Tooltip").queue_free()
