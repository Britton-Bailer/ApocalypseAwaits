extends RigidBody2D

@onready var weapon = %Weapon
@onready var zombiesManager = MissionManager.zombiesManager

const SPEED = 150.0
var maxHealth = 100
var health = maxHealth
var healthRegen = 2

var assultRifleScript = preload("res://scripts/Weapons/AssultRifle.gd")
var smgScript = preload("res://scripts/Weapons/SMG.gd")
var sniperScript = preload("res://scripts/Weapons/Sniper.gd")
var shotgunScript = preload("res://scripts/Weapons/Shotgun.gd")
var burstScript = preload("res://scripts/Weapons/BurstAssultRifle.gd")
var sprayerScript = preload("res://scripts/Weapons/TheSprayer.gd")

var weapons = [burstScript, smgScript, sniperScript, shotgunScript, assultRifleScript , sprayerScript]
var index = 0

func _ready():
	zombiesManager.set_player(self)

func _physics_process(delta):
	movement()
	cycle_weapons()
	handle_pausing()
	health_regen(delta)

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
	health -= dmg * MissionManager.missionData.damageMultipler
	
	if(health <= 0):
		MissionManager.round_loss()

func cycle_weapons():
	var changeWeapon = Input.is_action_just_released("changeWeapon")
	if(changeWeapon):
		weapon.set_script(weapons[index])
		weapon._ready()
		
		if(index + 1 > weapons.size()-1):
			index = 0
		else:
			index += 1 #index = index + 1

func handle_pausing():
	var pause = Input.is_action_just_pressed("pause")
	if(pause):
		get_tree().paused = true #pause
		%PauseScreen.visible = true #show pause screen

func health_regen(delta):
	if(health > maxHealth):
		health = maxHealth
	else:
		health += healthRegen * delta
