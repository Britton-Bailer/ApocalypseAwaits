extends MissionManager

var missionScene = preload("res://scenes/Mission.tscn")

var missionTypeOption1
var missionTypeOption2

@onready var mission_option_1 = $MissionOption1
@onready var mission_option_2 = $MissionOption2

func _ready():
	var Enums = enums.new()
	select_mission_options()
	mission_option_1.text = Enums.mission_name(missionTypeOption1)
	mission_option_2.text = Enums.mission_name(missionTypeOption2)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	create_and_set_managers()
	
	ExpeditionManager.set_managers(ambientSpawner, zombiesManager, coinsManager, spawnersManager, projectilesManager, navAgentPlacement, hudManager)
	ExpeditionManager.start_mission_selection(self)

func create_and_set_managers():
	super()

func _on_select_1_body_entered(_body):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ExpeditionManager.set_mission_type(missionTypeOption1)
	get_tree().change_scene_to_packed(missionScene)

func _on_select_2_body_entered(_body):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ExpeditionManager.set_mission_type(missionTypeOption2)
	get_tree().change_scene_to_packed(missionScene)

func select_mission_options():
	var missionTypeOptions = ExpeditionManager.missionsList.get_list(ExpeditionManager.missionNum).missionTypeOptions
	
	missionTypeOption1 = missionTypeOptions.pick_random()
	missionTypeOption2 = missionTypeOptions.pick_random()
	
	if(missionTypeOptions.size() < 2): #only one option, so they will always be the same
		return
	
	#there are more than 1 option, so dont let the options be the same
	while missionTypeOption2 == missionTypeOption1:
		missionTypeOption2 = missionTypeOptions.pick_random()
