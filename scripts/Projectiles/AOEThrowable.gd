extends Projectile

class_name AOEThrowable

@onready var aoe = $AOE
@onready var aoeSprite = $AOESprite
@onready var projectileSprite = $ProjectileSprite


func setup():
	pass

func max_dist_reached():
	explode_aoe()

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
	
	explode_aoe()

func explode_aoe():
	queue_free()

func set_vars(spd, dmg, mxDst, friendly):
	speed = spd
	hitDamage = dmg
	maxDist = mxDst
	
	#if friendly, dont collide with player
	set_collision_mask_value(8, !friendly)
	set_collision_mask_value(2, friendly)
	$AOE.set_collision_mask_value(8, !friendly)
	$AOE.set_collision_mask_value(2, friendly)
