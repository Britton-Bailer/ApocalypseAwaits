extends BaseManager

@onready var flashTextPrefab = preload("res://prefabs/flashText.tscn")

@onready var flashTextContainer = $GameUI/FlashTextContainer

@onready var ammoText = $GameUI/AmmoText
@onready var ammoIndicator = $GameUI/AmmoIndicator
@onready var fpsIndicator = $GameUI/FPSIndicator
@onready var missionTypeText = $GameUI/MissionTypeText
@onready var healthIndicator = $GameUI/HealthIndicator
@onready var staminaIndicator = $GameUI/StaminaIndicator
@onready var minimap = $GameUI/Minimap
@onready var currencyLabel = $GameUI/CurrencyLabel

func set_vars(plr, tlmps, mssnNum, mssnName, mssnInfo):
	healthIndicator.set_player(plr)
	staminaIndicator.set_player(plr)
	minimap.set_vars(plr, tlmps)
	missionTypeText.set_vars(mssnNum, mssnName, mssnInfo)
	flash_text("Mission: " + str(mssnNum) + " " + str(mssnName), str(mssnInfo))

func update_money(amt):
	currencyLabel.text = "Bullets: " + str(amt)

func flash_text(mainMessage, subMessage, fadeSpeed = 0.2):
	if(flashTextContainer.get_child_count() == 0):
		var flashText = flashTextPrefab.instantiate()
		flashText.set_vars(mainMessage, subMessage, fadeSpeed)
		flashTextContainer.add_child(flashText)

func set_weapon(wpn):
	ammoText.set_weapon(wpn)
	ammoIndicator.set_weapon(wpn)
