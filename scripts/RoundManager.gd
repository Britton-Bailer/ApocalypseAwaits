extends Node2D

var ambientSpawnerPrefab = preload("res://prefabs/AmbientSpawner.tscn")
var zombiesManagerPrefab = preload("res://prefabs/ZombiesManager.tscn")
var coinsManagerPrefab = preload("res://prefabs/CoinsManager.tscn")
var spawnersManagerPrefab = preload("res://prefabs/SpawnersManager.tscn")
var bulletsManagerPrefab = preload("res://prefabs/BulletsManager.tscn")
var navAgentPlacementPrefab = preload("res://prefabs/NavAgentPlacement.tscn")

var ambientSpawner
var zombiesManager
var coinsManager
var spawnersManager
var bulletsManager
var navAgentPlacement

# Called when the node enters the scene tree for the first time.
func _ready():
	ambientSpawner = ambientSpawnerPrefab.instantiate()
	get_tree().root.add_child(ambientSpawner)
	
	zombiesManager = zombiesManagerPrefab.instantiate()
	get_tree().root.add_child(zombiesManager)
	
	coinsManager = coinsManagerPrefab.instantiate()
	get_tree().root.add_child(coinsManager)
	
	spawnersManager = spawnersManagerPrefab.instantiate()
	get_tree().root.add_child(spawnersManager)
	
	bulletsManager = bulletsManagerPrefab.instantiate()
	get_tree().root.add_child(bulletsManager)
	
	navAgentPlacement = navAgentPlacementPrefab.instantiate()
	get_tree().root.add_child(navAgentPlacement)
	
	
	MissionManager.set_managers(ambientSpawner, zombiesManager, coinsManager, spawnersManager, bulletsManager, navAgentPlacement)
	MissionManager.start_next_round()
# ambient spawner
# zombies manager
# coins
# spawners manager
# bullets manager
# nav Agent placement
