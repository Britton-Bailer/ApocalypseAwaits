extends Node2D

@onready var player

#order should match order of enums
const zombieTypes = [preload("res://prefabs/zombie.tscn")]

func _ready():
	player = get_node("/root/player")

func spawn_zombie(pos: Vector2, type: enums.zombie):
	var newZomb = zombieTypes[type].instantiate()
	newZomb.position = pos
	self.add_child(newZomb)
	
	newZomb.target = player
	
