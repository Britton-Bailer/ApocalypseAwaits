extends Control

func _on_resume_pressed():
	get_tree().paused = false #unpause
	visible = false #hide pause screen
