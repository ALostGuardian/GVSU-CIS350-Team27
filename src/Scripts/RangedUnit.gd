class_name RangedUnit 
extends "res://src/Scripts/Unit.gd"

func _ready():
	_sprite = $PathFollow2D/RangeSprite
	attackPower = 1
	health = 2
	move_range = 5
	isRanged = true
	._ready()

func getRangeStatus():
	return true
