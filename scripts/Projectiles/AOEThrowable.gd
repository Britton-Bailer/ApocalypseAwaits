extends Projectile

var aoePrefab
var projectileManager

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
	
	print("explode_aoe()")
	explode_aoe()

func explode_aoe():
	print("creating new aoe")
	var newAoe = aoePrefab.instantiate()
	newAoe.position = position
	projectileManager.add_child(newAoe)
	queue_free()

func set_vars(spd, dmg, mxDst, friendly, aoePrfb, prjctlMngr):
	speed = spd
	hitDamage = dmg
	maxDist = mxDst
	aoePrefab = aoePrfb
	projectileManager = prjctlMngr
	
	#if friendly, dont collide with player
	set_collision_mask_value(8, !friendly)
	set_collision_mask_value(2, friendly)
