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
	spread = 2
}
@export var kickback: float = 1
@export var BULLET_PREFAB = preload("res://prefabs/bullet.tscn")
@onready var projectilesManager = ExpeditionManager.projectilesManager

var reloading = false
var reloadSpeed = 1
var reloadTimer = 0
var mag
var player
var exhausted = false


#func _draw():
	#draw_circle_arc_poly(Vector2.ZERO, bullet.range, 89-bullet.spread, 91+bullet.spread, Color(1,1,1,0.2))
#
#func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	#var nb_points = 32
	#var points_arc = PackedVector2Array()
	#points_arc.push_back(center)
	#var colors = PackedColorArray([color])
#
	#for i in range(nb_points + 1):
		#var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		#points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	#draw_polygon(points_arc, colors)

func __ready():
	player = get_parent().get_parent()
	___ready()
	
func __process(delta):
	___process(delta)
	queue_redraw()
	handle_reloading()
	handle_exhaustion()

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
				apply_shake()
				lastAttackTimer = 0
				___primary_attack()
				ExpeditionManager.shot_fired(shotCost)
			
			mag -= 1
		else:
			hudManager.flash_text("", "Not enough ammo. Switch to your secondary!", 0.8)
func __secondary_attack():
	var mouse_velocity = Input.get_last_mouse_velocity()
	var slowed_velocity = mouse_velocity * 0.5
	mouse_velocity = slowed_velocity
	
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


func handle_exhaustion():
	pass
	#if(exhausted):
		#bullet[3] == 30
	#else:
		#bullet[3] == 2
	
func apply_shake():
	player.apply_shake(kickback)

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
