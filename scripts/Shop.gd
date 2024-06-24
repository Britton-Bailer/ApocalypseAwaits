extends Control

@onready var shopOptions = $HBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/ShopOptions

var map = preload("res://scenes/main.tscn")
var items = [preload("res://scripts/Items/SharpBullets.tres"), preload("res://scripts/Items/CoffeeMug.tres"), preload("res://scripts/Items/ExtendedMags.tres"), preload("res://scripts/Items/FastFingers.tres")]
var itemCard = preload("res://prefabs/ItemCard.tscn")

func _ready():
	for item in items:
		var newItemCard = itemCard.instantiate()
		newItemCard.set_vars(item)
		shopOptions.add_child(newItemCard)

func _on_next_round_pressed():
	get_tree().change_scene_to_packed(map)
