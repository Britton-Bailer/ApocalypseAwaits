extends ZombieController

var THROWABLE_PREFAB = preload("res://prefabs/enemyBullet.tscn")

var preferredRange = randi_range(120, 200)

var reloadTime = 100
var reloadTimer = 0
var spread = 15
var damage = 15


func can_attack():
	return position.distance_to(target.position) <= preferredRange+5

func attack(delta):
	velocity = velocity.lerp(Vector2.ZERO, acceleration * delta)
	reloadTimer += 1
	
	if(reloadTimer >= reloadTime):
		new_bullet(200, damage, position, get_angle_to(target.position + (target.linear_velocity * randf_range(0.25, 1))), 300, spread)
		reloadTimer = 0

## create new bullet with stats (include types in the parameters to have the hints show up when calling later)
func new_bullet(spd: float, dmg: float, pos: Vector2, rot: float, mxDst: float, spread: float = 10):
	var newBullet = THROWABLE_PREFAB.instantiate()
	newBullet.set_vars(spd, dmg, mxDst, false)
	newBullet.position = pos
	newBullet.rotation = rot + deg_to_rad(randf_range(-spread, spread))
	
	#put it in bullets "folder" (autoloaded)
	BulletsManager.add_child(newBullet)
