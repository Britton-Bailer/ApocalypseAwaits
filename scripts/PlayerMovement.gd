extends RigidBody2D

const SPEED = 150.0

func _physics_process(delta):

	var left = Input.is_action_pressed("left")
	if left:
		linear_velocity.x = -SPEED
		
	var right = Input.is_action_pressed("right")
	if right:
		linear_velocity.x = SPEED
	
	var up = Input.is_action_pressed("up")
	if up:
		linear_velocity.y = -SPEED
		
	var down = Input.is_action_pressed("down")
	if down:
		linear_velocity.y = SPEED

