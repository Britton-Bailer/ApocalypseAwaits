extends TextureRect

@export var fadeSpeed = 1.5

func _ready():
	modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a -= fadeSpeed * delta

func reset():
	modulate.a = 0.5
