extends BaseManager

@onready var survival_timer = $SurvivalTimer
@onready var extract_timer = $ExtractTimer
@onready var mission_fail_timer = $MissionFailTimer

@onready var ENUMS = enums.new()
var missionsList = preload("res://MissionsList.tres")
var playerPrefab = preload("res://prefabs/player.tscn")
var player
var tilemaps
var tilemapsContainer

var missionNum = 0
var currency = 1000
var currentMission: MissionData
var items: Array[BaseItemResource] = [preload("res://scripts/Items/RecoilForDumbies.tres")]
var expeditionStats
var missionsRequiringExtract = [enums.missionType.bounty, enums.missionType.piggyBank]
var missionsWithAmbientSpawn = [enums.missionType.bounty, enums.missionType.piggyBank, enums.missionType.defense, enums.missionType.extraction]
var missionType = enums.missionType.eradicate

var zombies = Zombies.new()

## bounty
func zombie_killed(type: Zombies.type):
	if(missionType == enums.missionType.eradicate):
		check_eradicate_win_condition()
	
	if(type == currentMission.bountyTarget && missionType == enums.missionType.bounty):
		currentMission.killCount += 1
		
		if(currentMission.killCount >= currentMission.killGoal):
			mission_finished()
			return
			
		hudManager.flash_text("", "Target down, " + str(currentMission.killGoal - currentMission.killCount) + " to go.", 0.6)

## piggyBank
func money_picked_up(worth):
	currentMission.moneyEarned += worth
	currency += worth

	hudManager.update_money(currency)

	if(missionType == enums.missionType.piggyBank):
		if(currentMission.moneyEarned >= currentMission.moneyGoal):
			mission_finished()
			return
	
		hudManager.flash_text("", str(currentMission.moneyGoal - currentMission.moneyEarned) + " coins to go.", 0.8)

func shot_fired(shotCost):
	currency -= shotCost
	hudManager.update_money(currency)

func spawner_destroyed():
	currentMission.numSpawners -= 1
	
	if(currentMission.numSpawners > 0):
		hudManager.flash_text("", str(currentMission.numSpawners) + " spawners to go.", 0.8)
	
	if(missionType == enums.missionType.eradicate):
		check_eradicate_win_condition()

func check_eradicate_win_condition():
	if(spawnersManager.get_child_count() == 0 && zombiesManager.get_child_count() <= 1) || (spawnersManager.get_child_count() <= 1 && zombiesManager.get_child_count() == 0):
		mission_finished()

func extract_attempt():
	if(currentMission.canExtract):
		mission_extract()

func mission_extract():
	missionNum += 1
	mission_fail_timer.stop()
	extract_timer.stop()
	survival_timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().call_deferred("change_scene_to_file", "res://scenes/MissionSelection.tscn")

func mission_finished():
	mission_fail_timer.stop()
	if(requires_extract()):
		currentMission.canExtract = true
		extract_timer.start(currentMission.missionExtractTime)
		hudManager.set_timer(extract_timer)
		hudManager.flash_text("Mission finished, get to extract!", str(currentMission.missionExtractTime) + " seconds left!", 0.05)
	else:
		mission_extract()

func mission_failed():
	missionNum = -1
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func get_mission_name():
	return ENUMS.mission_name(missionType)

func get_mission_info():
	var extraInfo = ""
	if(missionType == enums.missionType.bounty):
		extraInfo = "Kill " + str(currentMission.killGoal) + " " + zombies.zombie_name(currentMission.bountyTarget) + " zombies"
	elif(missionType == enums.missionType.piggyBank):
		extraInfo = "Collect " + str(currentMission.moneyGoal) + " coins"
	elif(missionType == enums.missionType.eradicate):
		extraInfo = "Destroy all Spawners (" + str(currentMission.numSpawners) + ") and Zombies"
	
	if(requires_extract()):
		extraInfo += " and extract"
	
	return extraInfo

func requires_extract():
	return missionsRequiringExtract.has(missionType)

func has_ambient_spawn():
	return missionsWithAmbientSpawn.has(missionType)

func set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, prjctlsMngr, navAgentPlcmnt, hudMngr):
	ambientSpawner = ambSpwnr
	zombiesManager = zmbsMngr
	coinsManager = cnsMngr
	spawnersManager = spwnrsMngr
	projectilesManager = prjctlsMngr
	navAgentPlacement = navAgentPlcmnt
	hudManager = hudMngr
	
	ambientSpawner.set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, prjctlsMngr, navAgentPlcmnt, hudMngr)
	zombiesManager.set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, prjctlsMngr, navAgentPlcmnt, hudMngr)
	spawnersManager.set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, prjctlsMngr, navAgentPlcmnt, hudMngr)
	projectilesManager.set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, prjctlsMngr, navAgentPlcmnt, hudMngr)

func start_next_round(rndMngr):
	expeditionStats = preload("res://BaseStats.tres")
	apply_items()
	
	currentMission = missionsList.get_list(missionNum)
	var newMap = currentMission.possibleMaps.pick_random().instantiate()
	rndMngr.add_child(newMap)
	
	var newPlayer = playerPrefab.instantiate()
	newPlayer.position = newMap.get_player_spawn()
	rndMngr.add_child(newPlayer)
	player = newPlayer
	
	ambientSpawner.set_vars(currentMission.ambientSpawnQueue, has_ambient_spawn(), currentMission.ambientSpawnRateRange)
	spawnersManager.set_vars(currentMission.numSpawners, currentMission.spawnersRadius)
	hudManager.set_vars(player, tilemaps, missionNum+1, get_mission_name(), get_mission_info(), tilemapsContainer)
	zombiesManager.set_vars(player)
	hudManager.update_money(currency)
	
	mission_fail_timer.start(currentMission.missionFailTime)
	hudManager.set_timer(mission_fail_timer)
	
	#var newCompanion = preload("res://prefabs/companion.tscn").instantiate()
	#newCompanion.position = newMap.get_player_spawn() + Vector2(700, 0)
	#rndMngr.add_child(newCompanion)

func start_mission_selection(rndMngr):
	expeditionStats = preload("res://BaseStats.tres")
	apply_items()
	
	currentMission = preload("res://Missions/MissionSelect.tres")
	var newPlayer = playerPrefab.instantiate()
	newPlayer.position = Vector2.ZERO
	rndMngr.add_child(newPlayer)
	player = newPlayer
	
	ambientSpawner.set_vars(currentMission.ambientSpawnQueue, false, currentMission.ambientSpawnRateRange)
	spawnersManager.set_vars(0, currentMission.spawnersRadius)
	hudManager.set_vars(player, tilemaps, "", "Mission Select", "Select your next mission.", tilemapsContainer)
	zombiesManager.set_vars(player)
	hudManager.update_money(currency)

func set_mission_type(type):
	missionType = type

func set_tilemaps(tlmps, tlmpsCntnr):
	tilemaps = tlmps
	tilemapsContainer = tlmpsCntnr

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
