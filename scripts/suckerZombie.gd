extends ZombieController

@onready var animate = $SpriteDirection/SuckerZombieAnimation
@export var suckDistance = 30

func process(delta):
	if(can_attack()):
		animate.animation = "Attack"
	else:
		animate.animation = "Normal"
	
func can_attack():
	return position.distance_to(target.position) < suckDistance
