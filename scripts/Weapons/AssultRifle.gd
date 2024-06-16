## Extends WeaponBase class, so this AssultRifle class contains everything found in the WeaponBase.gd file
extends Weapon

## Override variables for this new weapon
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/Weapons/assault_rifle.png")
	
	timeBetweenShots = 10
	lastShotTimer = timeBetweenShots
	magSize = 25
	mag = magSize
	reloadTime = 100
	
	bullet.range = 600
	bullet.damage = 20
	bullet.speed = 800
	bullet.spread = 10
