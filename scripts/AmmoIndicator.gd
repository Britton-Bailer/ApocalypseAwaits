extends Control

var endAngle = 360
@onready var weapon = %Weapon

func _draw():
	draw_arc(Vector2.ZERO, 20, deg_to_rad(-90), deg_to_rad(-90 + endAngle), 20, Color.BLACK, 4)

func _process(delta):
	if(weapon.reloading):
		set_angle(360 * (float(weapon.reloadTimer)/float(weapon.reloadTime)))
	else:
		set_angle((weapon.mag + 1) * (360/weapon.magSize))
	
	queue_redraw()

func set_angle(angle: float):
	endAngle = angle
