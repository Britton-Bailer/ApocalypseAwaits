extends BaseManager

@onready var timer = $Timer
@onready var ENUMS = enums.new()
var missionsList = preload("res://MissionsList.tres")
var playerPrefab = preload("res://prefabs/player.tscn")
var player
var tilemaps

var missionNum = 0
var missionData: MissionData

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
func money_picked_up(amt):
	missionData.moneyEarned += amt

	if(missionData.missionType == enums.missionType.piggyBank && missionData.moneyEarned >= missionData.moneyGoal):
		if(missionData.requiresExtract):
			missionData.canExtract = true
		else:
			round_win()

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
	player.free()
	missionNum += 1
	print("ROUND WIN")
	get_tree().call_deferred("change_scene_to_file", "res://scenes/MainMenu.tscn")

func round_loss():
	pass

func _on_timer_timeout():
	if(missionData.requiresExtract):
		missionData.canExtract = true
	else:
		round_win()

func get_mission_name():
	var name = ENUMS.mission_name(missionData.missionType)
	var extraInfo = ""
	if(missionData.missionType == enums.missionType.bounty):
		extraInfo = " (Target: " + zombies.zombie_name(missionData.bountyTarget) + " " + str(missionData.killCount) + "/" + str(missionData.killGoal) + ")"
	elif(missionData.missionType == enums.missionType.piggyBank):
		extraInfo = " (Collect coins:" + str(missionData.moneyEarned) + "/" + str(missionData.moneyGoal) + ")"
	elif(missionData.missionType == enums.missionType.eradicate):
		extraInfo = " (Destroy all Spawners (" + str(missionData.numSpawners) + ") and Zombies)"
	return name + extraInfo

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

func start_next_round():
	missionData = missionsList.get_list(missionNum)
	var newPlayer = playerPrefab.instantiate()
	newPlayer.position = Vector2.ZERO
	get_tree().root.add_child(newPlayer)
	player = newPlayer
	
	ambientSpawner.set_vars(missionData.ambientSpawnQueue, missionData.ambientSpawn, missionData.ambientSpawnRateRange)
	spawnersManager.set_vars(missionData.numSpawners, missionData.spawnersRadius)
	hudManager.set_vars(player, player.get_weapon(), tilemaps)
	zombiesManager.set_vars(player)

func set_tilemaps(tlmps):
	tilemaps = tlmps
