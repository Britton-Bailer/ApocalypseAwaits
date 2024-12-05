extends Control

var blockSize = 1
var minimapOffset: Vector2 = Vector2(-275,125)
var playerSize = 3

var player

var tilemapsContainer
var tilemaps: Array[Node]
var cell_colors = [Color.TRANSPARENT, Color.TRANSPARENT, Color.BLACK]

var offcenterOffset = Vector2(-blockSize*6/2.0, -blockSize*6/2.0)

func get_cells(tilemap: TileMap, id):
	return tilemap.get_used_cells_by_id(id)

func _draw():
	draw_set_transform(Vector2(get_viewport_rect().size.x / 3.0, -get_viewport_rect().size.y / 3.5) + minimapOffset, 0, Vector2.ONE)
	
	for id in range(tilemaps.size()):
		var color = cell_colors[id]
		var cells = get_cells(tilemaps[id], 0)
		for cell in cells:
			#draw tileset cells
			draw_rect(Rect2((Vector2(cell)) * blockSize, Vector2(blockSize, blockSize)), color)
				
		#draw player
		draw_rect(Rect2(((Vector2.ONE * playerSize/2) - (tilemapsContainer.global_position - player.global_position)/16.0 + offcenterOffset) * blockSize, Vector2(playerSize, playerSize)), Color.PURPLE)
func _process(_delta):
	if(tilemaps == null):
		return
	
	queue_redraw()

func set_vars(plr, tlmps, tlmpsCntnr):
	player = plr
	tilemaps = tlmps
	tilemapsContainer = tlmpsCntnr
