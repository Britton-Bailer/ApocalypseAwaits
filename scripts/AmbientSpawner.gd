extends BaseManager

var timer = 0
var spawnInterval = 400
var spawnRange = 1000
var spawnRateRange = Vector2(200,400)
var canSpawn = false
var spawnQueue = []
var spawnIndex = 0

var health = 400

func _process(_delta):
	if(canSpawn && timer >= spawnInterval):
		spawnInterval = randi_range(spawnRateRange.x, spawnRateRange.y)
		timer = 0
		var newPos = global_position + Vector2(randi_range(-spawnRange, spawnRange), randi_range(-spawnRange, spawnRange))
		var zombieType = spawnQueue[spawnIndex]
		
		if(spawnIndex + 1 >= spawnQueue.size()):
			spawnIndex = 0
		else:
			spawnIndex += 1
		
		navAgentPlacement.get_node("NavAgent").target_position = newPos
		while(!navAgentPlacement.get_node("NavAgent").is_target_reachable()):
			newPos = global_position + Vector2(randi_range(-spawnRange, spawnRange), randi_range(-spawnRange, spawnRange))
			navAgentPlacement.get_node("NavAgent").target_position = newPos
		
		zombiesManager.spawn_zombie(newPos, zombieType)

	timer += 1

func set_vars(queue, cnSpwn, spwnRng):
	spawnQueue = queue
	spawnIndex = 0
	canSpawn = cnSpwn
	spawnRateRange = spwnRng
	spawnInterval = randi_range(spawnRateRange.x, spawnRateRange.y)
