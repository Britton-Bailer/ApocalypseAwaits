extends Node2D

class_name BaseManager

var ambientSpawner
var zombiesManager
var coinsManager
var spawnersManager
var bulletsManager
var navAgentPlacement
var hudManager

func set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, bltsMngr, navAgentPlcmnt, hudMngr):
	ambientSpawner = ambSpwnr
	zombiesManager = zmbsMngr
	coinsManager = cnsMngr
	spawnersManager = spwnrsMngr
	bulletsManager = bltsMngr
	navAgentPlacement = navAgentPlcmnt
	hudManager = hudMngr
