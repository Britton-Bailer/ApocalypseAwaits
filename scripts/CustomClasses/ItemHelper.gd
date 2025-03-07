extends Node

class_name ItemHelper

func get_item_description(affectedStats):
	var desc = ""
	
	for prop in affectedStats.get_properties():
		if(prop.value != 0):
			desc += get_prop_change_description(prop)
			desc += "\n"
	
	return desc

func get_prop_change_description(prop):
	var desc = ""
	if(prop.type == "default"):
		if(prop.value > 0):
			desc += "+"
		desc += str(prop.value) + " " + str(prop.name)
	elif(prop.type == "multiplier"):
		desc += str(abs(prop.value*100)) + "% "
		if(prop.value > 0):
			desc += "increase "
		else:
			desc += "decrease "
		desc += "in " + str(prop.name)
	
	return desc
