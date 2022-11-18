extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_save1_button_up():
	get_tree().change_scene("res://src/Scenes/outOfBattleMenu.tscn")
	pass # Replace with function body.


func _on_save2_button_up():
	get_tree().change_scene("res://src/Scenes/outOfBattleMenu.tscn")
	pass # Replace with function body.


func _on_save3_button_up():
	get_tree().change_scene("res://src/Scenes/outOfBattleMenu.tscn")
	pass # Replace with function body.


func _on_save4_button_up():
	get_tree().change_scene("res://src/Scenes/outOfBattleMenu.tscn")
	pass # Replace with function body.


func _on_save5_button_up():
	get_tree().change_scene("res://src/Scenes/outOfBattleMenu.tscn")
	pass # Replace with function body.


func _on_exitButton_button_up():
	get_tree().quit()
	pass # Replace with function body.
