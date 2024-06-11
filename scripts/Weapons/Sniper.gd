extends Weapon

func _ready():
	timeBetweenShots = 80
	lastShotTimer = timeBetweenShots
	magSize = 7
	mag = magSize
	reloadTime = 200

func shoot():
	#instantiate new bullet at gun with gun rotation
	new_bullet(1200, 120, global_position, rotation, 900)
