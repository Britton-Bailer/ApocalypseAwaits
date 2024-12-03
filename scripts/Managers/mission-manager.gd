extends Node2D

class_name MissionManager

var ambientSpawnerPrefab = preload("res://prefabs/ambient-spawner.tscn")
var zombiesManagerPrefab = preload("res://prefabs/Managers/ZombiesManager.tscn")
var coinsManagerPrefab = preload("res://prefabs/Managers/CoinsManager.tscn")
var spawnersManagerPrefab = preload("res://prefabs/Managers/SpawnersManager.tscn")
var projectilesManagerPrefab = preload("res://prefabs/Managers/ProjectilesManager.tscn")
var navAgentPlacementPrefab = preload("res://prefabs/Managers/NavAgentPlacement.tscn")
var hudManagerPrefab = preload("res://prefabs/Managers/HUDManager.tscn")

var ambientSpawner
var zombiesManager
var coinsManager
var spawnersManager
var projectilesManager
var navAgentPlacement
var hudManager

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	create_and_set_managers()
	
	ExpeditionManager.set_managers(ambientSpawner, zombiesManager, coinsManager, spawnersManager, projectilesManager, navAgentPlacement, hudManager)
	ExpeditionManager.start_next_round(self)

func create_and_set_managers():
	ambientSpawner = ambientSpawnerPrefab.instantiate()
	add_child(ambientSpawner)
	
	zombiesManager = zombiesManagerPrefab.instantiate()
	add_child(zombiesManager)
	
	coinsManager = coinsManagerPrefab.instantiate()
	add_child(coinsManager)
	
	spawnersManager = spawnersManagerPrefab.instantiate()
	add_child(spawnersManager)
	
	projectilesManager = projectilesManagerPrefab.instantiate()
	add_child(projectilesManager)
	
	navAgentPlacement = navAgentPlacementPrefab.instantiate()
	add_child(navAgentPlacement)
	
	hudManager = hudManagerPrefab.instantiate()
	add_child(hudManager)
