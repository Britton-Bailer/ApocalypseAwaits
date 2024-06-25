extends Node2D

@onready var navAgentPlacement = ExpeditionManager.navAgentPlacement
@onready var zombiesManager = ExpeditionManager.zombiesManager

var timer = 0
@export var spawnInterval = 400
@export var spawnRange = 200
var spawnRateRange = Vector2(300,500)

var health = 400

var cumulative_weights: Array = []
var total_weight: int = 0

var zombies = Zombies.new()

func _ready():
	calculate_cumulative_weights()
	spawnRateRange = ExpeditionManager.missionData.spawnRateRange
	spawnInterval = randi_range(spawnRateRange.x, spawnRateRange.y)

func _process(_delta):
	if(timer >= spawnInterval):
		spawnInterval = randi_range(spawnRateRange.x, spawnRateRange.y)
		timer = 0
		var newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
		var zombieType = select_zombie()
		
		navAgentPlacement.get_node("NavAgent").target_position = newPos
		while(!navAgentPlacement.get_node("NavAgent").is_target_reachable()):
			newPos = global_position + Vector2(randf_range(-spawnRange, spawnRange), randf_range(-spawnRange, spawnRange))
			navAgentPlacement.get_node("NavAgent").target_position = newPos
		
		zombiesManager.spawn_zombie(newPos, zombieType)

	timer += 1

## takes damage
func take_damage(amt):
	if(health > 0):
		#decrement health
		health -= amt
		
		#if health is at or below 0, delete zombie
		if(health <= 0):
			ExpeditionManager.spawner_destroyed()
			queue_free()

# Function to calculate cumulative weights
func calculate_cumulative_weights():
	total_weight = 0
	cumulative_weights.clear()
	
	for key in ExpeditionManager.missionData.spawnWeights.weights.keys():
		total_weight += ExpeditionManager.missionData.spawnWeights.weights[key]
		cumulative_weights.append({"type": key, "cumulative_weight": total_weight})

# Function to select a zombie based on weights
func select_zombie() -> int:
	if total_weight == 0:
		return zombies.type.base
	
	var rand_value = randi_range(0, total_weight - 1)
	
	for zombie in cumulative_weights:
		if rand_value < zombie.cumulative_weight:
			return zombies.nameToEnum[zombie.type]
	
	return zombies.type.base
