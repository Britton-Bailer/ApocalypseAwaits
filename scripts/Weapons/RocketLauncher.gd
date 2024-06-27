extends GunWeapon

var THROWABLE_PREFAB = preload("res://prefabs/AOEThrowables/Throwable.tscn")
var FRAG_PREFAB = preload("res://prefabs/AOEThrowables/Frag.tscn")

func ___primary_attack():
	#instantiate new bullet at gun with gun rotation
	projectilesManager.new_aoe_throwable(bullet.speed, bullet.damage, global_position, rotation  + deg_to_rad(randf_range(-bullet.spread, bullet.spread)), bullet.range, true, THROWABLE_PREFAB, FRAG_PREFAB)
