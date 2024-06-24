extends RichTextLabel

var timer: Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(timer == null):
		return
	
	text = "[center]" + str(snapped(timer.time_left, 1)) + "[/center]"

func set_timer(tmr):
	timer = tmr
