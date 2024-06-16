## Extends WeaponBase class, so this AssultRifle class contains everything found in the WeaponBase.gd file
extends Weapon

var burstBullets: int = 3
var burstBulletCounter = 0
var timeBetweenBursts = 20
var timeBetweenBurstShots = 5

var burst = false
var burstTimer = timeBetweenBurstShots

## Override variables for this new weapon
func set_stats():
	WEAPON_SPRITE = preload("res://sprites/Weapons/assault_rifle.png")
	
	timeBetweenShots = timeBetweenBursts + burstBullets * timeBetweenBurstShots
	lastShotTimer = timeBetweenShots
	magSize = 30
	mag = magSize
	reloadTime = 100
	
	bullet.range = 600
	bullet.damage = 15
	bullet.speed = 800
	bullet.spread = 5

func shoot():
	burst = true
	mag -= burstBullets - 1

func process(delta):
	if(burst):
		#wait timeBetweenShots time before next bullet in burst shoots
		if(burstTimer >= timeBetweenBurstShots):
			BulletsManager.new_bullet(bullet.speed, bullet.damage, global_position, rotation  + deg_to_rad(randf_range(-bullet.spread, bullet.spread)), bullet.range, BULLET_PREFAB)
			burstTimer = 0
			burstBulletCounter += 1

		burstTimer += 1
		
		#reached number we wanted to shoot in the burst, so end burst
		if(burstBulletCounter == burstBullets):
			burst = false
			burstBulletCounter = 0
