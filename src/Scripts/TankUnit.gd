class_name TankUnit
extends "res://src/Scripts/Unit.gd"


func _ready():
	isRanged = false
	health = 10
	move_range = 2
	attackPower = 1
	._ready()

func getRangeStatus():
	return false
