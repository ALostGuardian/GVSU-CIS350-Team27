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


func _on_savesButton_button_up():
	get_tree().change_scene("res://src/Scenes/saveMenu.tscn")
	pass # Replace with function body.


func _on_quitButton_button_up():
	get_tree().quit()
	pass # Replace with function body.


func _on_inventoryButton_button_up():
	#TODO
	pass # Replace with function body.


func _on_relationshipButton_button_up():
	get_tree().change_scene("res://src/Scenes/selectRelationshipScene.tscn")
	pass # Replace with function body.


func _on_battleButton_button_up():
	get_tree().change_scene("res://src/Scenes/BattleOne.tscn")
	pass # Replace with function body.
