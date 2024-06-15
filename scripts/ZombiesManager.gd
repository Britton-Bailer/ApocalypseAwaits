extends Node2D

#order should match order of enums
const zombieTypes = [preload("res://prefabs/zombie.tscn")]

func spawn_zombie(pos: Vector2, type: enums.zombie):
	var newZomb = zombieTypes[type].instantiate()
	newZomb.position = pos
	newZomb.target = %player
	self.add_child(newZomb)
	
	newZomb._ready()
	
