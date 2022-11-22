class_name GoblinUnit 
extends "res://src/Scripts/Unit.gd"

func _ready():
	_sprite = $PathFollow2D/RangeSprite
	attackPower = 3
	health = 1
	move_range = 5
	isRanged = true
	._ready()

func getRangeStatus():
	return false
