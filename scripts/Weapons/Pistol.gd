## Extends WeaponBase class, so this AssultRifle class contains everything found in the WeaponBase.gd file
extends Weapon

## Override variables for this new weapon
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/Weapons/pistol.png")
	
	timeBetweenShots = 40
	lastShotTimer = timeBetweenShots
	magSize = 10
	mag = magSize
	reloadTime = 100
	
	bullet.range = 400
	bullet.damage = 45
	bullet.speed = 800
	bullet.spread = 5
