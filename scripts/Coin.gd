extends Area2D

func _on_body_entered(body):
	MissionManager.money_picked_up()
	queue_free()
