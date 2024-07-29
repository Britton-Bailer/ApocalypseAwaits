extends Sprite2D

var spread = 20

@onready var player = $".."

func _draw():
	draw_circle_arc_poly(Vector2.ZERO, 500, 90-spread, 90+spread, Color(0,0,0,0.2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	queue_redraw()
	
	#Hard limit to maxDist
	#if(player.global_position.distance_to(get_global_mouse_position()) < maxDist):
		#position = get_global_mouse_position() - player.global_position
	#else:
		#position = (get_global_mouse_position() - player.global_position).normalized() * maxDist

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
