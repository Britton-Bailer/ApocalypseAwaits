extends Control

var player
var width = 600.0
var height = 10

func _draw():
	if (player == null):
		return
		
	#bar outline (max stamina)
	draw_rect(Rect2((-width/2) + 20, 0, width, height), Color.BLACK, false, 1)
	
	#blue stamina bar inside (current stamina)
	draw_rect(Rect2((-width/2) + 20, 0.5, (width / player.maxStamina) * player.stamina, height - 1), Color.SKY_BLUE, true)

func _process(_delta):
	queue_redraw()
	
func set_player(plr):
	player = plr
