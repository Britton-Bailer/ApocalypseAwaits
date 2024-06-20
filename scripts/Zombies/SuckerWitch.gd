extends ZombieController

@export var spawnInterval = 400
@export var spawnRange = 100
@onready var navAgentPlacement = MissionManager.navAgentPlacement

var spawnTimer = 0

## doesnt care about target, wander aimlessly
func can_see_target():
	return false

func spawn_sucker():
		spawnTimer = 0
		var newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
		navAgentPlacement.get_node("NavAgent").target_position = newPos
		while(!navAgentPlacement.get_node("NavAgent").is_target_reachable()):
			newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
			navAgentPlacement.get_node("NavAgent").target_position = newPos
		
		get_parent().spawn_zombie(newPos, Zombies.type.sucker)

## zombie takes damage
func die():
	for i in randi_range(2,5):
		spawn_sucker()
	queue_free()
