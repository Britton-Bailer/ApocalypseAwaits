extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _process(delta):
	text = "Mission: " + MissionManager.get_mission_name()
