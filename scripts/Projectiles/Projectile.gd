extends Area2D

class_name Projectile

var hitParticles = preload("res://prefabs/particles/bullet_hit_particles.tscn")

var speed = 800
var hitDamage = 50
var maxDist = 500
var dist = 0

@onready var expeditionStats = ExpeditionManager.expeditionStats

func _ready():
	setup()

func setup():
	pass

## move bullet every frame
func _process(delta):
	var xChange = cos(rotation) * speed * delta
	var yChange = sin(rotation) * speed * delta
	position += Vector2(xChange, yChange)
	
	dist += sqrt(pow(xChange, 2) + pow(yChange, 2))

	if(dist > maxDist):
		max_dist_reached()

func max_dist_reached():
	var parts = hitParticles.instantiate()
	parts.position = position
	parts.emitting = true
	ParticlesContainer.add_child(parts)
	queue_free()

## bullet hit something
func _on_body_entered(body):
	hit_body(body)

func hit_body(body):
	#if thing hit can take damage, make it take bullets damage
	if(body.has_method("take_damage")):
		body.take_damage(hitDamage)
	
	#set parts to default with position of bullet
	var parts = hitParticles.instantiate()
	
	#if body has its own parts it wants to use, use those
	if(body.has_method("hit_particles")):
		parts = body.hit_particles().instantiate()
	
	parts.position = position
	
	parts.emitting = true
	ParticlesContainer.add_child(parts)
	
	queue_free()
