extends BaseManager

@onready var ammoText = $GameUI/AmmoText
@onready var ammoIndicator = $GameUI/AmmoIndicator
@onready var fpsIndicator = $GameUI/FPSIndicator
@onready var missionTypeText = $GameUI/MissionTypeText
@onready var healthIndicator = $GameUI/HealthIndicator
@onready var staminaIndicator = $GameUI/StaminaIndicator
@onready var minimap = $GameUI/Minimap

func set_vars(plr, wpn, tlmps):
	ammoText.set_weapon(wpn)
	ammoIndicator.set_weapon(wpn)
	healthIndicator.set_player(plr)
	staminaIndicator.set_player(plr)
	minimap.set_vars(plr, tlmps)
	
