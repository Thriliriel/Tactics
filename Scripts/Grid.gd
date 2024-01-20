extends Node2D

@onready var tileMap_rect = get_parent().get_used_rect()
@onready var tileMap_cellsize = get_parent().tile_set.tile_size
#@onready var tileMap_cellsize = Vector2i(16,16)
@onready var color = Color(1, 0, 0)

func _ready():
	position = tileMap_rect.position * tileMap_cellsize
	set_process(true)
	
func _process(delta):
	#update()
	pass
	
func _draw():
	for y in range(0, tileMap_rect.size.y):
		draw_line(Vector2(0, y * tileMap_cellsize.y), Vector2(tileMap_rect.size.x * tileMap_cellsize.x, y * tileMap_cellsize.y), color)
	for x in range(0, tileMap_rect.size.x):
		draw_line(Vector2(x * tileMap_cellsize.x, 0), Vector2(x * tileMap_cellsize.x, tileMap_cellsize.y * tileMap_rect.size.y), color)
