## Extends WeaponBase class, so this AssultRifle class contains everything found in the WeaponBase.gd file
extends Weapon

var burstSpeed = 0
var bulletCounter = 0

## Override variables for this new weapon
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/assault_rifle.png")
	
	timeBetweenShots = burstSpeed
	lastShotTimer = timeBetweenShots
	magSize = 40
	mag = magSize
	reloadTime = 100
	
	bullet.range = 600
	bullet.damage = 20
	bullet.speed = 800
	bullet.spread = 10
	bulletCounter = mag/3
	

	if typeof (bulletCounter) == TYPE_INT:
		burstSpeed == 15
		print_debug("burst")
	else:
		burstSpeed == 5
	
	
