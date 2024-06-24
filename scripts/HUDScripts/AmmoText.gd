extends RichTextLabel
var weapon

func _process(_delta):
	if (weapon == null):
		return
	
	if(weapon.reloading):
		text = "[center]" + (str(round(weapon.magSize * (float(weapon.reloadTimer)/float(weapon.reloadTime)))) + "/" + str(weapon.magSize)) + "[/center]"
	else:
		text = "[center]" + str(weapon.mag) + "/" + str(weapon.magSize) + "[/center]"
	
func set_weapon(wpn):
	weapon = wpn
