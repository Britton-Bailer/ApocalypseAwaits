extends Control

var mainMenu = "res://scenes/MainMenu.tscn"

func _on_resume_pressed():
	get_tree().paused = false #unpause
	visible = false #hide pause screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _on_main_menu_pressed():
	get_tree().paused = false #unpause
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
