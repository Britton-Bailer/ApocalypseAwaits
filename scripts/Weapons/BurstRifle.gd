## Extends WeaponBase class, so this AssultRifle class contains everything found in the WeaponBase.gd file
extends Weapon

var bulletCounter = 0

## Override variables for this new weapon
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/assault_rifle.png")
	
	timeBetweenShots = 10
	lastShotTimer = timeBetweenShots
	magSize = 30
	mag = magSize
	reloadTime = 100
	
	bullet.range = 600
	bullet.damage = 20
	bullet.speed = 800
	bullet.spread = 10

func _process(_delta):
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
		bulletCounter += 1
		
		#reset last shot timer
		lastShotTimer = 0
		
		#changes the time between shots based on how many bullets were fired
	if (bulletCounter <= 2 && bulletCounter > 0):
		timeBetweenShots = 5
	else:
		timeBetweenShots = 30
		bulletCounter = 0
		
	
	if(mag == 0):
		reloading = true

	if(reloading):
		reloadTimer += 1
	
	if(reloadTimer > reloadTime):
		mag = magSize
		reloadTimer = 0
		reloading = false


