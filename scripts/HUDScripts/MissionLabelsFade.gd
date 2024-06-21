extends VBoxContainer

@export var fadeSpeed = 0.2 

@onready var mission = $Mission
@onready var mission_description = $MissionDescription
var varsSet = false

func set_vars(mssnNum, mssnName, mssnInfo):
	mission.text = "[center]Mission " + str(mssnNum) + ": " + str(mssnName) + "[/center]"
	mission_description.text = "[center]" + str(mssnInfo) + "[/center]"
	varsSet = true

func _process(delta):
	if !varsSet:
		return
	
	if(modulate.a > 0):
		modulate.a -= fadeSpeed * delta
	else:
		free()
