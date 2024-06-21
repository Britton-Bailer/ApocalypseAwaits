extends Control

var map = preload("res://scenes/main.tscn")

func _on_play_pressed():
	get_tree().change_scene_to_packed(map)


func _on_controls_pressed():
	pass # Replace with function body.


#func _on_quit_pressed():
	#get_tree().quit()
