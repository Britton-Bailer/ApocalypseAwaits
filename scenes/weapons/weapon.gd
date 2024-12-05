extends Node2D

class_name Weapon

#varibles on every weapon
@onready var weapon_direction: Node2D = get_child(0)
@onready var weapon_sprite: Sprite2D = get_child(0).get_child(0)
@onready var hudManager = ExpeditionManager.hudManager
@onready var expeditionStats = ExpeditionManager.expeditionStats

@export var timeBetweenAttacks = 10
@export var maneuverability = 100

var lastAttackTimer = timeBetweenAttacks
var targetPosition = Vector2.ZERO
var targetMouse = true
var controlledByPlayer = true

func _ready():
	__ready()
	update_with_expedition_stats()

## rotate gun to mouse
func _process(delta):
	if(targetMouse):
		targetPosition = get_global_mouse_position()
	__process(delta)
	handle_weapon_rotation()
	if(controlledByPlayer):
		handle_input()
	
	#increase timer every frame
	lastAttackTimer += 1

func update_with_expedition_stats():
	__update_with_expedition_stats()
	maneuverability = float(min(maneuverability * expeditionStats.weaponManeuverabilityMultiplier, 25))

func handle_weapon_rotation():
	#keep weapon facing the right direction
	if (targetPosition.x < global_position.x):
		weapon_direction.scale.y = -1
	else:
		weapon_direction.scale.y = 1
		
	# lerp to mouse direction using maneuverability as speed
	rotation = lerp_angle(rotation, ((targetPosition - global_position).normalized()).angle(), deg_to_rad(maneuverability))

func handle_input():
	#if mouse primary pressed and time between shots has elapsed, shoot primary
	if(Input.is_action_pressed("weapon_primary") && lastAttackTimer > timeBetweenAttacks):
		__primary_attack()
	
	#if mouse secondary pressed and time between shots has elapsed, shoot secondary
	if(Input.is_action_pressed("weapon_secondary")):
		__secondary_attack()

	__handle_input()

## overwrite this when creating a new weapon
func __ready():
	pass
	
## overwrite this to add functionality that runs every frame
func __process(_delta):
	pass

func __update_with_expedition_stats():
	pass

func __primary_attack():
	pass

func __secondary_attack():
	pass

func __handle_input():
	pass
