extends CharacterBody2D

@export var target: Node2D

var speed = randf_range(80, 120)
var acceleration = 7
var sightRange = 600
var lastSeenTarget
var broadcastRange = 500
var health = 100
var currentState = enums.zombieState.CHASING

var targetingInterval = 10
var targetingTimer = 0

@onready var navAgent = $NavigationAgent2D
@onready var lineOfSightRay = $ShapeCast2D
@onready var player = %player
var zombiesContainer # parent that holds all zombies

## runs one time before anything else
func _ready():
	target = player
	zombiesContainer = get_parent()
	lastSeenTarget = position

## runs every frame
func _physics_process(delta):	
	do_targeting()
	
	#do navigation and movement
	navigation(delta)
	move_and_slide()

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
	var direction = Vector2.ZERO
	
	direction = navAgent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, acceleration * delta)

## when other zombie broadcasts, this is used to update last seen position with slight random offset
func set_target(newPosition):
	if(!can_see_target()):
		lastSeenTarget = newPosition + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	
func broadcast_position(newPosition):
	for zombie in zombiesContainer.get_children():
		#if zombie brothers are within broadcast range (and not current zombie)
		if(transform.origin.distance_to(zombie.transform.origin) < broadcastRange && transform.origin.distance_to(zombie.transform.origin) > 1):
			zombie.set_target(newPosition)

func can_see_target():
	return transform.origin.distance_to(target.transform.origin) < sightRange && lineOfSightRay.get_collision_count() == 0

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
