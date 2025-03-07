extends Projectile

var maxPierces = 0
var pierces = 0
var pierceDamageMultiplier = 0.5

func setup():
	pierceDamageMultiplier = expeditionStats.bulletPierceDamageMultiplier
	maxPierces = expeditionStats.bulletMaxPierces

## bullet hit something
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
	
	if(pierces >= maxPierces):
		#delete bullet
		queue_free()
		
	pierces += 1
	hitDamage *= pierceDamageMultiplier

func set_vars(spd, dmg, mxDst, friendly):
	speed = spd
	hitDamage = dmg
	maxDist = mxDst
	
	#if friendly, dont collide with player
	set_collision_mask_value(8, !friendly)
	set_collision_mask_value(2, friendly)
