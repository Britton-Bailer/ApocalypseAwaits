extends CharacterBody2D

@export var target: Node2D = player

var speed = randf_range(150, 200)
var acceleration = 3
var sightRange = 600
var lastSeenTarget
var broadcastRange = 500
var health = 100
var touchDamage = 10
var currentState = enums.zombieState.CHASING

var targetingInterval = 10
var targetingTimer = 0

@onready var navAgent = $NavigationAgent2D
@onready var lineOfSightRay = $RayCastToPlayer

var zombiesContainer # parent that holds all zombies
var directions = []
var dirWeights = []
var numDirections = 12
var senseDistance = 50
@onready var navigation_raycasts = %NavigationRaycasts

## runs one time before anything else
func _ready():
	zombiesContainer = get_parent()
	lastSeenTarget = position
	
	for i in range(0, 360, (360.0/numDirections)):
		var dir = Vector2(cos(deg_to_rad(i)), sin(deg_to_rad(i))).normalized()
		var newRaycast = RayCast2D.new()
		navigation_raycasts.add_child(newRaycast)
		newRaycast.set_collision_mask_value(1, true)
		newRaycast.set_collision_mask_value(2, true)
		newRaycast.target_position = dir * senseDistance
		
		#start with all being normalized (length = 1)
		directions.push_back(dir)
		dirWeights.push_back(0)

## runs every frame
func _physics_process(delta):
	if(can_attack()):
		attack()
	
	do_targeting()
	
	#do navigation and movement
	run_directions_calculations()
	navigation(delta)
	move_and_slide()
	queue_redraw()

func do_targeting():
	if(targetingTimer > targetingInterval):
		targetingTimer = 0
	
		#update ray direction to point at player
		lineOfSightRay.target_position = (target.global_position - global_position)
		
		if (can_see_target()):
			currentState = enums.zombieState.CHASING
			
			#update last seen position
			lastSeenTarget = target.global_position
			
			#tell other zombies about it
			broadcast_position(target.global_position)
			
		elif (needs_new_point()):
			currentState = enums.zombieState.ROAMING
			
			#roam randomly
			var searchDirection = Vector2(randf_range(-200, 200), randf_range(-200, 200))
			lastSeenTarget = position + searchDirection
		
		#tell zombie to go towards last seen location
		navAgent.target_position = lastSeenTarget
	
	targetingTimer += 1

func navigation(delta):
	var direction = directions[0]
	
	#move along directions[i] that is longes
	var maxDirWeight = 0
	for i in range(directions.size()):
		if(dirWeights[i] > dirWeights[maxDirWeight]):
			maxDirWeight = i
	
	direction = directions[maxDirWeight].normalized()
	
	velocity = velocity.lerp(direction * speed, acceleration * delta)

## when other zombie broadcasts, this is used to update last seen position
func set_target(newPosition):
	if(!can_see_target()):
		lastSeenTarget = newPosition
	
func broadcast_position(newPosition):
	for zombie in zombiesContainer.get_children():
		#if zombie brothers are within broadcast range (and not current zombie)
		if(transform.origin.distance_to(zombie.transform.origin) < broadcastRange && transform.origin.distance_to(zombie.transform.origin) > 1):
			zombie.set_target(newPosition)

func can_see_target():
	return transform.origin.distance_to(target.transform.origin) < sightRange && !lineOfSightRay.is_colliding()

## zombie either cannot reach point or has already reached it
func needs_new_point():
	return !navAgent.is_target_reachable() || transform.origin.distance_to(lastSeenTarget) < 10

## zombie takes damage
func take_damage(amt):
	#decrement health
	health -= amt
	

	
	#if health is at or below 0, delete zombie
	if(health <= 0):
		queue_free()
	
	
	
func run_directions_calculations():
	var desiredDirection = navAgent.get_next_path_position() - global_position
	for i in range(directions.size()):
		dirWeights[i] = desiredDirection.normalized().dot(directions[i])
		
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
	pass

func attack():
	pass

func _draw():
	for i in range(directions.size()):
		if(dirWeights[i] > 0):
			draw_line(Vector2.ZERO, (directions[i] * dirWeights[i] * senseDistance), Color.BLACK, 2)
		else:
			draw_line(Vector2.ZERO, (directions[i] * -clampf(dirWeights[i], -1, 0) * senseDistance), Color.RED, 2)


func _on_damage_area_body_entered(body):
	if(body.has_method("take_damage")):
		body.take_damage(touchDamage)
