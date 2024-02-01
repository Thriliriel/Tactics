extends Node2D

#index of the node where the player is
var node: int
#index of the last node where the player was
var lastNode: int
#index of the node which needs to be freed
var freeNode: int
#if another unit is clicked, cannot select this one
var canClick = true
#also, player can be clicked to be selected as an attack target
var possibleTarget = false
signal selectedTarget

#signal to unit clicked
signal clicked
#signal to cancel click
signal cancelClick
#unit was clicked, need to know this so we can move (or stop moving)
var isClicked = false

#unit's attributes and info
#unit HP
var hp: int
#unit name
var unitName: String
#unit movement (determines the amount of nodes it can move)
var movement: int
#unit physical attack
var attack: int
#unit physical defense
var defense: int
#unit skill (affects hit)
var skill: int
#unit speed (affects evade and double hits)
var speed: int
#unit magic attack
var magic: int
#unit magic defense
var resistance: int
#unit luck (for random and crazy stuff)
var luck: int

# Called when the node enters the scene tree for the first time.
func _ready():
	freeNode = -1
	#test
	movement = 8
	hp = 20
	attack = 5
	defense = 2
	unitName = "Unit"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):	
	if event is InputEventMouseButton:
		#if being targeted as target for an attack
		if event.button_index == MOUSE_BUTTON_LEFT and possibleTarget:
			if event.is_pressed() && not event.is_echo():
				#emit signal and set as clicked
				selectedTarget.emit(self)
		#if player wants to move this unit
		elif event.button_index == MOUSE_BUTTON_LEFT and canClick:
			if event.is_pressed() && not event.is_echo():
				#emit signal and set as clicked
				isClicked = true
				clicked.emit(self)
		#if player wants to cancel the action
		elif event.button_index == MOUSE_BUTTON_RIGHT and isClicked: #can only cancel if unit is clicked
			if event.is_pressed() && not event.is_echo():
				#emit signal and set as not clicked
				isClicked = false
				cancelClick.emit(self)
				
func selectAnotherPlayer():
	canClick = false

func deselectAnotherPlayer():
	canClick = true
	
#reset the unit
func resetStuff():
	canClick = true
	possibleTarget = false
	isClicked = false
