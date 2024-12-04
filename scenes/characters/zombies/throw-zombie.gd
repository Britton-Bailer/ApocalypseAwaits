extends ZombieController

## Variables specific to throwZombie ##
@export var THROWABLE_PREFAB = preload("res://scenes/misc/bullet.tscn")  ## Prefab for enemy bullet
var preferredRange = randi_range(120, 200)  ## Preferred range to maintain from the player

@export var reloadRange = Vector2(150, 250)
var reloadTime  ## Time between each bullet reload
var reloadTimer = 0  ## Timer to track reload time
@export var spread = 15  ## Spread of bullet shot angle
@export var throwDamage = 15  ## Damage inflicted by bullets
@export var throwSpeed = 200
@export var throwRange = 300

func ready():
	reloadTime = randi_range(reloadRange.x, reloadRange.y)

## Check if the zombie can attack (within preferred range) ##
func can_attack():
	return target && position.distance_to(target.position) <= preferredRange + 10 && can_see_target()

## Attack logic, including shooting bullets and maintaining distance ##
func attack(delta):
	if can_attack():
		reloadTimer += 1
		if reloadTimer >= reloadTime:
			throw()
			reloadTimer = 0
	
	move_to_maintain_range(delta)

	navigation(delta)

## Move towards or away from the player to maintain preferred range ##
func move_to_maintain_range(_delta):
	var distance_to_target = position.distance_to(target.position)
	currentState = Zombies.zombieState.CHASING
	if distance_to_target > preferredRange + 10:
		update_targeting()
	elif distance_to_target < preferredRange - 10:
		var direction_to_move = global_position - target.global_position
		navAgent.target_position = global_position + direction_to_move.normalized() * speed
	else:
		speed = 0

## Spawn a bullet and shoot it towards the player ##
func throw():
	var bulletRotation = get_angle_to(target.position + (target.linear_velocity * randf_range(0.25, 1)))
	projectilesManager.new_projectile(throwSpeed, throwDamage, position, bulletRotation, throwRange, false, THROWABLE_PREFAB)
	
	#choose random time before next shot
	reloadTime = randi_range(reloadRange.x, reloadRange.y)
