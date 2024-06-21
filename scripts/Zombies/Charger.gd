extends ZombieController

## Charger-specific variables ##
var preferredRange = randi_range(120, 160)  ## Preferred range to maintain from the player
var chargeSpeedMultiplier = 3.5  ## Speed multiplier during charge
var chargeDamageMultiplier = 6
var isCharging = false  ## Flag to track if zombie is currently charging
var originalSpeed  ## Variable to store the original speed for restoration after charge
var originalTouchDamage

var chargingCooldownTimer = 0
var cooldownRange = Vector2(300, 600)
var chargeCooldownTime  ## Cooldown time after charge (in milliseconds)
var canCharge = false
var chargeDir = Vector2.ZERO

## Override _ready function to initialize originalSpeed ##
func ready():
	chargeCooldownTime = randi_range(cooldownRange.x, cooldownRange.y)
	originalSpeed = roamingSpeed

## Override can_attack function to trigger charge attack ##
func can_attack():
	return position.distance_to(target.position) <= preferredRange+20 && canCharge

## Override attack function to handle charge attack ##
func attack(delta):
	if can_attack():
		isCharging = true
		canCharge = false
		currentState = Zombies.zombieState.CHASING
		originalSpeed = speed  ## Store original speed
		originalTouchDamage = touchDamage
		touchDamage = touchDamage * chargeDamageMultiplier
		speed = chasingSpeed * chargeSpeedMultiplier  ## Increase speed for charge
		canUpdateTargeting = false #turn off targeting while charging (charge in straight line)
		set_charge_direction()
	else:
		currentState = Zombies.zombieState.ROAMING
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
		chargeCooldownTime = randi_range(cooldownRange.x, cooldownRange.y) # choose random time before next charge
	else:
		move_to_maintain_range(delta)

	if(chargingCooldownTimer <= chargeCooldownTime):
		chargingCooldownTimer += 1
	else:
		canCharge = true

func set_charge_direction():
	chargeDir = ((target.position + target.linear_velocity.normalized() * 75) - global_position).normalized()

## Move towards or away from the player to maintain preferred range ##
func move_to_maintain_range(delta):
	var distance_to_target = position.distance_to(target.position)

	if distance_to_target > preferredRange + 10:
		currentState = Zombies.zombieState.CHASING
		speed = chasingSpeed
		update_targeting()
	elif distance_to_target < preferredRange - 10:
		currentState = Zombies.zombieState.ROAMING
		var direction_to_move = global_position - target.global_position
		navAgent.target_position = global_position + direction_to_move.normalized() * speed * delta
	else:
		velocity = Vector2.ZERO
