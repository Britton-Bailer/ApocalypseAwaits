extends Node2D

var timer = 0
@export var spawnInterval = 400
@export var spawnRange = 200

var health = 400

@onready var nav_agent_small = %NavAgentSmall
@onready var nav_agent_medium = %NavAgentMedium
@onready var nav_agent_large = %NavAgentLarge
@onready var zombies = %Zombies

func _process(_delta):
	if(timer >= spawnInterval):
		timer = 0
		var newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
		var zombieType = [enums.zombie.base, enums.zombie.throw, enums.zombie.baby, enums.zombie.suckerWitch].pick_random()
		
		nav_agent_large.target_position = newPos
		while(!nav_agent_large.is_target_reachable()):
			newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
			nav_agent_large.target_position = newPos
		
		zombies.spawn_zombie(newPos, zombieType)

	timer += 1

## takes damage
func take_damage(amt):
	#decrement health
	health -= amt
	
	#if health is at or below 0, delete zombie
	if(health <= 0):
		queue_free()
