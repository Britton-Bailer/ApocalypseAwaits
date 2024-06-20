extends BaseManager

var spawnRange = 1000
var numSpawners = 0

var spawner = preload("res://prefabs/spawner.tscn")

func spawn_spawners():
	await get_tree().create_timer(0.1).timeout
	for i in numSpawners:
		var newPos = global_position + Vector2(randi_range(-spawnRange, spawnRange), randi_range(-spawnRange, spawnRange))
		
		navAgentPlacement.get_node("NavAgent").target_position = newPos
		while(!navAgentPlacement.get_node("NavAgent").is_target_reachable()):
			newPos = global_position + Vector2(randi_range(-spawnRange, spawnRange), randi_range(-spawnRange, spawnRange))
			navAgentPlacement.get_node("NavAgent").target_position = newPos
		
		var newSpawner = spawner.instantiate()
		newSpawner.position = newPos
		add_child(newSpawner)

func set_vars(num, spwnRng):
	numSpawners = num
	spawnRange = spwnRng
	spawn_spawners()

func clear_children():
	for n in get_children():
		n.free()
	return
