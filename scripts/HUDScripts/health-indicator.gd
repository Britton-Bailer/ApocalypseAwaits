extends Control

var player
var width = 600.0
var height = 20

func _draw():
	if (player == null):
		return
	
	#bar outline (max health)
	draw_rect(Rect2((-width/2) + 20, 0, width, height), Color.BLACK, false, 1)
	
	#red health bar inside (current health)
	draw_rect(Rect2((-width/2) + 20, 0.5, (width / player.maxHealth) * player.health, height - 1), Color.DARK_RED, true)

func _process(_delta):
	queue_redraw()
	
func set_player(plr):
	player = plr
