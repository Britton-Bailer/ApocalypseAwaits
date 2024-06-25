extends MissionManager

var missionOptions = [preload("res://scenes/main.tscn"), preload("res://scenes/Shop.tscn")]

func _ready():
	select_mission_options()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	create_and_set_managers()
	
	ExpeditionManager.set_managers(ambientSpawner, zombiesManager, coinsManager, spawnersManager, bulletsManager, navAgentPlacement, hudManager)
	ExpeditionManager.start_mission_selection(self)

func create_and_set_managers():
	super()

func _on_select_1_body_entered(body):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_packed(missionOptions[0])

func _on_select_2_body_entered(body):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_packed(missionOptions[1])

func select_mission_options():
	pass
