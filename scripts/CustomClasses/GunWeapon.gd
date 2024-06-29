extends Weapon

class_name GunWeapon

#variables exclusive to guns
@export var magSize = 20
@export var reloadTime = 150
@export var shotCost = 1
@export var bullet = {
	damage = 10,
	range = 200,
	speed = 800,
	spread = 20
}
@export var BULLET_PREFAB = preload("res://prefabs/bullet.tscn")
@onready var projectilesManager = ExpeditionManager.projectilesManager

var reloading = false
var reloadSpeed = 1
var reloadTimer = 0
var mag

func __ready():
	___ready()
	
func __process(delta):
	___process(delta)
	handle_reloading()

func __update_with_expedition_stats():
	reloadSpeed *= expeditionStats.weaponReloadSpeedMultiplier
	bullet.speed *= expeditionStats.bulletSpeedMultiplier
	magSize = int(magSize * expeditionStats.weaponMagSizeMultiplier)
	mag = magSize
	bullet.spread *= expeditionStats.weaponSpreadMultiplier
	bullet.range *= expeditionStats.weaponRangeMultiplier

func __primary_attack():
	if(reloading == false):		
		if(ExpeditionManager.currency >= shotCost):
			if(lastAttackTimer > timeBetweenAttacks):
				#reset last shot timer
				lastAttackTimer = 0
				___primary_attack()
				ExpeditionManager.shot_fired(shotCost)
			
			mag -= 1
		else:
			hudManager.flash_text("", "Not enough ammo. Switch to your secondary!", 0.8)

func reload():
	reloading = true

func handle_reloading():
	#auto reload when mag empty
	if(mag == 0):
		reloading = true

	if(reloading):
		reloadTimer += reloadSpeed
	
	if(reloadTimer > reloadTime):
		mag = magSize
		reloadTimer = 0
		reloading = false

func __handle_input():
	if Input.is_action_pressed("reload"):
		reload()

func ___primary_attack():
	#instantiate new bullet at gun with gun rotation
	projectilesManager.new_projectile(bullet.speed, bullet.damage, global_position, rotation  + deg_to_rad(randf_range(-bullet.spread, bullet.spread)), bullet.range, true, BULLET_PREFAB)

func ___ready():
	pass
	
func ___process(delta):
	pass
