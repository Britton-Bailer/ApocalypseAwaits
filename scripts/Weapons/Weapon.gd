extends Node2D

class_name Weapon

@export var shotCost = 1

var WEAPON_SPRITE = preload("res://sprites/Weapons/assault_rifle.png")
var BULLET_PREFAB = preload("res://prefabs/bullet.tscn")

@onready var weapon_direction: Node2D = get_child(0)
@onready var weapon_sprite: Sprite2D = get_child(0).get_child(0)
@onready var bulletsManager = MissionManager.bulletsManager
@onready var hudManager = MissionManager.hudManager
@onready var expeditionStats = MissionManager.expeditionStats

var timeBetweenShots = 10
var lastShotTimer = timeBetweenShots

var mag = 20
var reloadTimer = 0
var reloadSpeed = 1
var reloading = false
var magSize = 20
var reloadTime = 150
var maneuverability = 25

var bullet = {
	damage = 10,
	range = 200,
	speed = 800,
	spread = 20
}

func _ready():
	set_stats()
	weapon_sprite.texture = WEAPON_SPRITE
	
	reloadSpeed *= expeditionStats.weaponReloadSpeedMultiplier
	bullet.speed *= expeditionStats.bulletSpeedMultiplier
	magSize = int(magSize * expeditionStats.weaponMagSizeMultiplier)
	mag = magSize
	bullet.spread *= expeditionStats.weaponSpreadMultiplier
	bullet.range *= expeditionStats.weaponRangeMultiplier
	maneuverability = float(min(maneuverability * expeditionStats.weaponManeuverabilityMultiplier, 25))

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
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	var target_angle = direction.angle()
	var current_angle = rotation

	# Calculate the new angle using lerp_angle
	var new_angle = lerp_angle(current_angle, target_angle, deg_to_rad(maneuverability))

	rotation = new_angle
	
	
	#increase timer every frame
	lastShotTimer += 1
	
	#if mouse pressed and time between shots has elapsed, shoot
	if(Input.is_action_pressed("shoot") && lastShotTimer > timeBetweenShots && reloading == false):
		#reset last shot timer
		lastShotTimer = 0
		
		if(MissionManager.currency >= shotCost):
			shoot()
			MissionManager.shot_fired(shotCost)
			
			mag -= 1
		else:
			hudManager.flash_text("", "Not enough ammo. Switch to your secondary!", 0.8)

	if(mag == 0):
		reloading = true

	if(reloading):
		reloadTimer += reloadSpeed
	
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
	bulletsManager.new_bullet(bullet.speed, bullet.damage, global_position, rotation  + deg_to_rad(randf_range(-bullet.spread, bullet.spread)), bullet.range, BULLET_PREFAB)

## overwrite this when creating a new weapon
func set_stats():
	pass
