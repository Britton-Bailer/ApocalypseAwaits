## Extends WeaponBase class, so this Shotgun class contains everything found in the WeaponBase.gd file
extends Weapon

#new variables that do not exist on WeaponBase.gd
var spread = 15
var numBullets = 15

## Override variables on WeaponBase
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/Weapons/shotgun.png")
	timeBetweenShots = 50
	lastShotTimer = timeBetweenShots
	magSize = 2
	mag = magSize
	reloadTime = 100
	
	bullet.range = 150
	bullet.damage = 15
	bullet.speed = 700
	bullet.spread = 10
	

## Override shoot function to shoow spread of bullets
func shoot():
	#instantiate new bullet at gun with gun rotation
	for deg in range(-spread, spread+1, 2*spread/(numBullets-1)):
		BulletsManager.new_bullet(
			bullet.speed + randf_range(-200, 200), 
			bullet.damage, global_position, 
			rotation + deg_to_rad(deg) + deg_to_rad(randf_range(-spread, spread)), 
			bullet.range + randf_range(-50, 50), 
			BULLET_PREFAB)
