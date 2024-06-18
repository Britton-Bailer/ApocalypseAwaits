extends CharacterBody2D

class_name ZombieController

@export var target: RigidBody2D
var speed
var roamingSpeed
var chasingSpeed

@export var roamingSpeedRange: Vector2
@export var chasingSpeedRange: Vector2
@export var acceleration = 8
@export var sightRange = 450
@export var broadcastRange = 300
@export var health = 100
@export var touchDamage: float = 10
@export var touchDamageInterval = 100
@export var reactToBroadcast = true
var touchDamageTimer = 0

var lastSeenTarget
var currentState = enums.zombieState.CHASING

@onready var navAgent = $NavigationAgent2D
@onready var lineOfSightRay = $RayCastToPlayer

var zombiesContainer # parent that holds all zombies

## runs one time before anything else
func _ready():
	roamingSpeed = randf_range(roamingSpeedRange.x, roamingSpeedRange.y)
	chasingSpeed = randf_range(chasingSpeedRange.x, chasingSpeedRange.y)
	speed = roamingSpeed
	zombiesContainer = get_parent()
	lastSeenTarget = position

## runs every frame
func _process(delta):
	if(target.global_position.distance_to(position) > 100 && target.global_position.distance_to(lastSeenTarget) > 50):
		update_targeting()
	elif (target.global_position.distance_to(position) < 100 && target.global_position.distance_to(lastSeenTarget) > 10):
		update_targeting()
	
	
	process(delta)
	if(can_attack()):
		currentState = enums.zombieState.ATTACK
		attack(delta)
	
	#do navigation and movement
	move_and_slide()
	if(currentState != enums.zombieState.ATTACK):
		navigation(delta)
	do_touch_damage()
	#queue_redraw()

## overwrite this to add more functionality to 
func process(delta):
	pass

func do_touch_damage():
	touchDamageTimer += 1
	if(touchDamageTimer >= touchDamageInterval):
		touchDamageTimer = 0
		for body in $DamageArea.get_overlapping_bodies():
			if(body.has_method("take_damage")):
				body.take_damage(touchDamage)

func update_targeting():
	#update ray direction to point at player
	lineOfSightRay.target_position = (target.global_position - global_position)
	
	if (can_see_target()):
		speed = chasingSpeed
		if(currentState == enums.zombieState.ROAMING):
			currentState = enums.zombieState.CHASING
		
		#update last seen position
		lastSeenTarget = target.global_position
		
		#tell other zombies about it
		#broadcast_position(lastSeenTarget)
		
	elif (needs_new_point()):
		if(currentState == enums.zombieState.CHASING):
			speed = roamingSpeed
			currentState = enums.zombieState.ROAMING
		
		#roam randomly
		var searchDirection = Vector2(randf_range(-200, 200), randf_range(-200, 200))
		lastSeenTarget = position + searchDirection
	
	#tell zombie to go towards last seen location
	navAgent.target_position = lastSeenTarget
	
func navigation(delta):
	var direction = navAgent.get_next_path_position() - global_position
	velocity = velocity.lerp(direction.normalized() * speed, acceleration * delta)

## when other zombie broadcasts, this is used to update last seen position
func set_target(newPosition):
	if(reactToBroadcast):
		currentState = enums.zombieState.CHASING
		speed = chasingSpeed
		lastSeenTarget = newPosition
	
func broadcast_position(newPosition):
	for zombie in zombiesContainer.get_children():
		#if zombie brothers are within broadcast range (and not current zombie)
		if(transform.origin.distance_to(zombie.transform.origin) < broadcastRange && transform.origin.distance_to(zombie.transform.origin) > 1):
			zombie.set_target(newPosition)

func can_see_target():
	return transform.origin.distance_to(target.global_position) < sightRange && !lineOfSightRay.is_colliding()

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

func can_attack():
	pass

func attack(delta):
	pass

func _on_damage_area_body_entered(body):
	if(body.has_method("take_damage")):
		body.take_damage(touchDamage)

func hit_particles():
	return preload("res://prefabs/particles/blood_particles.tscn")
