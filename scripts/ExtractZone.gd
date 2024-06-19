extends Area2D

func _on_body_entered(body):
	RoundManager.extract_attempt()
