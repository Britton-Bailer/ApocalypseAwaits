extends GunWeapon

func ___primary_attack():
	#instantiate new bullet at gun with gun rotation
	projectilesManager.new_projectile(bullet.speed, bullet.damage, global_position, rotation  + deg_to_rad(randf_range(-bullet.spread, bullet.spread)), bullet.range, true, BULLET_PREFAB)
