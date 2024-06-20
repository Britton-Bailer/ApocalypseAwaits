extends Node

class_name enums

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
