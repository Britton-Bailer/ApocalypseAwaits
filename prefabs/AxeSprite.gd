extends AnimatedSprite2D

var firstFrame = false
var finalFrame = false
var thirdFrame = false
var fourthFrame = false
var sweepingFrame = false

# Called every frame. 'delta' is the elapsed time since the previous frame.





func _on_frame_changed():
	if frame == 0:
		firstFrame = true
	else:
		firstFrame = false
	if frame == 2:
		sweepingFrame = true
	else:
		sweepingFrame = false
	if frame == 3:
		thirdFrame = true
	else:
		thirdFrame = false
	if frame == 4:
		fourthFrame = true
	else:
		fourthFrame = false
	if frame == 5:
		emit_signal("animation_finished")
			


