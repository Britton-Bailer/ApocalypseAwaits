extends BaseManager

const coin = preload("res://prefabs/coin.tscn")

func add_coins(pos, worth):
	var newCoin = coin.instantiate()
	newCoin.worth = worth
	newCoin.position = pos + Vector2(randf_range(-10, 10), randf_range(-10, 10))
	call_deferred("add_child", newCoin)
