extends Control

var endAngle = 360

func _draw():
	draw_arc(Vector2.ZERO, 20, deg_to_rad(-90), deg_to_rad(-90 + endAngle), 20, Color.BLACK, 4)

func _process(delta):
	queue_redraw()

func set_angle(angle: float):
	endAngle = angle
