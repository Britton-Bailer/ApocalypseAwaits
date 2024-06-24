extends BaseManager

@onready var timer = $Timer
@onready var ENUMS = enums.new()
var missionsList = preload("res://MissionsList.tres")
var playerPrefab = preload("res://prefabs/player.tscn")
var player
var tilemaps

var missionNum = 0
var currency = 100
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
		if(missionData.requiresExtract):
			missionData.canExtract = true
		else:
			round_win()

## piggyBank
func money_picked_up(worth):
	missionData.moneyEarned += worth
	currency += worth

	hudManager.update_money(currency)

	if(missionData.missionType == enums.missionType.piggyBank && missionData.moneyEarned >= missionData.moneyGoal):
		if(missionData.requiresExtract):
			missionData.canExtract = true
		else:
			round_win()

func shot_fired(shotCost):
	currency -= shotCost
	hudManager.update_money(currency)

func spawner_destroyed():
	missionData.numSpawners -= 1
		
	if(missionData.missionType == enums.missionType.eradicate):
		check_eradicate_win_condition()

func check_eradicate_win_condition():
	if(spawnersManager.get_child_count() == 0 && zombiesManager.get_child_count() <= 1) || (spawnersManager.get_child_count() <= 1 && zombiesManager.get_child_count() == 0):
		if(missionData.requiresExtract):
			missionData.canExtract = true
		else:
			round_win()

func extract_attempt():
	if(missionData.canExtract):
		round_win()

func round_win():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	missionNum += 1
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Shop.tscn")

func round_loss():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _on_timer_timeout():
	if(missionData.requiresExtract):
		missionData.canExtract = true
	else:
		round_win()

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
	expeditionStats = preload("res://BaseStats.tres")
	apply_items()
	
	missionData = missionsList.get_list(missionNum)
	var newPlayer = playerPrefab.instantiate()
	newPlayer.position = Vector2.ZERO
	rndMngr.add_child(newPlayer)
	player = newPlayer
	
	ambientSpawner.set_vars(missionData.ambientSpawnQueue, missionData.ambientSpawn, missionData.ambientSpawnRateRange)
	spawnersManager.set_vars(missionData.numSpawners, missionData.spawnersRadius)
	hudManager.set_vars(player, player.get_equipped_weapon(), tilemaps, missionNum+1, get_mission_name(), get_mission_info())
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

func item_bought(item):
	currency -= item.itemCost
	items.append(item)
