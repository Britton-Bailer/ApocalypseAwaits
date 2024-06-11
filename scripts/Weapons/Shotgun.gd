extends Weapon

var spread = 20
var numBullets = 7
var bulletSprite = preload("res://prefabs/bullet2.tscn")

func _ready():
	timeBetweenShots = 50
	lastShotTimer = timeBetweenShots
	magSize = 2
	mag = magSize
	reloadTime = 100
	BULLET = bulletSprite

func shoot():
	#instantiate new bullet at gun with gun rotation
	for deg in range(-spread, spread+1, 2*spread/(numBullets-1)):
		new_bullet(800, 20, global_position, rotation + deg_to_rad(deg), 200)
