extends Node

class_name enums

## mission type
enum missionType {
	missionSelect,
	defense,
	eradicate,
	extraction,
	boss,
	bounty,
	piggyBank,
}
var missionTypeNames = [
	"Mission Selection",
	"Defense",
	"Eradicate",
	"Extraction",
	"Boss",
	"Bounty",
	"Piggy Bank",
]

func mission_name(type):
	if(type == missionType.missionSelect):
		return "Mission Selection"
	
	return missionTypeNames[type]
