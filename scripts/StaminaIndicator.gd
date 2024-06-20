extends Control

var player
#width of bar
var width = 60.0000
var height = 8

func _ready():
	player = get_parent()

func _draw():
	#bar outline (max health)
	draw_rect(Rect2((-width/2) + 20, 0, width, height), Color.BLACK, false, 1)
	
	#red health bar inside (current health)
	draw_rect(Rect2((-width/2) + 20, 0, (width/player.maxSprintTime) * player.sprintTimer, height), Color.LAWN_GREEN, true)

func _process(_delta):
	queue_redraw()
	
