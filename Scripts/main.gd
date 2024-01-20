extends Node2D

@export var playerScene: PackedScene
@onready var tileMap_rect = $GameMap.get_used_rect()
@onready var tileMap_cellsize = $GameMap.tile_set.tile_size

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create a new instance of the Mob scene.
	var player = playerScene.instantiate()

		# Set the mob's position to a random location.
	player.position = Vector2(48, 48)
	
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
