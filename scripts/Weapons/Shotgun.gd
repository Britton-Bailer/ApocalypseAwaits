## Extends WeaponBase class, so this Shotgun class contains everything found in the WeaponBase.gd file
extends Weapon

#new variables that do not exist on WeaponBase.gd
var spread = 20
var numBullets = 7

## Override variables on WeaponBase
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/shotgun.png")
	timeBetweenShots = 50
	lastShotTimer = timeBetweenShots
	magSize = 2
	mag = magSize
	reloadTime = 100
	
	bullet.range = 800
	bullet.damage = 20
	bullet.speed = 200
	bullet.spread = 10
	

## Override shoot function to shoow spread of bullets
func shoot():
	#instantiate new bullet at gun with gun rotation
	for deg in range(-spread, spread+1, 2*spread/(numBullets-1)):
		new_bullet(800, 20, global_position, rotation + deg_to_rad(deg), 200)
