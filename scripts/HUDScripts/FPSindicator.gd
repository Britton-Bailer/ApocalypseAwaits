extends RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "fps: " + str(Engine.get_frames_per_second())
