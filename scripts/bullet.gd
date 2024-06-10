extends Area2D

var bulletSpeed = 800
var damage = 50

## move bullet every frame
func _process(delta):
	position.x += cos(rotation) * bulletSpeed * delta
	position.y += sin(rotation) * bulletSpeed * delta

## bullet hit something
func _on_body_entered(body):
	#if thing hit can take damage, make it take bullets damage
	if(body.has_method("take_damage")):
		body.take_damage(damage)
	
	#delete bullet
	queue_free()
