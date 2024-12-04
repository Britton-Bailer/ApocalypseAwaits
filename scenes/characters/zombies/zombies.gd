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
func zombie_name(zombie_type):
	return enumToNames[zombie_type]

enum zombieState {
	ROAMING,
	CHASING,
	ATTACK,
	IDLE,
}

var zombiePrefabs: Dictionary = {
	type.base: preload("res://scenes/characters/zombies/zombie.tscn"),
	type.throw: preload("res://scenes/characters/zombies/throw-zombie.tscn"),
	type.sucker: preload("res://scenes/characters/zombies/sucker-zombie.tscn"),
	type.suckerWitch: preload("res://scenes/characters/zombies/sucker-witch.tscn"),
	type.charger: preload("res://scenes/characters/zombies/charger.tscn"),
	type.baby: preload("res://scenes/characters/zombies/baby-zombie.tscn"),
	type.fragThrower: preload("res://scenes/characters/zombies/frag-thrower.tscn"),
}
