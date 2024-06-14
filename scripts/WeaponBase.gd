extends Node2D

class_name Weapon

var BULLET = preload("res://prefabs/bullet.tscn")

@onready var ammo_indicator = %AmmoIndicator
@onready var ammo_text = %AmmoText

var timeBetweenShots = 10
var lastShotTimer = timeBetweenShots
var magSize = 20
var mag = 20
var reloadTime = 150
var reloadTimer = 0
var reloading = false

## rotate gun to mouse
func _process(delta):
	if Input.is_action_pressed("reload"):
		reload()
	
	look_at(get_global_mouse_position())
	
	#increase timer every frame
	lastShotTimer += 1
	
	#if mouse pressed and time between shots has elapsed, shoot
	if(Input.is_action_pressed("shoot") && lastShotTimer > timeBetweenShots && reloading == false):
		shoot()
		
		mag -= 1
		
		#reset last shot timer
		lastShotTimer = 0

	if(mag == 0):
		reloading = true

	if(reloading):
		reloadTimer += 1
	
	if(reloadTimer > reloadTime):
		mag = magSize
		reloadTimer = 0
		reloading = false
	
func reload():
	reloading = true

func shoot():
	pass
	
## create new bullet with stats (include types in the parameters to have the hints show up when calling later)
func new_bullet(spd: float, dmg: float, pos: Vector2, rot: float, mxDst: float):
	var bullet = BULLET.instantiate()
	bullet.set_vars(spd, dmg, mxDst, true)
	bullet.position = pos
	bullet.rotation = rot
	
	#put it in bullets "folder" (autoloaded)
	BulletsManager.add_child(bullet)
