extends RigidBody2D

const SPEED = 150.0
var sprintSpeed = baseSprintSpeed
var maxSprintSpeed = 50
var baseSprintSpeed = 0
var sprintTimer = 0
var maxSprintTime = 500
var exhausted = false
var maxHealth = 100
var health = maxHealth
var healthRegen = 2

@onready var weapon = %Weapon
@onready var zombiesManager = MissionManager.zombiesManager

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
	sprint_exhaustion()

func movement():
	var left = Input.is_action_pressed("left")
	if left:
		linear_velocity.x = -SPEED - sprintSpeed
		
	var right = Input.is_action_pressed("right")
	if right:
		linear_velocity.x = SPEED + sprintSpeed
	
	var up = Input.is_action_pressed("up")
	if up:
		linear_velocity.y = -SPEED - sprintSpeed
		
	var down = Input.is_action_pressed("down")
	if down:
		linear_velocity.y = SPEED + sprintSpeed
	
	var sprint = Input.is_action_pressed("sprint")
	if sprint && not exhausted:
		sprintSpeed = maxSprintSpeed
		sprintTimer += maxSprintSpeed/25
	else:
		sprintTimer -= 0.5
		sprintSpeed = baseSprintSpeed


func sprint_exhaustion():
	if (sprintTimer <= 0):
		sprintTimer = 0
		baseSprintSpeed = 0
		exhausted = false

	if (sprintTimer >= maxSprintTime):
		baseSprintSpeed = -50
		exhausted = true

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
