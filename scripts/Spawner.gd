extends Node2D

var timer = 0
var spawnInterval = 200
var range = 200

var health = 200

var newPos: Vector2
@onready var nav_agent = %NavAgent

func _process(delta):
	if(timer >= spawnInterval):
		timer = 0
		newPos = global_position + Vector2(randf_range(-range, range), randf_range(-range, range))
		nav_agent.target_position = newPos
		while(!nav_agent.is_target_reachable()):
			newPos = global_position + Vector2(randf_range(-range, range), randf_range(-range, range))
			nav_agent.target_position = newPos
		
		Zombies.spawn_zombie(newPos, enums.zombie.base)

	timer += 1

## takes damage
func take_damage(amt):
	#decrement health
	health -= amt
	
	#if health is at or below 0, delete zombie
	if(health <= 0):
		queue_free()
