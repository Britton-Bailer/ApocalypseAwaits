extends ZombieController
@onready var animate = $SpriteDirection/SuckerZombieAnimation
func _process(delta):
	if (velocity.x < 0):
		spriteDirection.scale.x = -1
	else:
		spriteDirection.scale.x = 1
	
	if can_see_target() or needs_new_point():
		update_targeting()

	process(delta)
	if can_attack():
		currentState = enums.zombieState.ATTACK
		attack(delta)

	move_and_slide()
	if currentState != enums.zombieState.ATTACK:
		navigation(delta)
		#animate.animation = "Attack"
	do_touch_damage()
	#if currentState != enums.zombieState.ROAMING:
		#animate.animation = "Normal"
	
	

## Perform touch damage to overlapping bodies ##
func do_touch_damage():
	touchDamageTimer += 1
	if touchDamageTimer >= touchDamageInterval:
		touchDamageTimer = 0
		for body in damageArea.get_overlapping_bodies():
			if body.has_method("take_damage"):
				body.take_damage(touchDamage)
