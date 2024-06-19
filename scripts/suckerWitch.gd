extends ZombieController

@export var spawnInterval = 400
@export var spawnRange = 100

var spawnTimer = 0

## doesnt care about target, wander aimlessly
func can_see_target():
	return false

func spawn_sucker():
		spawnTimer = 0
		var newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
		$NavigationAgent2D.target_position = newPos
		while(!$NavigationAgent2D.is_target_reachable()):
			newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
			$NavigationAgent2D.target_position = newPos
		
		get_parent().spawn_zombie(newPos, enums.zombie.sucker)

## zombie takes damage
func take_damage(amt):
	#decrement health
	if(health > 0):
		health -= amt
		
		#if health is at or below 0, delete zombie
		if(health <= 0):
			for i in randi_range(2,5):
				spawn_sucker()
			queue_free()
