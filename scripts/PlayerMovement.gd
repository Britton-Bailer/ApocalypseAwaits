extends CharacterBody2D

const SPEED = 150.0

func _physics_process(delta):

	# set velocity to 0 when not moving
	velocity = Vector2(0, 0)

	var left = Input.is_action_pressed("left")
	if left:
		velocity.x = -SPEED
		
	var right = Input.is_action_pressed("right")
	if right:
		velocity.x = SPEED
	
	var up = Input.is_action_pressed("up")
	if up:
		velocity.y = -SPEED
		
	var down = Input.is_action_pressed("down")
	if down:
		velocity.y = SPEED
	
	move_and_slide()
