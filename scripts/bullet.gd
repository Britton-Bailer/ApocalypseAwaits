extends Area2D

var bulletSpeed = 800
var damage = 50
var maxDist = 500

var dist = 0

## move bullet every frame
func _process(delta):
	var xChange = cos(rotation) * bulletSpeed * delta
	var yChange = sin(rotation) * bulletSpeed * delta
	position += Vector2(xChange, yChange)
	
	dist += sqrt(pow(xChange, 2) + pow(yChange, 2))

	if(dist > maxDist):
		queue_free()

## bullet hit something
func _on_body_entered(body):
	#if thing hit can take damage, make it take bullets damage
	if(body.has_method("take_damage")):
		body.take_damage(damage)
	
	#delete bullet
	queue_free()

func set_vars(spd, dmg, mxDst):
	bulletSpeed = spd
	damage = dmg
	maxDist = mxDst
