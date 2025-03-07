extends Resource

class_name ExpeditionStats

@export var playerMaxHealth = 0.0
@export var playerSpeed = 0.0
@export var playerHealthRegenMultiplier = 0.0
@export var playerArmor = 0.0 #not implemented yet
@export var playerStaminaDrainMultiplier = 0.0
@export var playerStaminaRegenMultiplier = 0.0

@export var zombieHealthMultiplier = 0.0
@export var zombieDamageMultiplier = 0.0
@export var zombieDropMultiplier = 0.0 #not implemented yet
@export var zombieSpeedMultiplier = 0.0

@export var bulletSpeedMultiplier = 0.0
@export var bulletDamageMultiplier = 0.0
@export var bulletMaxPierces = 0
@export var bulletPierceDamageMultiplier = 0.0

@export var weaponReloadSpeedMultiplier = 0.0
@export var weaponBulletCostMultiplier = 0.0
@export var weaponMagSizeMultiplier = 0.0
@export var weaponSpreadMultiplier = 0.0
@export var weaponManeuverabilityMultiplier = 0.0
@export var weaponRangeMultiplier = 0.0

func get_properties():
	var props = []
	props.append({name = "max health", type = "default", value = playerMaxHealth, varName = "playerMaxHealth"})
	props.append({name = "speed", type = "default", value = playerSpeed, varName = "playerSpeed"})
	props.append({name = "health regen", type = "multiplier", value = playerHealthRegenMultiplier, varName = "playerHealthRegenMultiplier"})
	props.append({name = "armor", type = "default", value = playerArmor, varName = "playerArmor"})
	props.append({name = "stamina drain", type = "multiplier", value = playerStaminaDrainMultiplier, varName = "playerStaminaDrainMultiplier"})
	props.append({name = "stamina regen", type = "multiplier", value = playerStaminaRegenMultiplier, varName = "playerStaminaRegenMultiplier"})
	
	props.append({name = "zombie health", type = "multiplier", value = zombieHealthMultiplier, varName = "zombieHealthMultiplier"})
	props.append({name = "zombie damage", type = "multiplier", value = zombieDamageMultiplier, varName = "zombieDamageMultiplier"})
	props.append({name = "zombie currency drop chance", type = "multiplier", value = zombieDropMultiplier, varName = "zombieDropMultiplier"})
	props.append({name = "zombie speed", type = "multiplier", value = zombieSpeedMultiplier, varName = "zombieSpeedMultiplier"})
	
	props.append({name = "player bullet speed", type = "multiplier", value = bulletSpeedMultiplier, varName = "bulletSpeedMultiplier"})
	props.append({name = "player bullet damage", type = "multiplier", value = bulletDamageMultiplier, varName = "bulletDamageMultiplier"})
	props.append({name = "pierce targets", type = "default", value = bulletMaxPierces, varName = "bulletMaxPierces"})
	props.append({name = "player bullet pierce damage", type = "multiplier", value = bulletPierceDamageMultiplier, varName = "bulletPierceDamageMultiplier"})
	
	props.append({name = "weapon reload speed", type = "multiplier", value = weaponReloadSpeedMultiplier, varName = "weaponReloadSpeedMultiplier"})
	props.append({name = "weapon bullet cost", type = "multiplier", value = weaponBulletCostMultiplier, varName = "weaponBulletCostMultiplier"})
	props.append({name = "mag size", type = "multiplier", value = weaponMagSizeMultiplier, varName = "weaponMagSizeMultiplier"})
	props.append({name = "bullet spread", type = "multiplier", value = weaponSpreadMultiplier, varName = "weaponSpreadMultiplier"})
	props.append({name = "weapon maneuverability", type = "multiplier", value = weaponManeuverabilityMultiplier, varName = "weaponManeuverabilityMultiplier"})
	props.append({name = "bullet range", type = "multiplier", value = weaponRangeMultiplier, varName = "weaponRangeMultiplier"})

	return props
