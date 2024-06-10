extends Node2D

@onready var bullets = $"../../Bullets"
const BULLET = preload("res://prefabs/bullet.tscn")

@export var timeBetweenShots = 10
var lastShotTimer = timeBetweenShots

## rotate gun to mouse
func _process(delta):
	look_at(get_global_mouse_position())
	
	#increase timer every frame
	lastShotTimer += 1
	
	#if mouse pressed and time between shots has elapsed, shoot
	if(Input.is_action_pressed("shoot") && lastShotTimer > timeBetweenShots):
		#instantiate new bullet at gun with gun rotation
		var bullet = BULLET.instantiate()
		bullet.position = global_position
		bullet.rotation = rotation
		
		#put it in bullets "folder"
		bullets.add_child(bullet)
		
		#reset last shot timer
		lastShotTimer = 0
