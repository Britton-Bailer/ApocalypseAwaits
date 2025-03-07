extends Node2D

class_name Zombies

enum type {
	base,
	throw,
	baby,
	sucker,
	suckerWitch,
	charger,
	fragThrower,
}

var nameToEnum = {
	"Base": type.base,
	"Thrower": type.throw,
	"Baby": type.baby,
	"Sucker": type.sucker,
	"Sucker Witch": type.suckerWitch,
	"Charger": type.charger,
	"Frag Thrower": type.fragThrower,
}

var enumToNames = [
	"Base",
	"Thrower",
	"Baby",
	"Sucker",
	"Sucker Witch",
	"Charger",
	"Frag Thrower",
]
func zombie_name(type):
	return enumToNames[type]

enum zombieState {
	ROAMING,
	CHASING,
	ATTACK,
	IDLE,
}

var zombiePrefabs: Dictionary = {
	type.base: preload("res://prefabs/zombies/zombie.tscn"),
	type.throw: preload("res://prefabs/zombies/throwZombie.tscn"),
	type.sucker: preload("res://prefabs/zombies/suckerZombie.tscn"),
	type.suckerWitch: preload("res://prefabs/zombies/suckerWitch.tscn"),
	type.charger: preload("res://prefabs/zombies/charger.tscn"),
	type.baby: preload("res://prefabs/zombies/babyZombie.tscn"),
	type.fragThrower: preload("res://prefabs/zombies/fragThrower.tscn"),
}
