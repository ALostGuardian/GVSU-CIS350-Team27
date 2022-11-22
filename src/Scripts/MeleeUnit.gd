class_name MeleeUnit
extends "res://src/Scripts/Unit.gd"


func _ready():
	isRanged = false
	health = 4
	move_range = 5
	attackPower = 2
	._ready()

func getRangeStatus():
	return false
