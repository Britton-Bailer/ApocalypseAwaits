extends Node2D

class_name BaseManager

var ambientSpawner
var zombiesManager
var coinsManager
var spawnersManager
var projectilesManager
var navAgentPlacement
var hudManager

func set_managers(ambSpwnr, zmbsMngr, cnsMngr, spwnrsMngr, prjctlsMngr, navAgentPlcmnt, hudMngr):
	ambientSpawner = ambSpwnr
	zombiesManager = zmbsMngr
	coinsManager = cnsMngr
	spawnersManager = spwnrsMngr
	projectilesManager = prjctlsMngr
	navAgentPlacement = navAgentPlcmnt
	hudManager = hudMngr
