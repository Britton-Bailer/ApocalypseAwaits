extends RigidBody2D

const SPEED = 150.0
var maxHealth = 100
var health = maxHealth

@onready var weapon = %Weapon
var assultRifleScript = preload("res://scripts/Weapons/AssultRifle.gd")
var smgScript = preload("res://scripts/Weapons/SMG.gd")
var sniperScript = preload("res://scripts/Weapons/Sniper.gd")
var shotgunScript = preload("res://scripts/Weapons/Shotgun.gd")
var theSprayerScript = preload("res://scripts/Weapons/TheSprayer.gd")
var burstRifle = preload("res://scripts/Weapons/BurstRifle.gd")

var weapons = [assultRifleScript, smgScript, sniperScript, shotgunScript, theSprayerScript, burstRifle]
var index = 0

func _physics_process(_delta):
	movement()
	cycle_weapons()

func movement():
	var left = Input.is_action_pressed("left")
	if left:
		linear_velocity.x = -SPEED
		
	var right = Input.is_action_pressed("right")
	if right:
		linear_velocity.x = SPEED
	
	var up = Input.is_action_pressed("up")
	if up:
		linear_velocity.y = -SPEED
		
	var down = Input.is_action_pressed("down")
	if down:
		linear_velocity.y = SPEED

func take_damage(dmg):
	health -= dmg
	
	if(health <= 0):
		pass #game_over()

func cycle_weapons():
	var weapon1 = Input.is_action_just_released("changeWeapon")
	if(weapon1):
		weapon.set_script(weapons[index])
		weapon._ready()
		
		if(index + 1 > weapons.size()-1):
			index = 0
		else:
			index += 1 #index = index + 1
