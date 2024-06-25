extends BaseManager

@onready var survival_timer = $SurvivalTimer
@onready var extract_timer = $ExtractTimer
@onready var mission_fail_timer = $MissionFailTimer

@onready var ENUMS = enums.new()
var missionsList = preload("res://MissionsList.tres")
var playerPrefab = preload("res://prefabs/player.tscn")
var player
var tilemaps

var missionNum = -1
var currency = 1000
var missionData: MissionData
var items: Array[BaseItemResource] = [preload("res://scripts/Items/RecoilForDumbies.tres")]
var expeditionStats

var zombies = Zombies.new()

## bounty
func zombie_killed(type: Zombies.type, isMoreZombies: bool):
	if(missionData.missionType == enums.missionType.eradicate):
		check_eradicate_win_condition()
	
	if(type == missionData.bountyTarget):
		missionData.killCount += 1
	
	if(missionData.missionType == enums.missionType.bounty && missionData.killCount >= missionData.killGoal):
		mission_finished()

## piggyBank
func money_picked_up(worth):
	missionData.moneyEarned += worth
	currency += worth

	hudManager.update_money(currency)

	if(missionData.missionType == enums.missionType.piggyBank && missionData.moneyEarned >= missionData.moneyGoal):
		mission_finished()

func shot_fired(shotCost):
	currency -= shotCost
	hudManager.update_money(currency)

func spawner_destroyed():
	missionData.numSpawners -= 1
		
	if(missionData.missionType == enums.missionType.eradicate):
		check_eradicate_win_condition()

func check_eradicate_win_condition():
	if(spawnersManager.get_child_count() == 0 && zombiesManager.get_child_count() <= 1) || (spawnersManager.get_child_count() <= 1 && zombiesManager.get_child_count() == 0):
		mission_finished()

func extract_attempt():
	if(missionData.canExtract):
		mission_extract()

func mission_extract():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().call_deferred("change_scene_to_file", "res://scenes/MissionSelection.tscn")

func mission_finished():
	mission_fail_timer.stop()
	if(missionData.requiresExtract):
		missionData.canExtract = true
		extract_timer.start(missionData.missionExtractTime)
		hudManager.set_timer(extract_timer)
		hudManager.flash_text("Mission finished, get to extract!", str(missionData.missionExtractTime) + " seconds left!", 0.05)
	else:
		mission_extract()

func mission_failed():
	missionNum = -1
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func get_mission_name():
	return ENUMS.mission_name(missionData.missionType)

func get_mission_info():
	var extraInfo = ""
	if(missionData.missionType == enums.missionType.bounty):
		extraInfo = "Kill " + str(missionData.killGoal) + " " + zombies.zombie_name(missionData.bountyTarget) + "s"
	elif(missionData.missionType == enums.missionType.piggyBank):
		extraInfo = "Collect " + str(missionData.moneyGoal) + " coins"
	elif(missionData.missionType == enums.missionType.eradicate):
		extraInfo = "Destroy all Spawners (" + str(missionData.numSpawners) + ") and Zombies"
	
	if(missionData.requiresExtract):
		extraInfo += " and extract"
	
	return extraInfo

func set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, bltsMngr, navAgentPlcmnt, hudMngr):
	ambientSpawner = ambSpwnr
	zombiesManager = zmbsMngr
	coinsManager = cnsMngr
	spawnersManager = spwnrsMngr
	bulletsManager = bltsMngr
	navAgentPlacement = navAgentPlcmnt
	hudManager = hudMngr
	
	ambientSpawner.set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, bltsMngr, navAgentPlcmnt, hudMngr)
	zombiesManager.set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, bltsMngr, navAgentPlcmnt, hudMngr)
	spawnersManager.set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, bltsMngr, navAgentPlcmnt, hudMngr)
	bulletsManager.set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, bltsMngr, navAgentPlcmnt, hudMngr)

func start_next_round(rndMngr):
	missionNum += 1
	expeditionStats = preload("res://BaseStats.tres")
	apply_items()
	
	missionData = missionsList.get_list(missionNum)
	var newPlayer = playerPrefab.instantiate()
	newPlayer.position = Vector2.ZERO
	rndMngr.add_child(newPlayer)
	player = newPlayer
	
	ambientSpawner.set_vars(missionData.ambientSpawnQueue, missionData.ambientSpawn, missionData.ambientSpawnRateRange)
	spawnersManager.set_vars(missionData.numSpawners, missionData.spawnersRadius)
	hudManager.set_vars(player, tilemaps, missionNum+1, get_mission_name(), get_mission_info())
	zombiesManager.set_vars(player)
	hudManager.update_money(currency)
	
	mission_fail_timer.start(missionData.missionFailTime)
	hudManager.set_timer(mission_fail_timer)

func start_mission_selection(rndMngr):
	expeditionStats = preload("res://BaseStats.tres")
	apply_items()
	
	missionData = preload("res://Missions/MissionSelect.tres")
	var newPlayer = playerPrefab.instantiate()
	newPlayer.position = Vector2.ZERO
	rndMngr.add_child(newPlayer)
	player = newPlayer
	
	ambientSpawner.set_vars(missionData.ambientSpawnQueue, false, missionData.ambientSpawnRateRange)
	spawnersManager.set_vars(0, missionData.spawnersRadius)
	hudManager.set_vars(player, tilemaps, missionNum+1, get_mission_name(), get_mission_info())
	zombiesManager.set_vars(player)
	hudManager.update_money(currency)

func set_tilemaps(tlmps):
	tilemaps = tlmps

func set_weapon(weapon):
	hudManager.set_weapon(weapon)

func add_item(item: BaseItemResource):
	items.append(item)

func apply_items():
	for item in items:
		item.apply_item(expeditionStats)

func _on_survival_timer_timeout():
	mission_finished()

func _on_extract_timer_timeout():
	mission_failed()

func _on_mission_fail_timer_timeout():
	mission_failed()
