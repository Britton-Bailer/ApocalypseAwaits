extends Area2D

func _on_body_entered(body):
	ExpeditionManager.extract_attempt()
