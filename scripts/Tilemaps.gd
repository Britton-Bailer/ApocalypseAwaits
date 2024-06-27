extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ExpeditionManager.set_tilemaps(get_children(), self)
