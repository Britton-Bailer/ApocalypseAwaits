extends ZombieController

## Charger-specific variables ##
var chargeDistance = 150  ## Distance threshold to trigger charge attack
var chargeSpeedMultiplier = 3  ## Speed multiplier during charge
var chargeDamageMultiplier = 6
var isCharging = false  ## Flag to track if zombie is currently charging
var originalSpeed  ## Variable to store the original speed for restoration after charge
var originalTouchDamage

var chargingCooldownTimer = 0
var chargeCooldownTime = 700  ## Cooldown time after charge (in milliseconds)
var canCharge = true
var chargeDir = Vector2.ZERO

## Override _ready function to initialize originalSpeed ##
func ready():
	originalSpeed = roamingSpeed

## Override can_attack function to trigger charge attack ##
func can_attack():
	return position.distance_to(target.position) <= chargeDistance && canCharge

## Override attack function to handle charge attack ##
func attack(delta):
	if can_attack():
		isCharging = true
		canCharge = false
		currentState = enums.zombieState.CHASING
		originalSpeed = speed  ## Store original speed
		originalTouchDamage = touchDamage
		touchDamage = touchDamage * chargeDamageMultiplier
		speed = chasingSpeed * chargeSpeedMultiplier  ## Increase speed for charge
		canUpdateTargeting = false #turn off targeting while charging (charge in straight line)
		set_charge_direction()
	else:
		currentState = enums.zombieState.ROAMING
		speed = roamingSpeed  # Ensure speed is reset to roamingSpeed if not charging

	navigation(delta)

func process(delta):
	if(isCharging):
		lastSeenTarget = global_position + chargeDir * 30
		update_targeting()
		speed = chasingSpeed * chargeSpeedMultiplier
		await get_tree().create_timer(1.0).timeout
		canUpdateTargeting = true #turn targeting back on
		chargingCooldownTimer = 0
		isCharging = false
		speed = originalSpeed  # Restore original speed after charge
		touchDamage = originalTouchDamage

	if(chargingCooldownTimer <= chargeCooldownTime):
		chargingCooldownTimer += 1
	else:
		canCharge = true

func set_charge_direction():
	chargeDir = ((target.position + target.linear_velocity * global_position.distance_to(target.global_position)/300) - global_position).normalized()

#await get_tree().create_timer(chargeCooldownTime / 1000.0).timeout
