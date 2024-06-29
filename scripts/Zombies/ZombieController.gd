extends CharacterBody2D

class_name ZombieController

## Public exports ##
@export var type: Zombies.type
@export var roamingSpeedRange: Vector2
@export var chasingSpeedRange: Vector2
@export var acceleration = 8
@export var sightRange = 450
@export var broadcastRange = 300
@export var health = 100
@export var touchDamage: float = 10
@export var touchDamageInterval = 100
@export var reactToBroadcast = true
@export var separationForceFactor = 650
@export var coinWorth = 3
var predictionTime = max(randf_range(-1, 3), 0)

var canUpdateTargeting = true

## Private variables ##
var speed
var roamingSpeed
var chasingSpeed
var touchDamageTimer = 0
var lastSeenTarget
var currentState = Zombies.zombieState.ROAMING

## References to other nodes ##
@onready var targetSenseArea = $TargetSenseArea
@onready var navAgent = $NavigationAgent2D
@onready var lineOfSightRay = $RayCastToPlayer
@onready var damageArea = $DamageArea
@onready var zombiesContainer = get_parent()
@onready var spriteDirection = $SpriteDirection
@onready var zombiesManager = ExpeditionManager.zombiesManager
@onready var projectilesManager = ExpeditionManager.projectilesManager
@onready var coinsManager = ExpeditionManager.coinsManager
@onready var expeditionStats = ExpeditionManager.expeditionStats
@onready var target = null

## Initialization ##
func _ready():
	roamingSpeed = randf_range(roamingSpeedRange.x, roamingSpeedRange.y)
	chasingSpeed = randf_range(chasingSpeedRange.x, chasingSpeedRange.y)
	speed = roamingSpeed
	lastSeenTarget = position
	targetSenseArea.get_child(0).shape.radius = sightRange
	ready()
	
	health *= expeditionStats.zombieHealthMultiplier
	speed *= expeditionStats.zombieSpeedMultiplier

## Main update loop ##
func _process(delta):
	if velocity.x < 0:
		spriteDirection.scale.x = -1
	else:
		spriteDirection.scale.x = 1
	
	update_targeting()
	process(delta)
	if can_attack():
		currentState = Zombies.zombieState.ATTACK
		attack(delta)

	move_and_slide()
	if currentState != Zombies.zombieState.ATTACK:
		navigation(delta)
	do_touch_damage()
	if target:
		lineOfSightRay.target_position = target.global_position - global_position

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
	if canUpdateTargeting:
		if target:
			if can_see_target():
				lastSeenTarget = target.global_position
				broadcast_position(lastSeenTarget)
			elif global_position.distance_to(lastSeenTarget) < 10:
				target = null
		else:
			var players_in_sight = get_players_in_sight()
			if players_in_sight.size() > 0:
				target = players_in_sight[0]
				speed = chasingSpeed
				lastSeenTarget = target.global_position
				currentState = Zombies.zombieState.CHASING
			else:
				if currentState != Zombies.zombieState.ROAMING:
					speed = roamingSpeed
					currentState = Zombies.zombieState.ROAMING
				if global_position.distance_to(lastSeenTarget) < 10:
					lastSeenTarget = get_new_point_on_map()
	
	navAgent.target_position = lastSeenTarget
	
	var separationForce = calculateSeparationForce()
	navAgent.target_position += separationForce

func get_new_point_on_map():
	var pos = global_position + Vector2(randf_range(-200, 200), randf_range(-200, 200))
	navAgent.target_position = pos
	while(!navAgent.is_target_reachable()):
		pos = global_position + Vector2(randf_range(-200, 200), randf_range(-200, 200))
		navAgent.target_position = pos
	
	return pos

## Get players in sight with line of sight ##
func get_players_in_sight():
	var players = []
	for player in targetSenseArea.get_overlapping_bodies():
		lineOfSightRay.target_position = player.global_position - global_position
		if not lineOfSightRay.is_colliding():
			players.append(player)
	return players

## Navigate towards the next path position ##
func navigation(delta):
	var direction = navAgent.get_next_path_position() - global_position
	velocity = velocity.lerp(direction.normalized() * speed * expeditionStats.zombieSpeedMultiplier, acceleration * delta)

## Set a new target position ##
func set_target(newPosition):
	if reactToBroadcast && not target:
		currentState = Zombies.zombieState.CHASING
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
	return target and not lineOfSightRay.is_colliding()

## Handle damage taken by the zombie ##
func take_damage(amt):
	if health > 0:
		health -= amt * expeditionStats.bulletDamageMultiplier
		if health <= 0:
			coinsManager.add_coins(global_position, coinWorth)
			ExpeditionManager.zombie_killed(type)
			die()

func die():
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

## Placeholder for additional ready logic ##
func ready():
	pass

## Placeholder for additional processing logic ##
func process(delta):
	pass
	
## Placeholder for attack logic ##
func attack(delta):
	pass

## Placeholder for attack condition check ##
func can_attack():
	pass
