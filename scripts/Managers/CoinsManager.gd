extends BaseManager

const coin = preload("res://prefabs/coin.tscn")

func add_coins(pos, num):
	for i in range(num):
		var newCoin = coin.instantiate()
		newCoin.position = pos + Vector2(randf_range(-10, 10), randf_range(-10, 10))
		newCoin.worth = 1
		add_child(newCoin)
