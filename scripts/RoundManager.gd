extends Node2D

var missionType = enums.missionType.piggyBank

var roundNum = 0
var bountyTarget = enums.zombie.base
var killGoal = 10
var killCount = 0
var canExtract = false
var requiresExtract = true
var moneyEarned = 0
var moneyGoal = 10
var spawnersDestroyed = 0
var numSpawners = 2
var allSpawnersDestroyed = false
var allZombiesKilled = false

var missions = []

@onready var timer = $Timer
@onready var Enums = enums.new()
## bounty
func zombie_killed(type: enums.zombie, isMoreZombies: bool):
	if(missionType == enums.missionType.eradicate):
		print(isMoreZombies)
		allZombiesKilled = !isMoreZombies
		check_eradicate_win_condition()
	
	if(type == bountyTarget):
		killCount += 1
	
	if(missionType == enums.missionType.bounty && killCount >= killGoal):
		if(requiresExtract):
			canExtract = true
		else:
			round_win()

## piggyBank
func money_picked_up(amt):
	moneyEarned += amt

	if(missionType == enums.missionType.piggyBank && moneyEarned >= moneyGoal):
		if(requiresExtract):
			canExtract = true
		else:
			round_win()

func spawner_destroyed():
	numSpawners -= 1
	
	if(numSpawners == 0):
		print("all spawners destroyed")
		allSpawnersDestroyed = true
		
		if(missionType == enums.missionType.eradicate):
			check_eradicate_win_condition()

func check_eradicate_win_condition():
	if(allSpawnersDestroyed && allZombiesKilled):
		if(requiresExtract):
			canExtract = true
		else:
			round_win()

func extract_attempt():
	if(canExtract):
		round_win()


func round_win():
	roundNum += 1
	print("ROUND WIN")

func round_loss():
	print("GAME OVER")

func _on_timer_timeout():
	if(requiresExtract):
		canExtract = true
	else:
		round_win()

func get_mission_name():
	var name = Enums.mission_name(missionType)
	var extraInfo = ""
	if(missionType == enums.missionType.bounty):
		extraInfo = " Target: " + Enums.zombie_name(bountyTarget) + "(" + str(killCount) + "/" + str(killGoal) + ")"
	elif(missionType == enums.missionType.piggyBank):
		extraInfo = " Collect coins:" + "(" + str(moneyEarned) + "/" + str(moneyGoal) + ")"
	return name + extraInfo

func set_next_round():
	bountyTarget = enums.zombie.base
	killGoal = 15
	moneyGoal = 100
	numSpawners = 2

func reset_round():
	killCount = 0
	canExtract = false
	requiresExtract = false
	moneyEarned = 0
	spawnersDestroyed = 0
	allSpawnersDestroyed = false
	allZombiesKilled = false
