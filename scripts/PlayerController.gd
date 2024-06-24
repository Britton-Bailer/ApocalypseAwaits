extends RigidBody2D

@onready var weapon = get_equipped_weapon()
@onready var expeditionStats = MissionManager.expeditionStats
@onready var hudManager = MissionManager.hudManager

var sprintSpeed = 0
var maxSprintSpeed = 50
var maxStamina = 500
var stamina = maxStamina
var staminaDrain = 1
var staminaRegen = 0.25
var exhausted = false
var exhaustedSpeed = 0
var exhaustedSpeedPentalty = -50

var speed = 150.0
var maxHealth = 100
var health = maxHealth
var healthRegen = 2

var swapWeaponTimer = 0
var swapWeaponInterval = 10
var is_primary = true

var assultRifleScript = preload("res://scripts/Weapons/AssultRifle.gd")
var smgScript = preload("res://scripts/Weapons/SMG.gd")
var sniperScript = preload("res://scripts/Weapons/Sniper.gd")
var shotgunScript = preload("res://scripts/Weapons/Shotgun.gd")
var burstScript = preload("res://scripts/Weapons/BurstAssultRifle.gd")
var sprayerScript = preload("res://scripts/Weapons/TheSprayer.gd")

var weapons = [burstScript, smgScript, sniperScript, shotgunScript, assultRifleScript , sprayerScript]
var weaponIndex = 0

func _ready():
	speed = expeditionStats.playerSpeed
	maxHealth = expeditionStats.playerMaxHealth
	healthRegen *= expeditionStats.playerHealthRegenMultiplier
	staminaDrain *= expeditionStats.playerStaminaDrainMultiplier
	staminaRegen *= expeditionStats.playerStaminaRegenMultiplier

func _physics_process(delta):
	movement()
	cycle_weapons()
	handle_pausing()
	health_regen(delta)
	sprint_exhaustion()

func movement():
	var left = Input.is_action_pressed("left")
	if left:
		linear_velocity.x = -(speed + sprintSpeed + exhaustedSpeed)
		
	var right = Input.is_action_pressed("right")
	if right:
		linear_velocity.x = speed + sprintSpeed + exhaustedSpeed
	
	var up = Input.is_action_pressed("up")
	if up:
		linear_velocity.y = -(speed + sprintSpeed + exhaustedSpeed)
		
	var down = Input.is_action_pressed("down")
	if down:
		linear_velocity.y = speed + sprintSpeed + exhaustedSpeed
	
	var sprint = Input.is_action_pressed("sprint")
	if sprint && not exhausted:
		sprintSpeed = maxSprintSpeed
		stamina -= staminaDrain
	else:
		stamina += staminaRegen
		sprintSpeed = 0


func sprint_exhaustion():
	if (stamina >= maxStamina):
		exhaustedSpeed = 0 
		stamina = maxStamina
		exhausted = false

	if (stamina <= 0):
		hudManager.flash_text("", "You're exhausted. Get rekt.", 0.4)
		exhausted = true
		exhaustedSpeed = exhaustedSpeedPentalty
		

func take_damage(dmg):
	health -= dmg * MissionManager.missionData.damageMultipler * expeditionStats.zombieDamageMultiplier
	
	if(health <= 0):
		MissionManager.round_loss()

func cycle_weapons():
	var changeWeapon = Input.is_action_just_released("changeWeapon")
	if(changeWeapon):
		weapon.set_script(weapons[weaponIndex])
		weapon._ready()
		
		if(weaponIndex + 1 > weapons.size()-1):
			weaponIndex = 0
		else:
			weaponIndex += 1 #index = index + 1
	
	var swapWeapon = Input.is_action_just_released("SwapWeapon")
	if(swapWeapon && swapWeaponTimer > swapWeaponInterval):
		swapWeaponTimer = 0
		get_equipped_weapon().process_mode = Node.PROCESS_MODE_DISABLED
		get_equipped_weapon().visible = false
		is_primary = !is_primary
		get_equipped_weapon().process_mode = Node.PROCESS_MODE_ALWAYS
		get_equipped_weapon().visible = true
		MissionManager.set_weapon(get_equipped_weapon())
	
	swapWeaponTimer += 1

func handle_pausing():
	var pause = Input.is_action_just_pressed("pause")
	if(pause):
		get_tree().paused = true #pause
		%PauseScreen.visible = true #show pause screen
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func health_regen(delta):
	if(health > maxHealth):
		health = maxHealth
	else:
		health += healthRegen * delta

func get_equipped_weapon():
	if(is_primary):
		return %Primary
	else:
		return %Secondary
