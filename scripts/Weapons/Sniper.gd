## Extends WeaponBase class, so this Sniper class contains everything found in the WeaponBase.gd file
extends Weapon

## Override variables on WeaponBase
func _ready():
	timeBetweenShots = 80
	lastShotTimer = timeBetweenShots
	magSize = 7
	mag = magSize
	reloadTime = 200

## Override shoot function to fit this new weapon
func shoot():
	#instantiate new bullet at gun with gun rotation
	new_bullet(1200, 120, global_position, rotation, 1200)
