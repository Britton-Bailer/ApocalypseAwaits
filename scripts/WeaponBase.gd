extends Node2D

class_name Weapon

var WEAPON_SPRITE = preload("res://sprites/Weapons/assault_rifle.png")
var BULLET_PREFAB = preload("res://prefabs/bullet.tscn")

@onready var weapon_direction: Node2D = %WeaponDirection
@onready var weapon_sprite: Sprite2D = %WeaponSprite

var timeBetweenShots = 10
var lastShotTimer = timeBetweenShots

var mag = 20
var reloadTimer = 0
var reloading = false
var magSize = 20
var reloadTime = 150


var bullet = {
	damage = 10,
	range = 200,
	speed = 800,
	spread = 20
}

func _ready():
	set_stats()
	weapon_sprite.texture = WEAPON_SPRITE

## rotate gun to mouse
func _process(delta):
	process(delta)
	#keep gun upright no matter which side it is on
	if (get_global_mouse_position().x < global_position.x):
		weapon_direction.scale.y = -1
	else:
		weapon_direction.scale.y = 1

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

## overwrite this to add functionality that runs every frame
func process(delta):
	pass

func reload():
	reloading = true

func shoot():
	#instantiate new bullet at gun with gun rotation
	BulletsManager.new_bullet(bullet.speed, bullet.damage, global_position, rotation  + deg_to_rad(randf_range(-bullet.spread, bullet.spread)), bullet.range, BULLET_PREFAB)

## overwrite this when creating a new weapon
func set_stats():
	pass
