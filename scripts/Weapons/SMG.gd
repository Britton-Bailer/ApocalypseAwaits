## Extends WeaponBase class, so this SMG class contains everything found in the WeaponBase.gd file
extends Weapon

## Override variables for this new weapon
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/Weapons/smg.png")
	timeBetweenShots = 5
	magSize = 30
	mag = magSize
	reloadTime = 90
	
	bullet.range = 300
	bullet.damage = 10
	bullet.speed = 800
	bullet.spread = 20
