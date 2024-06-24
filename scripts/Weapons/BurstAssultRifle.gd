extends GunWeapon

#variables exclusive to burst rifles
@export var burstBullets: int = 3
@export var timeBetweenBursts = 20
@export var timeBetweenBurstShots = 5

var burstBulletCounter = 0
var burst = false
var burstTimer = timeBetweenBurstShots

## Override variables for this new weapon
func ___ready():
	timeBetweenAttacks = timeBetweenBursts + burstBullets * timeBetweenBurstShots

func ___process(delta):
	if(burst):
		#wait timeBetweenShots time before next bullet in burst shoots
		if(burstTimer >= timeBetweenBurstShots):
			bulletsManager.new_bullet(bullet.speed, bullet.damage, global_position, rotation  + deg_to_rad(randf_range(-bullet.spread, bullet.spread)), bullet.range, BULLET_PREFAB)
			burstTimer = 0
			burstBulletCounter += 1

		burstTimer += 1
		
		#reached number we wanted to shoot in the burst, so end burst
		if(burstBulletCounter == burstBullets):
			burst = false
			burstBulletCounter = 0

func ___primary_attack():
	burst = true
	mag -= burstBullets - 1
