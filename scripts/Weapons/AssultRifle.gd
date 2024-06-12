## Extends WeaponBase class, so this AssultRifle class contains everything found in the WeaponBase.gd file
extends Weapon

## Override variables for this new weapon
func _ready():
	timeBetweenShots = 10
	lastShotTimer = timeBetweenShots
	magSize = 25
	mag = magSize
	reloadTime = 150

## Override shoot function to work for new AR
func shoot():
	#instantiate new bullet at gun with gun rotation
	new_bullet(800, 10, global_position, rotation, 500)
