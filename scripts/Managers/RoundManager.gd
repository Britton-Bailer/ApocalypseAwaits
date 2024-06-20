extends Node2D

var ambientSpawnerPrefab = preload("res://prefabs/AmbientSpawner.tscn")
var zombiesManagerPrefab = preload("res://prefabs/Managers/ZombiesManager.tscn")
var coinsManagerPrefab = preload("res://prefabs/Managers/CoinsManager.tscn")
var spawnersManagerPrefab = preload("res://prefabs/Managers/SpawnersManager.tscn")
var bulletsManagerPrefab = preload("res://prefabs/Managers/BulletsManager.tscn")
var navAgentPlacementPrefab = preload("res://prefabs/Managers/NavAgentPlacement.tscn")
var hudManagerPrefab = preload("res://prefabs/Managers/HUDManager.tscn")

var ambientSpawner
var zombiesManager
var coinsManager
var spawnersManager
var bulletsManager
var navAgentPlacement
var hudManager

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
	
	hudManager = hudManagerPrefab.instantiate()
	add_child(hudManager)
	
	
	MissionManager.set_managers(ambientSpawner, zombiesManager, coinsManager, spawnersManager, bulletsManager, navAgentPlacement, hudManager)
	MissionManager.start_next_round()
