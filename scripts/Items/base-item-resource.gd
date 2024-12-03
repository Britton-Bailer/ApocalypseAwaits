extends Resource

class_name BaseItemResource

@export var itemName = "default"
@export var itemSprite = preload("res://sprites/Items/DefaultItemSprite.png")
@export var affectedStats: ExpeditionStats
@export var itemCost = 5

func apply_item(stats: ExpeditionStats):
	for prop in affectedStats.get_properties():
		if(prop.value != 0):
			stats[prop.varName] += prop.value
