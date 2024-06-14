extends Area2D

var hitParticles = preload("res://prefabs/bullet_hit_particles.tscn")

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
	
	var parts = hitParticles.instantiate()
	parts.position = position
	parts.emitting = true
	particles.add_child(parts)
	
	#delete bullet
	queue_free()

func set_vars(spd, dmg, mxDst, friendly):
	bulletSpeed = spd
	damage = dmg
	maxDist = mxDst
	
	#if friendly, dont collide with player
	set_collision_mask_value(8, !friendly)
