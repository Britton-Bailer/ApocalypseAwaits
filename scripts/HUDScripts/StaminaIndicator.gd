extends Control

var player
#width of bar
var width = 600.0
var height = 10

func _draw():
	if (player == null):
		return
	#bar outline (max health)
	draw_rect(Rect2((-width/2) + 20, 0, width, height), Color.BLACK, false, 1)
	
	#red health bar inside (current health)
	draw_rect(Rect2((-width/2) + 20, 0.5, (width/player.maxStamina) * player.stamina, height-1), Color.SKY_BLUE, true)

func _process(_delta):
	queue_redraw()
	
func set_player(plr):
	player = plr
