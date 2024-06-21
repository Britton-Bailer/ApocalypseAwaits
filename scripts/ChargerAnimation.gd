extends AnimatedSprite2D

@onready var chargerNode = get_node("res://scripts/Charger.gd")

# Called when the node enters the scene tree for the first time.
func _process(delta):
		chargerNode.connect("windUp", on_charge_up)


func on_charge_up():
	%Sprite.frame = 1
