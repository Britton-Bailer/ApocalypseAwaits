extends Control

var endAngle = 360
var weapon

func _draw():
	draw_arc(Vector2.ZERO, 20, deg_to_rad(-90), deg_to_rad(-90 + endAngle), 20, Color.BLACK, 2)

func _process(_delta):
	if (weapon == null):
		return
	
	if(weapon.reloading):
		set_angle(360 * (float(weapon.reloadTimer)/float(weapon.reloadTime)))
	else:
		set_angle(weapon.mag * (360/weapon.magSize))
	
	queue_redraw()

func set_angle(angle: float):
	endAngle = angle

func set_weapon(wpn):
	weapon = wpn
