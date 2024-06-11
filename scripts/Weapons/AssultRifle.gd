extends Weapon

func _ready():
	timeBetweenShots = 10
	lastShotTimer = timeBetweenShots
	magSize = 25
	mag = magSize
	reloadTime = 150

func shoot():
	#instantiate new bullet at gun with gun rotation
	new_bullet(800, 10, global_position, rotation, 400)
