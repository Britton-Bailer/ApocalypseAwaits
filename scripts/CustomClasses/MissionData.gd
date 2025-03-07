extends Resource

class_name MissionData

#variables
@export var missionTypeOptions: Array[enums.missionType]
@export var maxZombies = 250
@export var damageMultipler = 1
@export var spawnWeights: SpawnWeights
@export var missionFailTime = 180
@export var missionExtractTime = 60
@export var possibleMaps: Array[PackedScene]

@export_category("Spawners")
@export var numSpawners = 2
@export var spawnersRadius = 1000
@export var spawnRateRange = Vector2(300, 500)

@export_category("Ambient Spawner")
@export var ambientSpawnQueue: Array[Zombies.type]
@export var ambientSpawnRateRange = Vector2(500, 1000)

@export_group("Bounty Variables")
@export var bountyTarget = Zombies.type.base
@export var killGoal = 0

@export_group("Piggy Bank Variables")
@export var moneyGoal = 0

#uneditable
var spawnersDestroyed = 0
var moneyEarned = 0
var killCount = 0
var canExtract = false
