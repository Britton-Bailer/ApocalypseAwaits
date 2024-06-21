extends Area2D

var worth = 1

func _on_body_entered(body):
	MissionManager.money_picked_up(worth)
	queue_free()
