extends RichTextLabel
@onready var weapon = %Weapon

func _process(delta):
	
	if(weapon.reloading):
		text = (str(round(weapon.magSize * (float(weapon.reloadTimer)/float(weapon.reloadTime)))) + "/" + str(weapon.magSize))
	else:
		text = str(weapon.mag) + "/" + str(weapon.magSize)
	
