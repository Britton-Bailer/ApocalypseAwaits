extends AOEThrowable

var fragDamage = 120

func explode_aoe():
	projectileSprite.visible = false
	aoeSprite.visible = true
	speed = 0
	var bodies = aoe.get_overlapping_bodies()
	for body in bodies:
		if(body.has_method("take_damage")):
			body.take_damage(fragDamage)
			
	#wait long enough for above for loop to do its thing
	await get_tree().create_timer(0.1).timeout
	queue_free()
