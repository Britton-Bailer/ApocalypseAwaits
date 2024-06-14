extends RigidBody2D

const SPEED = 150.0
var maxHealth = 100
var health = maxHealth

func _physics_process(_delta):
	movement()


func movement():
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

func take_damage(dmg):
	health -= dmg
	
	if(health <= 0):
		pass #game_over()
