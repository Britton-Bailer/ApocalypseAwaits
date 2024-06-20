extends BaseManager

var max_zombies = 100
var player
var zombies = Zombies.new()

const coin = preload("res://prefabs/coin.tscn")
const zombieSpawnParticles = preload("res://prefabs/particles/zombie_spawn_particles.tscn")

func spawn_zombie(pos: Vector2, type: Zombies.type):
	if(get_child_count() >= max_zombies):
		return
	
	var parts = zombieSpawnParticles.instantiate()
	parts.position = pos
	parts.emitting = true
	ParticlesContainer.add_child(parts)
	
	await parts.get_node("Timer").timeout
	
	var newZomb = zombies.zombiePrefabs[type].instantiate()
	newZomb.position = pos
	newZomb.target = player
	add_child(newZomb)
	
	newZomb._ready()
	print(get_child_count())

func add_coin(pos, worth):
	var newCoin = coin.instantiate()
	newCoin.position = pos
	newCoin.worth = worth
	coinsManager.call_deferred("add_child", newCoin)

func update_max_zombies(num):
	max_zombies = num

func set_vars(plr):
	player = plr

func clear_children():
	for n in get_children():
		n.free()
	return
