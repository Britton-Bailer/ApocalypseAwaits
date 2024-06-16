extends Node2D

## create new bullet with stats (include types in the parameters to have the hints show up when calling later)
func new_bullet(spd: float, dmg: float, pos: Vector2, rot: float, mxDst: float, bullet_prefab):
	var newBullet = bullet_prefab.instantiate()
	newBullet.set_vars(spd, dmg, mxDst, true)
	newBullet.position = pos
	newBullet.rotation = rot
	
	#put it in bullets "folder" (autoloaded)
	add_child(newBullet)
