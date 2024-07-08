extends Camera2D

@export var shakeFade: float = 10.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func apply_shake(strength: float):
	shake_strength = strength

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		
		offset = randomOffset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
