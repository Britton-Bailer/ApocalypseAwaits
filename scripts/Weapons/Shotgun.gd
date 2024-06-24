extends GunWeapon

#variables exclusive to shotguns
var numBullets = 8

## Override shoot function to shoow spread of bullets
func ___primary_attack():
	#instantiate new bullet at gun with gun rotation
	for i in range(numBullets):
		bulletsManager.new_bullet(
			bullet.speed + randf_range(-200, 200), 
			bullet.damage, global_position, 
			rotation + deg_to_rad(randf_range(-bullet.spread, bullet.spread)), 
			bullet.range + randf_range(-50, 50), 
			BULLET_PREFAB
		)
