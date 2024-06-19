extends Node

class_name enums

enum zombie {
	base,
	throw,
	baby,
	sucker,
	suckerWitch,
	charger,
}
var zombieTypeNames = [
	"Base",
	"Thrower",
	"Baby Zombie",
	"Sucker",
	"Sucker Witch",
	"Charger",
]
func zombie_name(type):
	return zombieTypeNames[type]

enum zombieState {
	ROAMING,
	CHASING,
	ATTACK,
}

## mission type
enum missionType {
	defense,
	eradicate,
	extraction,
	boss,
	bounty,
	piggyBank,
}
var missionTypeNames = [
	"Defense",
	"Eradicate",
	"Extraction",
	"Boss",
	"Bounty",
	"Piggy Bank",
]
func mission_name(type):
	return missionTypeNames[type]
