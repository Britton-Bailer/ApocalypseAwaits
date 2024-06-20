extends Area2D

func _on_body_entered(body):
	MissionManager.extract_attempt()
