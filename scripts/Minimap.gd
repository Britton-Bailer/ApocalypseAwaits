extends Control

@export var camera_node: NodePath
@export var blockSize = 0.8
@export var minimapOffset: Vector2 = Vector2(0,0)
var playerSize = 3


@onready var camera  = get_node(camera_node)
@onready var player = %player

@export var tilemaps: Array[TileMap]
var cell_colors = [Color.BLACK, Color.TRANSPARENT, Color.BLUE]

var playerDrawOffset = Vector2(29-blockSize*0.5/2.0, -31-blockSize*0.8/2.0)

func get_cells(tilemap : TileMap, id):
	return tilemap.get_used_cells_by_id(id)

func _draw():
	draw_set_transform(Vector2(get_viewport_rect().size.x / 3.0, -get_viewport_rect().size.y / 3.5) + minimapOffset, 0, Vector2.ONE)
	
	for tilemap in tilemaps:
		for id in range(cell_colors.size()):
			var color = cell_colors[id]
			var cells = get_cells(tilemap, id)
			for cell in cells:
				#draw tileset cells
				draw_rect(Rect2((Vector2(cell) + playerDrawOffset) * blockSize, Vector2.ONE * blockSize), color)
				
		#draw player
		draw_rect(Rect2((Vector2(player.position/16.0) - (Vector2.ONE * playerSize/2)) * blockSize, Vector2.ONE * playerSize), Color.PURPLE)

func _process(delta):
	queue_redraw()
