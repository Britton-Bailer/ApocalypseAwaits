extends RichTextLabel
var weapon

func _process(_delta):
	if (weapon == null):
		return
	
	if(weapon.reloading):
		text = (str(round(weapon.magSize * (float(weapon.reloadTimer)/float(weapon.reloadTime)))) + "/" + str(weapon.magSize))
	else:
		text = str(weapon.mag) + "/" + str(weapon.magSize)
	
func set_weapon(wpn):
	weapon = wpn
