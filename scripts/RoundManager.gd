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
	add_child(ambientSpawner)
	
	zombiesManager = zombiesManagerPrefab.instantiate()
	add_child(zombiesManager)
	
	coinsManager = coinsManagerPrefab.instantiate()
	add_child(coinsManager)
	
	spawnersManager = spawnersManagerPrefab.instantiate()
	add_child(spawnersManager)
	
	bulletsManager = bulletsManagerPrefab.instantiate()
	add_child(bulletsManager)
	
	navAgentPlacement = navAgentPlacementPrefab.instantiate()
	add_child(navAgentPlacement)
	
	
	MissionManager.set_managers(ambientSpawner, zombiesManager, coinsManager, spawnersManager, bulletsManager, navAgentPlacement)
	MissionManager.start_next_round()
