extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


func _on_savesButton_button_up():
	#connect to saves menu
	get_tree().change_scene("res://src/Scenes/saveMenu.tscn")
	pass 


func _on_quitButton_button_up():
	get_tree().quit()
	pass 
