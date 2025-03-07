extends RigidBody2D

@onready var expeditionStats = ExpeditionManager.expeditionStats
@onready var hudManager = ExpeditionManager.hudManager
@onready var primary = %Primary
@onready var secondary = %Secondary
@onready var camera2d = $Camera2D
@onready var hitScreen = $HitScreen

var weapon
var sprintSpeed = 0
var maxSprintSpeed = 50
var maxStamina = 500
var stamina = maxStamina
var staminaDrain = 1
var staminaRegen = 0.25
var exhausted = false
var exhaustedSpeed = 0
var exhaustedSpeedPentalty = -50

var baseMaxSpeed = 150
var maxSpeed
var acceleration = 150
var maxHealth = 100
var health = maxHealth
var healthRegen = 0.1
var targetVelocity = Vector2.ZERO

var swapWeaponTimer = 0
var swapWeaponInterval = 10
var isPrimary = true
var primaryWeapon
var secondaryWeapon

var weapons = [
	preload("res://prefabs/Weapons/AssultRifle.tscn"),
	preload("res://prefabs/Weapons/SMG.tscn"),
	preload("res://prefabs/Weapons/Sniper.tscn"),
	preload("res://prefabs/Weapons/Shotgun.tscn"),
	preload("res://prefabs/Weapons/BurstRifle.tscn"),
	preload("res://prefabs/Weapons/RocketLauncher.tscn")
]
var weaponIndex = 0

var primaryWeaponPrefab
var secondaryWeaponPrefab

func _ready():
	primaryWeaponPrefab = weapons[0]
	secondaryWeaponPrefab = preload("res://prefabs/Weapons/Pistol.tscn")
	set_primary_weapon(primaryWeaponPrefab)
	set_secondary_weapon(secondaryWeaponPrefab)
	weapon = get_equipped_weapon()
	maxSpeed = expeditionStats.playerSpeed
	maxHealth = expeditionStats.playerMaxHealth
	healthRegen *= expeditionStats.playerHealthRegenMultiplier
	staminaDrain *= expeditionStats.playerStaminaDrainMultiplier
	staminaRegen *= expeditionStats.playerStaminaRegenMultiplier

func _physics_process(delta):
	movement(delta)
	cycle_weapons()
	handle_pausing()
	health_regen(delta)
	sprint_exhaustion()

func movement(delta):
	var sprint = Input.is_action_pressed("sprint")
	if sprint && not exhausted:
		sprintSpeed = maxSprintSpeed
		stamina -= staminaDrain
	else:
		stamina += staminaRegen
		sprintSpeed = 0
		
	var left = Input.is_action_pressed("left")
	if left:
		linear_velocity.x += -acceleration
		
	var right = Input.is_action_pressed("right")
	if right:
		linear_velocity.x += acceleration
	
	var up = Input.is_action_pressed("up")
	if up:
		linear_velocity.y += -acceleration
		
	var down = Input.is_action_pressed("down")
	if down:
		linear_velocity.y += acceleration
	
	maxSpeed = baseMaxSpeed + sprintSpeed + exhaustedSpeed
	
	if(linear_velocity.length() > maxSpeed):
		linear_velocity = linear_velocity.normalized() * maxSpeed

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
	apply_shake(dmg)
	hitScreen.reset()
	health -= dmg * ExpeditionManager.currentMission.damageMultipler * expeditionStats.zombieDamageMultiplier
	
	if(health <= 0):
		ExpeditionManager.mission_failed()

func apply_shake(dmg: float = 3.0):
	camera2d.apply_shake(dmg)

func cycle_weapons():
	var changeWeapon = Input.is_action_just_released("changeWeapon")
	if(changeWeapon):
		primaryWeaponPrefab = weapons[weaponIndex]
		set_primary_weapon(primaryWeaponPrefab)
		
		if(weaponIndex + 1 > weapons.size()-1):
			weaponIndex = 0
		else:
			weaponIndex += 1
	
	var swapWeapon = Input.is_action_just_released("SwapWeapon")
	if(swapWeapon && swapWeaponTimer > swapWeaponInterval):
		print("turn off primary")
		swapWeaponTimer = 0
		get_equipped_weapon().get_parent().process_mode = Node.PROCESS_MODE_DISABLED
		get_equipped_weapon().get_parent().visible = false
		isPrimary = !isPrimary
		print("turn on secondary")
		get_equipped_weapon().get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
		get_equipped_weapon().get_parent().visible = true
		ExpeditionManager.set_weapon(get_equipped_weapon())
	
	swapWeaponTimer += 1

func set_primary_weapon(wpnPrefab):
	if(primary.get_child_count() > 0):
		primary.get_child(0).free()
	
	primaryWeapon = wpnPrefab.instantiate()
	primary.add_child(primaryWeapon)
	ExpeditionManager.set_weapon(get_equipped_weapon())

func set_secondary_weapon(wpnPrefab):
	if(secondary.get_child_count() > 0):
		secondary.get_child(0).free()
	
	primaryWeapon = wpnPrefab.instantiate()
	secondary.add_child(primaryWeapon)

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
	if(isPrimary):
		return primary.get_child(0)
	else:
		return secondary.get_child(0)
