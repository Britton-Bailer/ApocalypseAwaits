extends ZombieController

## Variables specific to throwZombie ##
var THROWABLE_PREFAB = preload("res://prefabs/enemyBullet.tscn")  ## Prefab for enemy bullet
var preferredRange = randi_range(120, 200)  ## Preferred range to maintain from the player

var reloadTime = 200  ## Time between each bullet reload
var reloadTimer = 0  ## Timer to track reload time
var spread = 15  ## Spread of bullet shot angle
var damage = 15  ## Damage inflicted by bullets

## Check if the zombie can attack (within preferred range) ##
func can_attack():
	return position.distance_to(target.position) <= preferredRange

## Attack logic, including shooting bullets and maintaining distance ##
func attack(delta):
	if can_attack():
		## Slow down the zombie's movement when attacking
		velocity = velocity.lerp(Vector2.ZERO, acceleration * delta)
		
		reloadTimer += 1
		if reloadTimer >= reloadTime:
			shoot_bullet()
			reloadTimer = 0
			
	move_to_maintain_range(delta)

	navigation(delta)

## Move towards or away from the player to maintain preferred range ##
func move_to_maintain_range(delta):
	var distance_to_target = position.distance_to(target.position)

	if distance_to_target > preferredRange:
		currentState = enums.zombieState.CHASING
		speed = chasingSpeed
		update_targeting()
	else:
		currentState = enums.zombieState.ROAMING
		var direction_to_move = global_position - target.global_position
		navAgent.target_position = global_position + direction_to_move.normalized() * speed * delta

## Spawn a bullet and shoot it towards the player ##
func shoot_bullet():
	var bulletRotation = get_angle_to(target.position + (target.linear_velocity * randf_range(0.25, 1)))
	var newBullet = THROWABLE_PREFAB.instantiate()
	newBullet.set_vars(200, damage, 300, false)
	newBullet.position = position
	newBullet.rotation = bulletRotation
	
	BulletsManager.add_child(newBullet)
