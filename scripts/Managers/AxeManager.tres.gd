extends Area2D

@onready var axeSprite = $AxeSprite
@onready var axeHeadCollider = $AxeHead
@export var xAxis = 0
@export var yAxis = 0

var swingCoolDown = 0
var finalSwing = false
var damage = 500
var OriginalPosition

var OFFSET = Vector2 (9,-6)
	
func _process(delta):
	var axeHeadPosition = axeSprite.global_position + OFFSET.rotated(axeSprite.global_rotation)
	
	axeHeadCollider.global_position = axeHeadPosition
	
	OriginalPosition = get_parent().global_position
	axeSprite.global_position = OriginalPosition
	
	if(Input.is_action_pressed("shoot") && not finalSwing):
		axeSprite.play ("Swing")
		axeSprite.global_position = axeSprite.global_position + Vector2(xAxis,yAxis).rotated(axeSprite.global_rotation)
		#axeSprite.global_position = axeSprite.global_position + Vector2(xAxis,yAxis).rotated(axeSprite.global_rotation)
	#else:
		#axeSprite.global_position = OriginalPosition
		#axeSprite.global_position = OriginalPosition
		#axeSprite.play("default")
	
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	
	if (axeSprite.sweepingFrame == true):
		axeHeadCollider.disabled = false
		axeHeadCollider.shape.extents = Vector2 (12, 45)
		OFFSET = Vector2 (17, -12)
	if (axeSprite.thirdFrame == true):
		OFFSET = Vector2 (15, -1)
		axeHeadCollider.shape.extents = Vector2 (15, 10)
		#axeHeadCollider.collision_shape.set_deferred("disabled", false)
	if (axeSprite.fourthFrame == true):
		print_debug("4 swing")
	
	if finalSwing:
		swingCoolDown += 1
	
	if (swingCoolDown>= 50):
		swingCoolDown = 0
		finalSwing = false 



func _on_body_entered(body):
		#if thing hit can take damage, make it take bullets damage
	if(body.has_method("take_damage")):
		body.take_damage(damage)




func _on_axe_sprite_animation_finished():
	finalSwing = true
	OFFSET = Vector2 (9, -6)
	axeHeadCollider.disabled = true
	axeSprite.global_position = OriginalPosition
	axeSprite.play("default")
