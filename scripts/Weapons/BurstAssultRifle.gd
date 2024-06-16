## Extends WeaponBase class, so this AssultRifle class contains everything found in the WeaponBase.gd file
extends Weapon

var burstBullets = 3
var burstBulletCounter = 0
var timeBetweenBursts = 20
var timeBetweenBurstShots = 5

## Override variables for this new weapon
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/assault_rifle.png")
	
	timeBetweenShots = timeBetweenBursts
	lastShotTimer = timeBetweenShots
	magSize = 30
	mag = magSize
	reloadTime = 100
	
	bullet.range = 600
	bullet.damage = 15
	bullet.speed = 800
	bullet.spread = 5

func shoot():
	#instantiate new bullet at gun with gun rotation
	new_bullet(bullet.speed, bullet.damage, global_position, rotation, bullet.range, bullet.spread)
	
	burstBulletCounter += 1
	
	#changes the time between shots based on how many bullets were fired
	if (burstBulletCounter < burstBullets && burstBulletCounter > 0):
		timeBetweenShots = timeBetweenBurstShots
	else:
		timeBetweenShots = timeBetweenBursts
		burstBulletCounter = 0
