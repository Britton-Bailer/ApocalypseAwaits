extends Sprite2D

var maxDist = 200.0

@onready var player = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position() - player.global_position
	modulate.a = max((maxDist - player.global_position.distance_to(get_global_mouse_position()))/maxDist, 0.05)
	
	#Hard limit to maxDist
	#if(player.global_position.distance_to(get_global_mouse_position()) < maxDist):
		#position = get_global_mouse_position() - player.global_position
	#else:
		#position = (get_global_mouse_position() - player.global_position).normalized() * maxDist
