extends BaseManager

@onready var ammoText = $GameUI/AmmoText
@onready var ammoIndicator = $GameUI/AmmoIndicator
@onready var fpsIndicator = $GameUI/FPSIndicator
@onready var missionTypeText = $GameUI/MissionTypeText
@onready var healthIndicator = $GameUI/HealthIndicator
@onready var staminaIndicator = $GameUI/StaminaIndicator
@onready var minimap = $GameUI/Minimap
@onready var missionLabels = $GameUI/MissionLabels
@onready var coinLabel = $GameUI/CoinLabel

func set_vars(plr, wpn, tlmps, mssnNum, mssnName, mssnInfo):
	ammoText.set_weapon(wpn)
	ammoIndicator.set_weapon(wpn)
	healthIndicator.set_player(plr)
	staminaIndicator.set_player(plr)
	minimap.set_vars(plr, tlmps)
	missionLabels.set_vars(mssnNum, mssnName, mssnInfo)
	missionTypeText.set_vars(mssnNum, mssnName, mssnInfo)

func set_money(amt):
	coinLabel.text = "Coins: " + str(amt)
