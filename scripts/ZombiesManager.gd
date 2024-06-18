extends Node2D

@export var max_zombies = 100

#order should match order of enums
const zombieTypes = [preload("res://prefabs/zombies/zombie.tscn"), 
	preload("res://prefabs/zombies/throwZombie.tscn"), 
	preload("res://prefabs/zombies/babyZombie.tscn"), 
	preload("res://prefabs/zombies/suckerZombie.tscn"),
	preload("res://prefabs/zombies/suckerWitch.tscn"),
	preload("res://prefabs/zombies/charger.tscn"),
	
	
	]
const zombieSpawnParticles = preload("res://prefabs/particles/zombie_spawn_particles.tscn")

func spawn_zombie(pos: Vector2, type: enums.zombie):
	if(get_child_count() >= max_zombies):
		return
	
	var parts = zombieSpawnParticles.instantiate()
	parts.position = pos
	parts.emitting = true
	particles.add_child(parts)
	
	await parts.get_node("Timer").timeout
	
	var newZomb = zombieTypes[type].instantiate()
	newZomb.position = pos
	newZomb.target = %player
	self.add_child(newZomb)
	
	newZomb._ready()
	
	print("Num zombies: " + str(get_child_count()))
