extends CharacterBody2D

class_name ZombieController

## Public exports ##
@export var target: RigidBody2D
@export var roamingSpeedRange: Vector2
@export var chasingSpeedRange: Vector2
@export var acceleration = 8
@export var sightRange = 450
@export var broadcastRange = 300
@export var health = 100
@export var touchDamage: float = 10
@export var touchDamageInterval = 100
@export var reactToBroadcast = true
@export var separationForceFactor = 650  ## Adjust the strength of separation force

## Private variables ##
var speed
var roamingSpeed
var chasingSpeed
var touchDamageTimer = 0
var lastSeenTarget
var currentState = enums.zombieState.CHASING  ## Default state is CHASING

## References to other nodes ##
@onready var navAgent = $NavigationAgent2D
@onready var lineOfSightRay = $RayCastToPlayer
@onready var damageArea = $DamageArea
@onready var zombiesContainer = get_parent()

## Initialization ##
func _ready():
	## Initialize speeds randomly within specified ranges
	roamingSpeed = randf_range(roamingSpeedRange.x, roamingSpeedRange.y)
	chasingSpeed = randf_range(chasingSpeedRange.x, chasingSpeedRange.y)
	speed = roamingSpeed
	lastSeenTarget = position

## Main update loop ##
func _process(delta):
	if can_see_target() or needs_new_point():
		update_targeting()

	process(delta)
	if can_attack():
		currentState = enums.zombieState.ATTACK
		attack(delta)

	move_and_slide()
	if currentState != enums.zombieState.ATTACK:
		navigation(delta)
	do_touch_damage()

## Perform touch damage to overlapping bodies ##
func do_touch_damage():
	touchDamageTimer += 1
	if touchDamageTimer >= touchDamageInterval:
		touchDamageTimer = 0
		for body in damageArea.get_overlapping_bodies():
			if body.has_method("take_damage"):
				body.take_damage(touchDamage)

## Update targeting based on sight and navigation conditions ##
func update_targeting():
	lineOfSightRay.target_position = target.global_position - global_position

	if can_see_target():
		speed = chasingSpeed
		if currentState == enums.zombieState.ROAMING:
			currentState = enums.zombieState.CHASING
		lastSeenTarget = target.global_position
		# broadcast_position(lastSeenTarget)
	elif needs_new_point():
		if currentState == enums.zombieState.CHASING:
			speed = roamingSpeed
			currentState = enums.zombieState.ROAMING
		lastSeenTarget = position + Vector2(randf_range(-200, 200), randf_range(-200, 200))

	navAgent.target_position = lastSeenTarget

	# Add separation behavior
	var separationForce = calculateSeparationForce()
	navAgent.target_position += separationForce

## Navigate towards the next path position ##
func navigation(delta):
	var direction = navAgent.get_next_path_position() - global_position
	velocity = velocity.lerp(direction.normalized() * speed, acceleration * delta)

## Set a new target position ##
func set_target(newPosition):
	if reactToBroadcast:
		currentState = enums.zombieState.CHASING
		speed = chasingSpeed
		lastSeenTarget = newPosition

## Broadcast the target position to other zombies within range ##
func broadcast_position(newPosition):
	for zombie in zombiesContainer.get_children():
		var zombie_pos = zombie.transform.origin
		if transform.origin.distance_to(zombie_pos) < broadcastRange and transform.origin.distance_to(zombie_pos) > 1:
			zombie.set_target(newPosition)

## Check if the zombie can see the target within sight range ##
func can_see_target():
	return transform.origin.distance_to(target.global_position) < sightRange and not lineOfSightRay.is_colliding()

## Check if the zombie needs to find a new navigation point ##
func needs_new_point():
	return not navAgent.is_target_reachable() or transform.origin.distance_to(lastSeenTarget) < 10

## Handle damage taken by the zombie ##
func take_damage(amt):
	health -= amt
	if health <= 0:
		queue_free()

## Handle collision with damage area ##
func _on_damage_area_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(touchDamage)

## Placeholder function for handling hit particles ##
func hit_particles():
	return preload("res://prefabs/particles/blood_particles.tscn")

## Calculate separation force from nearby zombies ##
func calculateSeparationForce():
	var separationForce = Vector2.ZERO
	var nearbyZombies = 0

	for zombie in zombiesContainer.get_children():
		if zombie == self:
			continue

		var zombie_pos = zombie.transform.origin
		var distance = transform.origin.distance_to(zombie_pos)

		if distance < broadcastRange:
			var direction = (transform.origin - zombie_pos).normalized()
			separationForce += direction / distance
			nearbyZombies += 1

	if nearbyZombies > 0:
		separationForce /= nearbyZombies
		separationForce *= separationForceFactor

	return separationForce

## Placeholder for additional processing logic ##
func process(delta):
	pass
	
## Placeholder for attack logic ##
func attack(delta):
	pass

## Placeholder for attack condition check ##
func can_attack():
	pass
