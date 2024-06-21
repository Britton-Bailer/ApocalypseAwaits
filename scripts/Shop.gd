extends Control

var map = preload("res://scenes/main.tscn")

func _on_next_round_pressed():
	get_tree().change_scene_to_packed(map)
