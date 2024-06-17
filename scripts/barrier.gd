extends StaticBody2D

var health = 50

func take_damage(amt):
	print("damaged")
	health -= amt
	if(health <= 0):
		queue_free()

func set_pos(pos):
	position = pos
