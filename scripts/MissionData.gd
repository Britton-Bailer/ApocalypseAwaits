extends Resource

class_name MissionData

#variables
@export var missionType = enums.missionType.eradicate
@export var bountyTarget = Zombies.type.base
@export var killGoal = 10
@export var requiresExtract = false
@export var moneyGoal = 10
@export var numSpawners = 2
@export var spawnersRadius = 1000
@export var spawnRateRange = Vector2(300, 500)
@export var ambientSpawn = false
@export var ambientSpawnQueue: Array[Zombies.type]
@export var ambientSpawnRateRange = Vector2(500, 1000)
@export var maxZombies = 100
@export var damageMultipler = 1

@export var spawnWeights: SpawnWeights

#uneditable
var spawnersDestroyed = 0
var moneyEarned = 0
var killCount = 0
var canExtract = false
var allSpawnersDestroyed = false
var allZombiesKilled = false
