extends BaseManager

## create new bullet with stats (include types in the parameters to have the hints show up when calling later)
func new_projectile(spd: float, dmg: float, pos: Vector2, rot: float, mxDst: float, frndly, projectile_prefab):
	var newprojectile = projectile_prefab.instantiate()
	newprojectile.set_vars(spd, dmg, mxDst, frndly)
	newprojectile.position = pos
	newprojectile.rotation = rot
	
	#put it in bullets "folder"
	add_child(newprojectile)
