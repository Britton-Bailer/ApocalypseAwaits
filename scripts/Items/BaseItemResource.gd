extends Resource

class_name BaseItemResource

@export var itemName = "default"
@export var itemSprite = preload("res://sprites/Items/DefaultItemSprite.png")
@export var changedStats: ExpeditionStats

func apply_item(stats: ExpeditionStats):
	for prop in changedStats.get_properties():
		if(prop.value != 0):
			print(prop.name)
			stats[prop.varName] += prop.value
