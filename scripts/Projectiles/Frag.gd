extends Area2D

var fragDamage = 120


# Called when the node enters the scene tree for the first time.
func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if(body.has_method("take_damage")):
			body.take_damage(fragDamage)
			print("took damage")
			
	#wait long enough for above for loop to do its thing
	await get_tree().create_timer(0.1).timeout
	queue_free()
