extends Node2D

@onready var player_spawn = $PlayerSpawn

func get_player_spawn():
	return player_spawn.position
