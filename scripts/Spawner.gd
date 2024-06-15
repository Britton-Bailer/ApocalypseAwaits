extends Node2D

var timer = 0
var spawnInterval = 200
var spawnRange = 200

var health = 200

var newPos: Vector2
@onready var nav_agent = %NavAgent
@onready var zombies = %Zombies

func _process(_delta):
	if(timer >= spawnInterval):
		timer = 0
		newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
		nav_agent.target_position = newPos
		while(!nav_agent.is_target_reachable()):
			newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
			nav_agent.target_position = newPos
		
		zombies.spawn_zombie(newPos, randi_range(0, 1))

	timer += 1

## takes damage
func take_damage(amt):
	#decrement health
	health -= amt
	
	#if health is at or below 0, delete zombie
	if(health <= 0):
		queue_free()
