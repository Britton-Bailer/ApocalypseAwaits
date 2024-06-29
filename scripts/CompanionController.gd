extends RigidBody2D

class_name CompanionController

## Public exports ##
@export var acceleration = 8
@export var sightRange = 450
@export var health = 100

## Private variables ##
var speed = 130
var currentState
var followingPlayer = false
var zombiesInArea = []
var recalculateRouteTimer = 0
var recalculateRouteInterval = 10

## References to other nodes ##
@onready var navAgent = $NavigationAgent2D
@onready var spriteDirection = $SpriteDirection
@onready var zombieDetectionArea = $ZombieDetectionArea
@onready var weapon = %Weapon
@onready var zombiesManager = ExpeditionManager.zombiesManager
@onready var projectilesManager = ExpeditionManager.projectilesManager
@onready var player = ExpeditionManager.player
@onready var expeditionStats = ExpeditionManager.expeditionStats

var directions = []
var dirWeights = []
var numDirections = 12
var senseDistance = 30
@onready var navigation_raycasts = $NavigationRaycasts

func _ready():
	weapon = weapon.get_child(0)
	weapon.targetMouse = false
	weapon.controlledByPlayer = false
	weapon.maneuverability = 3
	$ZombieDetectionArea.get_child(0).shape.radius = weapon.bullet.range * 0.5
	navAgent.target_position = position + Vector2(randf_range(-200, 200), randf_range(-200, 200))
	
	for i in range(0, 360, (360.0/numDirections)):
		var dir = Vector2(cos(deg_to_rad(i)), sin(deg_to_rad(i))).normalized()
		var newRaycast = RayCast2D.new()
		navigation_raycasts.add_child(newRaycast)
		newRaycast.set_collision_mask_value(1, true)
		newRaycast.set_collision_mask_value(2, true)
		newRaycast.set_collision_mask_value(8, true)
		newRaycast.target_position = dir * senseDistance
		
		#start with all being normalized (length = 1)
		directions.push_back(dir)
		dirWeights.push_back(0)

## Main update loop ##
func _process(delta):
	if linear_velocity.x < 0:
		spriteDirection.scale.x = -1
	else:
		spriteDirection.scale.x = 1
		
	zombiesInArea = get_zombies_in_area()

	if !followingPlayer:
		recalculateRouteTimer += 1
		if recalculateRouteTimer >= recalculateRouteInterval:
			recalculateRouteTimer = 0
			if(zombiesInArea.size() > 0 || navAgent.is_navigation_finished()):
				navigate_away_from_zombies()
		followingPlayer = position.distance_to(player.position) < 1
	else:
		navAgent.target_position = player.position

	if can_attack():
		attack(delta)
	
	run_directions_calculations()
	navigation(delta)

func run_directions_calculations():
	var desiredDirection = navAgent.get_next_path_position() - global_position
	for i in range(directions.size()):
		dirWeights[i] = desiredDirection.normalized().dot(directions[i])
		
		if navigation_raycasts.get_child(i).is_colliding():
			# Penalize directions towards walls
			dirWeights[i] -= 5
			if i + 1 < directions.size():
				dirWeights[i + 1] -= 3
			else:
				dirWeights[0] -= 3

			if i > 0:
				dirWeights[i - 1] -= 3
			else:
				dirWeights[dirWeights.size() - 1] -= 3
		else:
			# Reward directions opposite walls
			dirWeights[i] += 2

## Navigate towards the next path position ##
func navigation(delta):
	var direction = navAgent.get_next_path_position() - global_position
	
	# Move in the direction with the highest weight
	var maxDirWeight = 0
	for i in range(directions.size()):
		if dirWeights[i] > dirWeights[maxDirWeight]:
			maxDirWeight = i
	
	direction = directions[maxDirWeight]
	linear_velocity = linear_velocity.lerp(direction.normalized() * speed, acceleration * delta)

## Navigate away from zombies while avoiding walls ##
func navigate_away_from_zombies():
	if(zombiesInArea.size() > 0):
		var dirToGo = get_point_away_from_zombies()
		var distToGo = 100
		navAgent.target_position = position + dirToGo * distToGo
	else:
		navAgent.target_position = position + Vector2(randf_range(-200, 200), randf_range(-200, 200))

## Get a direction vector away from zombies ##
func get_point_away_from_zombies():
	var dirToGo = Vector2.ZERO
	for zombie in zombiesInArea:
		dirToGo -= position.direction_to(zombie.position).normalized()
		
	return dirToGo.normalized()

## Get zombies within the detection area ##
func get_zombies_in_area():
	var inArea = []
	var zombiesDetected = zombieDetectionArea.get_overlapping_bodies()
	
	for zombie in zombiesDetected:
		inArea.append(zombie)
	
	return inArea

## Handle damage taken by the companion ##
func take_damage(amt):
	if health > 0:
		health -= amt * expeditionStats.bulletDamageMultiplier
		if health <= 0:
			die()

func die():
	pass #queue_free()

## Placeholder function for handling hit particles ##
func hit_particles():
	return preload("res://prefabs/particles/blood_particles.tscn")
	
## Placeholder for attack logic ##
func attack(delta):
	aim_weapon()
	weapon.__primary_attack()

## Check if the companion can attack ##
func can_attack():
	return zombiesInArea.size() > 0

## Aim the weapon at the nearest zombie ##
func aim_weapon():
	weapon.targetPosition = get_nearest_zombie_position()

func get_nearest_zombie_position():
	var nearest = zombiesInArea[0]
	for zombie in zombiesInArea:
		if position.distance_to(zombie.position) < position.distance_to(nearest.position):
			nearest = zombie
	return nearest.position
