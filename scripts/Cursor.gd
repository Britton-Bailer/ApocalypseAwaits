extends Sprite2D

var sensitivity = 1

@onready var player = $".."

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#place cursor at right place given sensitivity
	position = (get_global_mouse_position() - player.global_position) * sensitivity
