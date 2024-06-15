extends ZombieController

var THROWABLE_PREFAB = preload("res://prefabs/enemyBullet.tscn")

var preferredRange = randi_range(120, 200)

var reloadTime = 100
var reloadTimer = reloadTime
var spread = 15
var damage = 15

#slower on average, slower acceleration, sight range reduced, normal broadcast, lower health
func set_stats():
	speed = randf_range(80, 130)
	acceleration = 5
	sightRange = 400
	broadcastRange = 500
	health = 60

func run_directions_calculations():
	var desiredDirection = navAgent.get_next_path_position() - global_position
	for i in range(directions.size()):
		if(position.distance_to(target.position) > preferredRange+5 || !can_see_target()):
			dirWeights[i] = desiredDirection.normalized().dot(directions[i])
			currentState = enums.zombieState.CHASING
		elif (position.distance_to(target.position) < preferredRange-5 && can_see_target()):
			dirWeights[i] = 0 - (desiredDirection.normalized().dot(directions[i]))
			currentState = enums.zombieState.CHASING
		if(navigation_raycasts.get_child(i).is_colliding()):
			dirWeights[i] -= 5
			if(i+1 < directions.size()):
				dirWeights[i+1] -= 1
			else:
				dirWeights[0] -= 1
				
			if(i > 0):
				dirWeights[i-1] -= 1
			else:
				dirWeights[dirWeights.size()-1] -= 1

func can_attack():
	return position.distance_to(target.position) <= preferredRange+5 && can_see_target()

func attack(delta):
	velocity = velocity.lerp(Vector2.ZERO, acceleration * delta)
	reloadTimer += 1
	
	if(reloadTimer >= reloadTime):
		new_bullet(200, damage, position, get_angle_to(target.position + (target.linear_velocity * randf_range(0.25, 1))), 300, spread)
		reloadTimer = 0

## create new bullet with stats (include types in the parameters to have the hints show up when calling later)
func new_bullet(spd: float, dmg: float, pos: Vector2, rot: float, mxDst: float, spread: float = 10):
	var newBullet = THROWABLE_PREFAB.instantiate()
	newBullet.set_vars(spd, dmg, mxDst, false)
	newBullet.position = pos
	newBullet.rotation = rot + deg_to_rad(randf_range(-spread, spread))
	
	#put it in bullets "folder" (autoloaded)
	BulletsManager.add_child(newBullet)
