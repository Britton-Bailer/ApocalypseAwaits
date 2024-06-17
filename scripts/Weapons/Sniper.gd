## Extends WeaponBase class, so this Sniper class contains everything found in the WeaponBase.gd file
extends Weapon

## Override variables on WeaponBase
func set_stats():
	timeBetweenShots = 80
	lastShotTimer = timeBetweenShots
	magSize = 7
	mag = magSize
	reloadTime = 100
	
	bullet.range = 1000
	bullet.damage = 190
	bullet.speed = 1200
	bullet.spread = 0
