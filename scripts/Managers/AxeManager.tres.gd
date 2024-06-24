extends Area2D

@onready var axeSprite = $AxeSprite
@onready var axeHeadCollider = $AxeHead

var xAxis = 15
var yAxis = 0

var swingCoolDown = 0
var finalSwing = false
var damage = 500
var OriginalPosition
var notAnimating = true

var animationOffset = Vector2 (20,5)
var colliderOffset = Vector2 (9,-6)

func _ready ():
	axeHeadCollider.disabled = true

func _process(delta):
	var axeHeadPosition = axeSprite.global_position + colliderOffset.rotated(axeSprite.global_rotation)
	
	axeHeadCollider.global_position = axeHeadPosition
	
	OriginalPosition = get_parent().global_position
	
	
	if(Input.is_action_pressed("shoot") && not finalSwing):
		axeSprite.play ("Swing")
		notAnimating = false
		axeSprite.global_position = OriginalPosition + animationOffset.rotated(axeSprite.global_rotation)
		#axeSprite.global_position = Vector2(xAxis,yAxis).rotated(axeSprite.global_rotation)
		#axeSprite.global_position = axeSprite.global_position + Vector2(xAxis,yAxis).rotated(axeSprite.global_rotation)
	#else:
		#axeSprite.global_position = OriginalPosition
		#axeSprite.global_position = OriginalPosition
		#axeSprite.play("default")
	
	var mouse_position = get_global_mouse_position()
	
	if notAnimating:
		look_at(mouse_position)
		axeSprite.global_position = OriginalPosition
	
	if (axeSprite.sweepingFrame == true):
		axeHeadCollider.disabled = false
		axeHeadCollider.shape.extents = Vector2 (12, 35)
		colliderOffset = Vector2 (7,-10)
	if (axeSprite.thirdFrame == true):
		colliderOffset = Vector2 (7, 4)
		axeHeadCollider.shape.extents = Vector2 (15, 10)
	if (axeSprite.fourthFrame == true):
		print_debug("4 swing")
	
	if finalSwing:
		swingCoolDown += 1
	
	if (swingCoolDown>= 50):
		swingCoolDown = 0
		finalSwing = false 


func _on_body_entered(body):

	if(body.has_method("take_damage")):
		body.take_damage(damage)




func _on_axe_sprite_animation_finished():
	finalSwing = true
	colliderOffset = Vector2 (9, -6)
	axeHeadCollider.disabled = true
	axeSprite.global_position = OriginalPosition
	axeSprite.play("default")
	notAnimating = true
